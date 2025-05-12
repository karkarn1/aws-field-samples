terraform {
  required_version = ">= 1.11.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.97.0, <6"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.4, <4"
    }
  }
}
