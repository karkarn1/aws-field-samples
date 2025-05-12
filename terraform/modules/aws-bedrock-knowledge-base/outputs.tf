output "knowledge_base" {
  description = "The knowledge base."
  value       = aws_bedrockagent_knowledge_base.knowledge_base
}

output "oss_collection" {
  value = aws_opensearchserverless_collection.collection
}
