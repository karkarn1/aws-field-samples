# AWS Bedrock Agent Terraform Module

<!-- BEGIN_TF_DOCS -->
#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.97.0, <6 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.4, <4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.13.1, <0.14 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.97.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.13.1 |

#### Resources

| Name | Type |
|------|------|
| [aws_bedrockagent_agent.agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_agent) | resource |
| [aws_bedrockagent_agent_action_group.action_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_agent_action_group) | resource |
| [aws_bedrockagent_agent_alias.agent_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_agent_alias) | resource |
| [aws_bedrockagent_agent_collaborator.agent_collaborators](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_agent_collaborator) | resource |
| [aws_bedrockagent_agent_knowledge_base_association.knowledge_base_associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_agent_knowledge_base_association) | resource |
| [aws_iam_role.bedrock_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.bedrock_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [null_resource.prepare_agent](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [time_sleep.wait_bedrock_agent_resources](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_bedrock_agent_role_policy_propagation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.agent_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bedrock_agent_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_name"></a> [agent\_name](#input\_agent\_name) | Name of the agent. | `string` | n/a | yes |
| <a name="input_foundation_model"></a> [foundation\_model](#input\_foundation\_model) | Foundation model used for orchestration by the agent. | `string` | n/a | yes |
| <a name="input_instruction"></a> [instruction](#input\_instruction) | Instructions that tell the agent what it should do and how it should interact with users. | `string` | n/a | yes |
| <a name="input_action_groups"></a> [action\_groups](#input\_action\_groups) | n/a | <pre>list(object({<br/>    name                       = string<br/>    description                = optional(string)<br/>    skip_resource_in_use_check = optional(bool, true)<br/>    state                      = optional(string, "ENABLED")<br/>    executor = object({<br/>      custom_control = optional(string, null)<br/>      lambda = optional(object({<br/>        arn = string<br/>        schema = list(object({<br/>          name        = string<br/>          description = optional(string)<br/>          parameters = optional(list(object({<br/>            name        = string<br/>            type        = string<br/>            description = optional(string)<br/>            required    = optional(bool, false)<br/>          })))<br/>        }))<br/>      }))<br/>    })<br/>    api_schema = optional(object({<br/>      payload = optional(string)<br/>      s3 = optional(object({<br/>        bucket_name = string<br/>        object_key  = string<br/>      }))<br/>    }), {})<br/>  }))</pre> | `[]` | no |
| <a name="input_agent_collaboration"></a> [agent\_collaboration](#input\_agent\_collaboration) | Agent collaboration role. DISABLED means standalone agent, SUPERVISOR allows agent to be a supervisor, SUPERVISOR\_ROUTER allows routing to other agents. | `string` | `"DISABLED"` | no |
| <a name="input_agent_collaborators"></a> [agent\_collaborators](#input\_agent\_collaborators) | n/a | <pre>list(object({<br/>    name                       = string<br/>    instruction                = string<br/>    agent_alias_arn            = string<br/>    relay_conversation_history = string<br/>  }))</pre> | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the agent. | `string` | `null` | no |
| <a name="input_guardrail"></a> [guardrail](#input\_guardrail) | Configuration for the guardrail used by the agent. | <pre>object({<br/>    id      = string<br/>    version = string<br/>  })</pre> | `null` | no |
| <a name="input_idle_session_ttl_in_seconds"></a> [idle\_session\_ttl\_in\_seconds](#input\_idle\_session\_ttl\_in\_seconds) | Number of seconds for which Amazon Bedrock keeps information about a user's conversation with the agent. A user interaction remains active for the amount of time specified. If no conversation occurs during this time, the session expires and Amazon Bedrock deletes any data provided before the timeout. | `number` | `3600` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of the KMS key used to encrypt the agent. | `string` | `null` | no |
| <a name="input_knowledge_bases"></a> [knowledge\_bases](#input\_knowledge\_bases) | List of Bedrock knowledge base configurations | <pre>list(object({<br/>    id          = string<br/>    base_state  = optional(string, "ENABLED")<br/>    description = string<br/>    })<br/>  )</pre> | `[]` | no |
| <a name="input_prepare_agent"></a> [prepare\_agent](#input\_prepare\_agent) | Whether to prepare the agent after creation or modification. | `bool` | `true` | no |
| <a name="input_skip_resource_in_use_check"></a> [skip\_resource\_in\_use\_check](#input\_skip\_resource\_in\_use\_check) | Whether the in-use check is skipped when deleting the action group. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the resources. | `map(string)` | `{}` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_agent"></a> [agent](#output\_agent) | n/a |
| <a name="output_agent_alias"></a> [agent\_alias](#output\_agent\_alias) | n/a |
<!-- END_TF_DOCS -->

## Authors
- [Karim Abou-Khalil](mailto:kabouk@amazon.com)
