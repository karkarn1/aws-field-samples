run "simple_agent" {
  command = plan
  variables {
    agent_collaboration         = "DISABLED"
    agent_name                  = "tf-test-agent"
    instruction                 = "You are a general purpose chatbot assistant."
    idle_session_ttl_in_seconds = 500
    foundation_model            = "us.anthropic.claude-3-7-sonnet-20250219-v1:0"
    prepare_agent               = true
  }
}
