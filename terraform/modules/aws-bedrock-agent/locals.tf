locals {

  lambda_function_arns = [
    for action_group in var.action_groups : action_group.executor.lambda.arn
  ]

  run_prepare_agent = var.agent_collaboration == "DISABLED" ? var.prepare_agent : false
}