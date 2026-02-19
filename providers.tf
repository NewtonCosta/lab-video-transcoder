terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 0.25"
    }
  }

  required_version = ">= 1.3"
}

provider "aws" {
  region = var.region
}

provider "awscc" {
  region = var.region
}
