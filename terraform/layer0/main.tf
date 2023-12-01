
terraform {
  required_version = "1.6.0"

  backend "local" {
    path = "terraform.tfstate"
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

resource "aws_s3_bucket" "s3be" {
  bucket = var.bucket
  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_s3be" }
  )
}

resource "aws_s3_bucket_versioning" "s3be" {
  bucket = aws_s3_bucket.s3be.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "s3be" {
  name           = var.dynamodb
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_s3be" }
  )
}
