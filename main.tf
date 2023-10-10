terraform {
  required_version = "1.6.0"

  backend "s3" {
    # i.e. bucket name:
    bucket         = var.s3bucket
    key            = var.s3bucket_key
    region         = var.region
    encrypt        = true
    dynamodb_table = var.dynamodb_table
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.20"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  prefix = var.prefix

  common_tags = {
    Project   = var.project
    ManagedBy = "Terraform"
  }
}
