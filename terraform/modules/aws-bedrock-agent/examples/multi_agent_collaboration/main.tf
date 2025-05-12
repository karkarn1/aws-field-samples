module "collaborator_agent_1" {
  source                      = "../../"
  agent_name                  = "collaborator-1"
  instruction                 = "You are a general purpose chatbot assistant."
  idle_session_ttl_in_seconds = 500
  foundation_model            = "us.anthropic.claude-3-7-sonnet-20250219-v1:0"
  prepare_agent               = true
  skip_resource_in_use_check  = true
}


module "collaborator_agent_2" {
  source                      = "../../"
  agent_name                  = "collaborator-2"
  instruction                 = "You are a general purpose chatbot assistant."
  idle_session_ttl_in_seconds = 500
  foundation_model            = "us.anthropic.claude-3-7-sonnet-20250219-v1:0"
  prepare_agent               = true
  skip_resource_in_use_check  = true
}

module "supervisor_agent" {
  source                      = "../../"
  agent_collaboration         = "SUPERVISOR"
  agent_name                  = "supervisor"
  instruction                 = "You are a general purpose chatbot assistant."
  idle_session_ttl_in_seconds = 500
  foundation_model            = "us.anthropic.claude-3-7-sonnet-20250219-v1:0"
  prepare_agent               = false
  skip_resource_in_use_check  = true
  agent_collaborators = [
    {
      name                       = "collaborator-1",
      instruction                = "You are a general purpose chatbot assistant."
      agent_alias_arn            = module.collaborator_agent_1.agent_alias.agent_alias_arn
      relay_conversation_history = "TO_COLLABORATOR"
    },
    {
      name                       = "collaborator-2",
      instruction                = "You are a general purpose chatbot assistant."
      agent_alias_arn            = module.collaborator_agent_2.agent_alias.agent_alias_arn
      relay_conversation_history = "TO_COLLABORATOR"
    }
  ]
  depends_on = [
    module.collaborator_agent_1,
    module.collaborator_agent_2
  ]
}
