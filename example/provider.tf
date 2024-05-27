
terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      version = ">= 4.0, < 6.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}
