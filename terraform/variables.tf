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

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default     = ["10.1.10.0/24", "10.1.11.0/24"]
}

variable "az_suffixes" {
  description = "Available Zone suffixes (a, b, etc) for use with resources."
  type        = list(string)
  default     = ["a", "b"]
}
