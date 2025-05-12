# AWS Bedrock Knowledge Base Terraform Module

<!-- BEGIN_TF_DOCS -->
#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.4 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.7.0, <3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.97.0, <6 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.4, <4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.13.1, <0.14 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.97.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.13.1 |

#### Resources

| Name | Type |
|------|------|
| [aws_bedrockagent_knowledge_base.knowledge_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_knowledge_base) | resource |
| [aws_iam_role.kb_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.oss_index_manager_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.bedrock_knowledge_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.oss_index_manager_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.oss_index_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_invocation.oss_index](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_lambda_layer_version.opensearch_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_opensearchserverless_access_policy.access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_access_policy) | resource |
| [aws_opensearchserverless_collection.collection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_collection) | resource |
| [aws_opensearchserverless_security_policy.encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_policy) | resource |
| [aws_opensearchserverless_security_policy.network](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_policy) | resource |
| [null_resource.build_lambda_layer](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [time_sleep.iam_propagation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [archive_file.oss_index_manager_funnction](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bedrock_kb_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kb_assume_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.oss_index_manager_lambda_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.oss_index_manager_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the knowledge base. | `string` | n/a | yes |
| <a name="input_embedding_model_configuration"></a> [embedding\_model\_configuration](#input\_embedding\_model\_configuration) | Details about the embeddings model that's used to convert the data source | <pre>object({<br/>    embedding_model_arn              = string<br/>    dimensions                       = optional(number)<br/>    embedding_data_type              = optional(string, "FLOAT32")<br/>    supplemental_data_storage_s3_uri = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the knowledge base. | `string` | n/a | yes |
| <a name="input_oss_vpc_endpoint_security_group_id"></a> [oss\_vpc\_endpoint\_security\_group\_id](#input\_oss\_vpc\_endpoint\_security\_group\_id) | OpenSearch Serverless VPC endpoint security group ID | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnet IDs | `list(string)` | n/a | yes |
| <a name="input_storage_configuration_type"></a> [storage\_configuration\_type](#input\_storage\_configuration\_type) | Type of storage configuration for the knowledge base. Valid values are: OPENSEARCH\_SERVERLESS | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of the KMS key used to encrypt the agent. | `string` | `null` | no |
| <a name="input_oss_access_policy_principals_arns"></a> [oss\_access\_policy\_principals\_arns](#input\_oss\_access\_policy\_principals\_arns) | List of arns of IAM users and roles to add to the access policy of the OpenSearch Serverless collection. | `list(string)` | `[]` | no |
| <a name="input_oss_configuration"></a> [oss\_configuration](#input\_oss\_configuration) | Configuration for OpenSearch Serverless when storage\_configuration\_type is OPENSEARCH\_SERVERLESS | <pre>object({<br/>    vector_index_name = optional(string, "bedrock-knowledge-base-default-index")<br/>    metadata_field    = optional(string, "AMAZON_BEDROCK_METADATA")<br/>    text_field        = optional(string, "AMAZON_BEDROCK_TEXT_CHUNK")<br/>    vector_field      = optional(string, "bedrock-knowledge-base-default-vector")<br/>  })</pre> | <pre>{<br/>  "metadata_field": "AMAZON_BEDROCK_METADATA",<br/>  "text_field": "AMAZON_BEDROCK_TEXT_CHUNK",<br/>  "vector_field": "bedrock-knowledge-base-default-vector",<br/>  "vector_index_name": "bedrock-knowledge-base-default-index"<br/>}</pre> | no |
| <a name="input_oss_vpc_endpoints"></a> [oss\_vpc\_endpoints](#input\_oss\_vpc\_endpoints) | OpenSearch Serverless VPC Endpoint List | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the resources. | `map(string)` | `null` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_knowledge_base"></a> [knowledge\_base](#output\_knowledge\_base) | The knowledge base. |
| <a name="output_oss_collection"></a> [oss\_collection](#output\_oss\_collection) | n/a |
<!-- END_TF_DOCS -->
