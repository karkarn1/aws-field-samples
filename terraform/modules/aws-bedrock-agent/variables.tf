variable "action_groups" {
  type = list(object({
    name                       = string
    description                = optional(string)
    skip_resource_in_use_check = optional(bool, true)
    state                      = optional(string, "ENABLED")
    executor = object({
      custom_control = optional(string, null)
      lambda = optional(object({
        arn = string
        schema = list(object({
          name        = string
          description = optional(string)
          parameters = optional(list(object({
            name        = string
            type        = string
            description = optional(string)
            required    = optional(bool, false)
          })))
        }))
      }))
    })
    api_schema = optional(object({
      payload = optional(string)
      s3 = optional(object({
        bucket_name = string
        object_key  = string
      }))
    }), {})
  }))
  default = []
}

variable "agent_collaboration" {
  type        = string
  description = "Agent collaboration role. DISABLED means standalone agent, SUPERVISOR allows agent to be a supervisor, SUPERVISOR_ROUTER allows routing to other agents."
  default     = "DISABLED"
  validation {
    condition     = contains(["DISABLED", "SUPERVISOR", "SUPERVISOR_ROUTER"], var.agent_collaboration)
    error_message = "The value must be one of DISABLED, SUPERVISOR, or SUPERVISOR_ROUTER."
  }
}

variable "agent_collaborators" {
  type = list(object({
    name                       = string
    instruction                = string
    agent_alias_arn            = string
    relay_conversation_history = string
  }))
  default = []
}

variable "agent_name" {
  type        = string
  description = "Name of the agent."
}

variable "description" {
  type        = string
  description = "Description of the agent."
  default     = null
}

variable "foundation_model" {
  description = "Foundation model used for orchestration by the agent."
  type        = string
}

variable "guardrail" {
  type = object({
    id      = string
    version = string
  })
  description = "Configuration for the guardrail used by the agent."
  default     = null
}

variable "idle_session_ttl_in_seconds" {
  description = "Number of seconds for which Amazon Bedrock keeps information about a user's conversation with the agent. A user interaction remains active for the amount of time specified. If no conversation occurs during this time, the session expires and Amazon Bedrock deletes any data provided before the timeout."
  type        = number
  default     = 3600
}

variable "instruction" {
  description = "Instructions that tell the agent what it should do and how it should interact with users."
  type        = string
  validation {
    condition     = length(var.instruction) >= 40 && length(var.instruction) <= 8000
    error_message = "The length of the instructions must be between 40 and 8000 characters."
  }
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS key used to encrypt the agent."
  default     = null
}

variable "knowledge_bases" {
  description = "List of Bedrock knowledge base configurations"
  type = list(object({
    id          = string
    base_state  = optional(string, "ENABLED")
    description = string
    })
  )
  default = []
}


variable "prepare_agent" {
  type        = bool
  description = "Whether to prepare the agent after creation or modification."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resources."
  default     = {}
}

variable "skip_resource_in_use_check" {
  type        = bool
  description = "Whether the in-use check is skipped when deleting the action group."
  default     = true
}

