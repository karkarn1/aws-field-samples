resource "aws_opensearchserverless_security_policy" "encryption" {
  name        = "${var.name}-encryption"
  type        = "encryption"
  description = "Encryption policy for ${var.name}"
  policy = jsonencode({
    Rules = [
      {
        ResourceType = "collection",
        Resource     = ["collection/${var.name}"]
      }
    ],
    AWSOwnedKey = true
  })
}


resource "aws_opensearchserverless_access_policy" "access" {
  name        = var.name
  type        = "data"
  description = "read and write permissions"
  policy = jsonencode([
    {
      Description = "Full access to collection and indices",
      Principal = concat([
        aws_iam_role.kb_role.arn,
        data.aws_caller_identity.current.arn,
        aws_iam_role.oss_index_manager_lambda_role.arn
      ], var.oss_access_policy_principals_arns),
      Rules = [
        {
          ResourceType = "index",
          Resource     = ["index/${var.name}/*"],
          Permission   = ["aoss:*"]
        },
        {
          ResourceType = "collection",
          Resource     = ["collection/${var.name}"],
          Permission   = ["aoss:*"]
        }
      ]
    },
    {
      Description = "Specific Lambda access for index creation",
      Principal   = [aws_iam_role.oss_index_manager_lambda_role.arn],
      Rules = [
        {
          ResourceType = "index",
          Resource     = ["index/${var.name}/bedrock-knowledge-base-default-index"],
          Permission   = ["aoss:*"]
        }
      ]
    }
  ])
}

resource "aws_opensearchserverless_security_policy" "network" {
  name        = "${var.name}-network"
  type        = "network"
  description = "Network access policy for ${var.name}"

  policy = jsonencode([
    {
      Description = "Bedrock service access to collection endpoints",
      Rules = [
        {
          ResourceType = "collection",
          Resource     = ["collection/${var.name}"]
        },
        {
          ResourceType = "dashboard",
          Resource     = ["collection/${var.name}"]
        }
      ],
      AllowFromPublic = false,
      SourceServices  = ["bedrock.amazonaws.com"]
    },
    {
      Description = "VPC access to collection endpoints",
      Rules = [
        {
          ResourceType = "collection",
          Resource     = ["collection/${var.name}"]
        },
        {
          ResourceType = "dashboard",
          Resource     = ["collection/${var.name}"]
        }
      ],
      AllowFromPublic = false,
      SourceVPCEs     = var.oss_vpc_endpoints
    },
    {
      Description     = "Dashboard",
      AllowFromPublic = true
      Rules = [
        {
          ResourceType = "dashboard",
          Resource     = ["collection/${var.name}"]
        }
      ],
    },
    {
      Description = "Allow Bedrock service access",
      Rules = [
        {
          ResourceType = "collection",
          Resource     = ["collection/${var.name}"]
        }
      ],
      SourceServices = ["bedrock.amazonaws.com"]
    }
  ])
}


resource "aws_opensearchserverless_collection" "collection" {
  name        = var.name
  type        = "VECTORSEARCH"
  description = "Knowledge base for ${var.name}"

  depends_on = [
    aws_opensearchserverless_access_policy.access,
    aws_opensearchserverless_security_policy.encryption,
    aws_opensearchserverless_security_policy.network
  ]
}
