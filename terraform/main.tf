terraform {
  required_version = "1.6.0"

  backend "s3" {
    encrypt = true
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
  prefix  = var.prefix
  project = var.project
  region  = var.region

  common_tags = {
    Project   = var.project
    ManagedBy = "Terraform"
  }
}

# be able to get data about the current region
data "aws_region" "current" {}
