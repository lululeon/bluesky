variable "prefix" {
  type     = string
  default  = "bsky"
  nullable = false
}

variable "project" {
  type     = string
  default  = "BlueSky"
  nullable = false
}

variable "region" {
  type     = string
  default  = "us-east-1"
  nullable = false
}

variable "bastion_keyname" {
  description = "name of keypair for bastion login. Must be created in target region"
  type        = string
  nullable    = false
}
