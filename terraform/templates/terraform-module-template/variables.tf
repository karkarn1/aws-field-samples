variable "env" {
  description = "Name of the environment"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "production"], var.env)
    error_message = "Invalid environment name. Must be one of: dev, staging, production."
  }
}

