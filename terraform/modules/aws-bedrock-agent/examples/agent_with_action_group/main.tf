module "agent" {
  source                      = "../../"
  agent_collaboration         = "DISABLED"
  agent_name                  = "agent"
  instruction                 = "You are a general purpose chatbot assistant."
  idle_session_ttl_in_seconds = 500
  foundation_model            = "us.anthropic.claude-3-7-sonnet-20250219-v1:0"
  prepare_agent               = true
  skip_resource_in_use_check  = true
  action_groups = [
    {
      name                       = "action_group_1"
      description                = "My action group 1"
      skip_resource_in_use_check = true
      executor = {
        lambda = {
          arn = "arn:aws:lambda:us-east-1:537124940578:function:hr-inlineagent-lambda-14904-us-east-1-537124940578"
          schema = [
            {
              name        = "function_1"
              description = "function 1"
              parameters = [
                {
                  name        = "param1"
                  description = "param 1"
                  type        = "string"
                  required    = true
                },
                {
                  name        = "param2"
                  description = "param 2"
                  type        = "integer"
                  required    = false
                },
              ]
            },
            {
              name        = "function_2"
              description = "function 2"
              parameters = [
                {
                  name        = "param1"
                  description = "param 1"
                  type        = "number"
                  required    = true
                },
                {
                  name        = "param2"
                  description = "param 2"
                  type        = "boolean"
                  required    = false
                },
                {
                  name        = "param3"
                  description = "param 3"
                  type        = "array"
                  required    = false
                },
              ]
            },
          ]
        }
      }
    }
  ]
}