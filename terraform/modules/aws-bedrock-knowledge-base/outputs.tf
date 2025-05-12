output "knowledge_base" {
  description = "AWS Bedrock Knowledge Base"
  value       = aws_bedrockagent_knowledge_base.knowledge_base
}

output "oss_collection" {
  description = "AWS OpenSearch Serverless Collection"
  value       = aws_opensearchserverless_collection.collection
}
