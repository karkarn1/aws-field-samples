resource "aws_bedrockagent_knowledge_base" "knowledge_base" {
  name        = var.name
  description = var.description
  role_arn    = aws_iam_role.kb_role.arn
  tags        = var.tags
  knowledge_base_configuration {
    type = "VECTOR"
    vector_knowledge_base_configuration {
      embedding_model_arn = var.embedding_model_configuration.embedding_model_arn
      embedding_model_configuration {
        bedrock_embedding_model_configuration {
          dimensions          = var.embedding_model_configuration.dimensions
          embedding_data_type = var.embedding_model_configuration.embedding_data_type
        }
      }
      dynamic "supplemental_data_storage_configuration" {
        for_each = var.embedding_model_configuration.supplemental_data_storage_s3_uri != null ? [1] : []
        content {
          storage_location {
            type = "S3"

            s3_location {
              uri = var.embedding_model_configuration.supplemental_data_storage_s3_uri
            }
          }
        }
      }
    }
  }
  storage_configuration {
    type = var.storage_configuration_type
    dynamic "opensearch_serverless_configuration" {
      for_each = var.storage_configuration_type == "OPENSEARCH_SERVERLESS" ? [var.oss_configuration] : []
      content {
        collection_arn    = aws_opensearchserverless_collection.collection.arn
        vector_index_name = opensearch_serverless_configuration.value.vector_index_name
        field_mapping {
          metadata_field = opensearch_serverless_configuration.value.metadata_field
          text_field     = opensearch_serverless_configuration.value.text_field
          vector_field   = opensearch_serverless_configuration.value.vector_field
        }
      }
    }
  }

  depends_on = [
    time_sleep.iam_propagation,
    aws_lambda_invocation.oss_index
  ]
}
