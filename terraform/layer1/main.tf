terraform {
  required_version = "1.6.0"

  backend "s3" {
    encrypt        = true
    bucket         = var.bucket
    key            = local.bucket_key
    region         = var.region
    dynamodb_table = var.dynamodb
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
  bucket_key          = "${var.bucket_key}-layer1"
  prefix              = var.prefix
  project             = var.project
  own_ip              = data.http.ip.response_body
  public_cidrs        = var.public_subnet_cidr_blocks
  private_cidrs       = var.private_subnet_cidr_blocks
  zones               = var.az_suffixes
  num_public_subnets  = length(var.public_subnet_cidr_blocks)
  num_private_subnets = length(var.private_subnet_cidr_blocks)
  common_tags = {
    Project   = var.project
    ManagedBy = "Terraform"
  }
}

