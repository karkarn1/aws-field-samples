output "agent" {
  description = "AWS Bedrock Agent"
  value       = aws_bedrockagent_agent.agent
}

output "agent_alias" {
  description = "AWS Bedrock Agent Alias"
  value       = aws_bedrockagent_agent_alias.agent_alias
}
