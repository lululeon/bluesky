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
  region = data.terraform_remote_state.layer1.outputs.region
}


locals {
  # layer 1 remote state refs
  region     = var.region
  bucket     = var.bucket
  bucket_key = "${var.bucket_key}-layer1"
  dynamodb   = var.dynamodb

  own_ip      = data.terraform_remote_state.layer1.outputs.own_ip
  prefix      = data.terraform_remote_state.layer1.outputs.prefix
  common_tags = data.terraform_remote_state.layer1.outputs.common_tags
  pubkey      = var.bastion_keyname
  accountnum  = var.accountnum
  image       = var.image
}
