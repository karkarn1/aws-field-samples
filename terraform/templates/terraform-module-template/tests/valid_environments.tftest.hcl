# Test all valid environments
mock_provider "null" {
  # Mock the null provider
}

run "dev_environment" {
  command = apply

  variables {
    env = "dev"
  }

  assert {
    condition     = output.env == "dev"
    error_message = "Environment was not set to dev"
  }
}

run "staging_environment" {
  command = apply

  variables {
    env = "staging"
  }

  assert {
    condition     = output.env == "staging"
    error_message = "Environment was not set to staging"
  }
}

run "production_environment" {
  command = apply

  variables {
    env = "production"
  }

  assert {
    condition     = output.env == "production"
    error_message = "Environment was not set to production"
  }
}