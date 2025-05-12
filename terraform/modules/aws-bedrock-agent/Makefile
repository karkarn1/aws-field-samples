# Terraform Module Makefile
SHELL := /bin/bash

# Color definitions
RED := $(shell tput setaf 1 2>/dev/null || echo '')
GREEN := $(shell tput setaf 2 2>/dev/null || echo '')
YELLOW := $(shell tput setaf 3 2>/dev/null || echo '')
NC := $(shell tput sgr0 2>/dev/null || echo '') # No Color

# Phony targets
.PHONY: help init fmt validate lint lint-fix docs test security-scan clean all check tfsec trivy install-tool

# Default target
.DEFAULT_GOAL := help

###################
# Helper commands #
###################

help: ## Show this help message
	@echo "Terraform Module Management Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

clean: ## Clean .terraform directory and temporary files
	@echo "Cleaning Terraform files..."
	@rm -rf .terraform
	@find . -type d -name ".terraform" -exec rm -rf {} +
	@find . -type f -name "*.tfstate*" -not -path "./tests/*" -exec rm -f {} +
	@find . -type f -name ".terraform.lock.hcl" -exec rm -f {} +
	@echo "$(GREEN)✓ Clean completed$(NC)"

######################
# Terraform commands #
######################

init: ## Initialize Terraform working directory
	@echo "Initializing Terraform..."
	@terraform init -backend=false
	@echo "$(GREEN)✓ Terraform initialized$(NC)"

fmt: ## Format Terraform files
	@echo "Formatting Terraform files..."
	@terraform fmt -recursive -check=false -diff=true
	@echo "$(GREEN)✓ Formatting completed$(NC)"

validate: init ## Validate Terraform files
	@echo "Validating Terraform configuration..."
	@terraform validate
	@echo "$(GREEN)✓ Validation completed$(NC)"

#################
# Docs commands #
#################

docs: ## Generate Terraform documentation
	@echo "Generating module documentation..."
	@terraform-docs .
	@echo "$(GREEN)✓ Documentation generated$(NC)"

########################
# Security scan tools #
########################

trivy: ## Run Trivy security scan
	@echo "Running Trivy security scan..."
	@trivy fs .
	@echo "$(GREEN)✓ Trivy scan completed$(NC)"

###############
# QA commands #
###############

lint: init ## Lint Terraform files with TFLint
	@echo "Running TFLint..."
	@tflint --init
	@tflint --color --format compact
	@echo "$(GREEN)✓ Linting completed$(NC)"

lint-fix: init ## Lint and automatically fix Terraform files with TFLint
	@echo "Running TFLint with auto-fix..."
	@tflint --init
	@tflint --fix --color
	@echo "$(GREEN)✓ Linting & fixing completed$(NC)"

test: init ## Run Terraform tests
	@echo "Running Terraform tests..."
	@terraform test
	@echo "$(GREEN)✓ Tests completed$(NC)"

test-file: init ## Run a specific Terraform test file (usage: make test-file FILE=path/to/test.tftest.hcl)
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)Error: Please specify a test file with FILE=path/to/test.tftest.hcl$(NC)"; \
		exit 1; \
	fi; \
	echo "Running Terraform test file: $(FILE)"; \
	terraform test -filter=$(FILE); \
	echo "$(GREEN)✓ Test completed$(NC)"

qa: validate lint trivy test ## Run all checks (validate, lint, trivy, test)
	@echo "$(GREEN)✓ All checks passed!$(NC)"

qa-fix: fmt validate lint-fix trivy test ## Run all checks (format, validate, lint-fix, trivy, test)
	@echo "$(GREEN)✓ All checks passed!$(NC)"

################
# Meta targets #
################

all: clean init qa-fix docs test  ## Run all tasks (clean, init, check, docs, test, security)
	@echo "$(GREEN)✓ All tasks completed successfully!$(NC)"
