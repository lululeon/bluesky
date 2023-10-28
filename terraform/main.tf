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

# for constraining access to own ip
data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

locals {
  prefix  = var.prefix
  project = var.project
  region  = var.region
  pubkey  = var.bastion_keyname
  own_ip  = data.http.ip.response_body

  common_tags = {
    Project   = var.project
    ManagedBy = "Terraform"
  }
}

# be able to get data about the current region
data "aws_region" "current" {}
