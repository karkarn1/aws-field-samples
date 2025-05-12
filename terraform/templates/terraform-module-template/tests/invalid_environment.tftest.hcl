# Test invalid environment value
mock_provider "null" {
  # Mock the null provider
}

run "invalid_environment" {
  command = plan
  expect_failures = [
    var.env
  ]

  variables {
    env = "invalid"
  }
}
