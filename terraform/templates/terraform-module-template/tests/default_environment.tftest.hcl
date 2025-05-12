run "dev_environment" {
  command = apply

  assert {
    condition     = output.env == "dev"
    error_message = "Environment was not set to dev"
  }
}
