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
  # layer 1 remote state refs
  bucket_key_layer1 = "${var.bucket_key}-layer1"

  # bucket key for current layer
  bucket_key = "${var.bucket_key}-layer2"

  region      = var.region
  ports       = var.image_ports
  own_ip      = data.terraform_remote_state.layer1.outputs.own_ip
  prefix      = data.terraform_remote_state.layer1.outputs.prefix
  common_tags = data.terraform_remote_state.layer1.outputs.common_tags
  pubkey      = var.bastion_keyname
  accountnum  = var.accountnum
  image       = var.image
}
