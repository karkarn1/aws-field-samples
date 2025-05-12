resource "aws_bedrockagent_agent_action_group" "action_groups" {
  count                      = length(var.action_groups)
  action_group_name          = var.action_groups[count.index].name
  action_group_state         = var.action_groups[count.index].state
  agent_id                   = aws_bedrockagent_agent.agent.agent_id
  agent_version              = "DRAFT"
  description                = var.action_groups[count.index].description
  skip_resource_in_use_check = var.action_groups[count.index].skip_resource_in_use_check

  dynamic "action_group_executor" {
    for_each = var.action_groups[count.index].executor.custom_control != null ? [var.action_groups[count.index].executor.custom_control] : []
    content {
      custom_control = action_group_executor.value
    }
  }

  dynamic "action_group_executor" {
    for_each = var.action_groups[count.index].executor.lambda != null ? [var.action_groups[count.index].executor.lambda.arn] : []
    content {
      lambda = action_group_executor.value
    }
  }

  dynamic "api_schema" {
    for_each = var.action_groups[count.index].api_schema.payload != null ? [var.action_groups[count.index].api_schema.payload] : []
    content {
      payload = api_schema.value
    }
  }

  dynamic "api_schema" {
    for_each = var.action_groups[count.index].api_schema.s3 != null ? [var.action_groups[count.index].api_schema.s3] : []
    content {
      s3 {
        s3_bucket_name = api_schema.value.bucket_name
        s3_object_key  = api_schema.value.object_key
      }
    }
  }

  function_schema {
    member_functions {
      dynamic "functions" {
        for_each = try(var.action_groups[count.index].executor.lambda.schema, [])
        content {
          name        = functions.value.name
          description = functions.value.description
          dynamic "parameters" {
            for_each = try(functions.value.parameters, [])
            content {
              map_block_key = parameters.value.name
              type          = parameters.value.type
              description   = parameters.value.description
              required      = try(parameters.value.required, false)
            }
          }
        }
      }
    }
  }
}
