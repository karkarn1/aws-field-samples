output "null_resource" {
  value       = null_resource.this
  sensitive   = false
  description = "This null resource"
}

output "env" {
  value       = var.env
  sensitive   = false
  description = "The environment name"
}
