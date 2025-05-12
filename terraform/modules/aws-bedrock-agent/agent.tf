resource "aws_bedrockagent_agent" "agent" {
  #noinspection TfUnknownProperty
  agent_collaboration         = var.agent_collaboration
  agent_name                  = var.agent_name
  agent_resource_role_arn     = aws_iam_role.bedrock_agent.arn
  customer_encryption_key_arn = var.kms_key_arn
  instruction                 = var.instruction
  idle_session_ttl_in_seconds = var.idle_session_ttl_in_seconds
  foundation_model            = var.foundation_model
  prepare_agent               = local.run_prepare_agent
  skip_resource_in_use_check  = var.skip_resource_in_use_check
  tags                        = var.tags

  dynamic "guardrail_configuration" {
    for_each = var.guardrail != null ? var.guardrail : {}
    content {
      guardrail_identifier = guardrail_configuration.value.id
      guardrail_version    = guardrail_configuration.value.version
    }
  }
  depends_on = [
    time_sleep.wait_bedrock_agent_role_policy_propagation
  ]
}

resource "time_sleep" "wait_bedrock_agent_resources" {
  create_duration = "10s"
  depends_on = [
    aws_iam_role_policy.bedrock_agent,
    aws_bedrockagent_agent_action_group.action_groups,
    aws_bedrockagent_agent_knowledge_base_association.knowledge_base_associations,
  aws_bedrockagent_agent_collaborator.agent_collaborators]
}


resource "null_resource" "prepare_agent" {
  count = local.run_prepare_agent ? 0 : 1
  provisioner "local-exec" {
    command = file("${path.module}/scripts/prepare_agent.sh")
    environment = {
      AGENT_ID           = aws_bedrockagent_agent.agent.agent_id
      AWS_DEFAULT_REGION = data.aws_region.current.name
    }
  }
  depends_on = [
    time_sleep.wait_bedrock_agent_resources
  ]
}
resource "aws_bedrockagent_agent_alias" "agent_alias" {
  agent_alias_name = var.agent_name
  agent_id         = aws_bedrockagent_agent.agent.agent_id
  description      = var.description
  depends_on = [
    null_resource.prepare_agent
  ]
}

resource "aws_bedrockagent_agent_collaborator" "agent_collaborators" {
  # Only create agent collaborators if agent_collaboration is enabled and collaborators are defined
  count                      = var.agent_collaboration != "DISABLED" && length(var.agent_collaborators) > 0 ? length(var.agent_collaborators) : 0
  agent_id                   = aws_bedrockagent_agent.agent.agent_id
  collaboration_instruction  = var.agent_collaborators[count.index].instruction
  collaborator_name          = var.agent_collaborators[count.index].name
  relay_conversation_history = var.agent_collaborators[count.index].relay_conversation_history
  prepare_agent              = false

  agent_descriptor {
    alias_arn = var.agent_collaborators[count.index].agent_alias_arn
  }
}