terraform {
  required_version = ">= 1.11.4"
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.7.0, <3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.97.0, <6"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.4, <4"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.13.1, <0.14"
    }
  }
}
