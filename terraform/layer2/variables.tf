variable "region" {
  type     = string
  default  = "us-east-1"
  nullable = false
}

variable "bastion_keyname" {
  description = "name of keypair for login on public servers. Must be created in target region"
  type        = string
  nullable    = false
}

variable "accountnum" {
  description = "the aws account of the ecr registry where your web app / api container image is hosted"
  type        = string
  nullable    = false
}

variable "image" {
  description = "the name of the image to pull from ECR (including version tag, eg ':latest')"
  type        = string
  nullable    = false
}

variable "bucket" {
  type     = string
  nullable = false
}

variable "bucket_key" {
  type     = string
  nullable = false
}

variable "dynamodb" {
  type     = string
  nullable = false
}
