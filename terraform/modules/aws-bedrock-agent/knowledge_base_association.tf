resource "aws_bedrockagent_agent_knowledge_base_association" "knowledge_base_associations" {
  count                = length(var.knowledge_bases)
  agent_id             = aws_bedrockagent_agent.agent.agent_id
  description          = var.knowledge_bases[count.index].description
  knowledge_base_id    = var.knowledge_bases[count.index].id
  knowledge_base_state = var.knowledge_bases[count.index].base_state
}
