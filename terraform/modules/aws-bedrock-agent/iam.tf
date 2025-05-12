data "aws_iam_policy_document" "bedrock_agent_trust" {
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
    condition {
      test     = "ArnLike"
      values   = ["arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:agent/*"]
      variable = "AWS:SourceArn"
    }
  }
}
data "aws_iam_policy_document" "agent_permissions" {
  statement {
    sid    = "BedrockPermissions"
    effect = "Allow"
    actions = [
      "bedrock:*",
    ]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = length(local.lambda_function_arns) > 0 ? [1] : []
    content {
      sid    = "LambdaInvokePermissions"
      effect = "Allow"
      actions = [
        "lambda:InvokeFunction"
      ]
      resources = local.lambda_function_arns
    }
  }
}

resource "aws_iam_role" "bedrock_agent" {
  assume_role_policy = data.aws_iam_policy_document.bedrock_agent_trust.json
  name               = "bedrock-agent-${var.agent_name}-${data.aws_region.current.name}"
  tags               = var.tags
}

resource "aws_iam_role_policy" "bedrock_agent" {
  policy = data.aws_iam_policy_document.agent_permissions.json
  role   = aws_iam_role.bedrock_agent.id
}

resource "time_sleep" "wait_bedrock_agent_role_policy_propagation" {
  create_duration = "10s"
  depends_on      = [aws_iam_role_policy.bedrock_agent]
}
