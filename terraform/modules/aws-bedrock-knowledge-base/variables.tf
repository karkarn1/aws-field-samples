variable "description" {
  type        = string
  description = "Description of the knowledge base."
}

variable "embedding_model_configuration" {
  type = object({
    embedding_model_arn              = string
    dimensions                       = optional(number)
    embedding_data_type              = optional(string, "FLOAT32")
    supplemental_data_storage_s3_uri = optional(string)
  })
  description = "Details about the embeddings model that's used to convert the data source"
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS key used to encrypt the agent."
  default     = null
}

variable "name" {
  type        = string
  description = "Name of the knowledge base."
}

variable "oss_configuration" {
  type = object({
    vector_index_name = optional(string, "bedrock-knowledge-base-default-index")
    metadata_field    = optional(string, "AMAZON_BEDROCK_METADATA")
    text_field        = optional(string, "AMAZON_BEDROCK_TEXT_CHUNK")
    vector_field      = optional(string, "bedrock-knowledge-base-default-vector")
  })
  description = "Configuration for OpenSearch Serverless when storage_configuration_type is OPENSEARCH_SERVERLESS"
  default = {
    vector_index_name = "bedrock-knowledge-base-default-index"
    metadata_field    = "AMAZON_BEDROCK_METADATA"
    text_field        = "AMAZON_BEDROCK_TEXT_CHUNK"
    vector_field      = "bedrock-knowledge-base-default-vector"
  }
}

variable "oss_vpc_endpoints" {
  type        = list(string)
  description = "OpenSearch Serverless VPC Endpoint List"
  default     = []
}


variable "oss_vpc_endpoint_security_group_id" {
  description = "OpenSearch Serverless VPC endpoint security group ID"
  type        = string
}

variable "storage_configuration_type" {
  type        = string
  description = "Type of storage configuration for the knowledge base. Valid values are: OPENSEARCH_SERVERLESS"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resources."
  default     = null
}

variable "oss_access_policy_principals_arns" {
  type        = list(string)
  description = "List of arns of IAM users and roles to add to the access policy of the OpenSearch Serverless collection."
  default     = []
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}
