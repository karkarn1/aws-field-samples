data "archive_file" "oss_index_manager_funnction" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_functions/oss-index-manager/src"
  output_path = "${path.module}/build/lambda_functions/oss-index-manager.zip"
}


data "aws_iam_policy_document" "oss_index_manager_lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "aws:SourceAccount"
    }
  }
}

data "aws_iam_policy_document" "oss_index_manager_lambda_policy" {
  statement {
    effect = "Allow"
    sid    = "Logging"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
  statement {
    effect = "Allow"
    sid    = "OpenSearch"
    actions = [
      "aoss:APIAccessAll",
      "aoss:CreateIndex",
      "aoss:DeleteIndex",
      "aoss:UpdateIndex",
      "aoss:DescribeIndex",
      "aoss:BatchGetCollection"
    ]
    resources = [
      aws_opensearchserverless_collection.collection.arn,
      "${aws_opensearchserverless_collection.collection.arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    sid    = "VPC"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface"
    ]
    resources = [
      "*"
    ]
  }
}
resource "aws_iam_role" "oss_index_manager_lambda_role" {
  name_prefix        = "${var.name}-lambda"
  assume_role_policy = data.aws_iam_policy_document.oss_index_manager_lambda_assume_role_policy.json
}

resource "aws_iam_role_policy" "oss_index_manager_lambda" {
  policy = data.aws_iam_policy_document.oss_index_manager_lambda_policy.json
  role   = aws_iam_role.oss_index_manager_lambda_role.id
}

resource "aws_lambda_function" "oss_index_manager" {
  function_name    = "${var.name}-oss-index-manager"
  description      = "Lambda function that manages OpenSearch Serverless indexes"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.13"
  role             = aws_iam_role.oss_index_manager_lambda_role.arn
  timeout          = 120
  memory_size      = 1024
  filename         = "${path.module}/build/lambda_functions/oss-index-manager.zip"
  source_code_hash = data.archive_file.oss_index_manager_funnction.output_base64sha256
  publish          = true
  layers           = [aws_lambda_layer_version.opensearch_layer.arn]
  kms_key_arn      = var.kms_key_arn

  logging_config {
    log_format = "JSON"
  }

  tracing_config {
    mode = "Active"
  }

  snap_start {
    apply_on = "PublishedVersions"
  }

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [var.oss_vpc_endpoint_security_group_id]
  }

  environment {
    variables = {
      ENV                 = var.tags.env
      OPENSEARCH_ENDPOINT = aws_opensearchserverless_collection.collection.collection_endpoint
      AWS_SERVICE_NAME    = "aoss"
      OSS_AWS_REGION      = data.aws_region.current.name
      COLLECTION_NAME     = var.name
    }
  }
  depends_on = [data.archive_file.oss_index_manager_funnction]
  lifecycle {
    ignore_changes = [
      qualified_arn,
      qualified_invoke_arn,
      version
    ]
  }
}


resource "aws_lambda_invocation" "oss_index" {
  function_name = aws_lambda_function.oss_index_manager.function_name
  input = jsonencode({
    host         = aws_opensearchserverless_collection.collection.collection_endpoint
    service_name = "aoss"
    aws_region   = data.aws_region.current.name
    operation    = "create"
    index_name   = var.oss_configuration.vector_index_name
    index_body = jsonencode({
      settings = {
        "index.knn"                = true
        number_of_shards           = 1
        "knn.algo_param.ef_search" = 512
        number_of_replicas         = 0
      }
      mappings = {
        properties = {
          (var.oss_configuration.vector_field) = {
            type      = "knn_vector"
            dimension = 1024
            method = {
              name       = "hnsw"
              engine     = "faiss"
              space_type = "l2"
              parameters = {
                ef_construction = 512,
                m               = 16
              }
            }
          }
          (var.oss_configuration.text_field) = {
            type     = "text"
            analyzer = "standard"
          }
          (var.oss_configuration.metadata_field) = {
            type = "object"
          }
        }
      }
    })
  })
}
