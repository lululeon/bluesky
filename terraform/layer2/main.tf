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
  # layer 1 remote state refs
  bucket_key_layer1 = "${var.bucket_key}-layer1"
  bucket            = var.bucket
  region            = var.region

  ports       = var.image_ports
  own_ip      = data.terraform_remote_state.layer1.outputs.own_ip
  prefix      = data.terraform_remote_state.layer1.outputs.prefix
  common_tags = data.terraform_remote_state.layer1.outputs.common_tags
  pubkey      = var.bastion_keyname
  accountnum  = var.accountnum
  image       = var.image
}
