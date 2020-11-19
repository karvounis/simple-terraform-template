terraform {
  required_version = ">= 0.12.0, < 0.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    template = ">= 2.0"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
