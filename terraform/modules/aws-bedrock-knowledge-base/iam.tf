data "aws_iam_policy_document" "kb_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["bedrock.amazonaws.com"]
      type        = "Service"
    }
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "aws:SourceAccount"
    }
  }
}

data "aws_iam_policy_document" "bedrock_kb_policy" {
  statement {
    effect = "Allow"
    actions = [
      "bedrock:*",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "aoss:*",
      "aoss:APIAccessAll",
      "aoss:BatchGetCollection",
      "aoss:CreateIndex",
      "aoss:DeleteIndex",
      "aoss:UpdateIndex",
      "aoss:DescribeIndex",
      "aoss:ReadDocument",
      "aoss:WriteDocument"
    ]
    resources = [
      aws_opensearchserverless_collection.collection.arn,
      "${aws_opensearchserverless_collection.collection.arn}/*",
      "*"
    ]
  }
}

resource "aws_iam_role" "kb_role" {
  name_prefix        = "${var.name}-kb"
  assume_role_policy = data.aws_iam_policy_document.kb_assume_role_policy_document.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "bedrock_knowledge_base" {
  role   = aws_iam_role.kb_role.name
  policy = data.aws_iam_policy_document.bedrock_kb_policy.json
}

resource "time_sleep" "iam_propagation" {
  create_duration = "10s"
  depends_on = [
    aws_iam_role_policy.bedrock_knowledge_base,
  ]
}
