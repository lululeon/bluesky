variable "prefix" {
  type     = string
  nullable = false
}

variable "project" {
  type     = string
  nullable = false
}

variable "region" {
  type     = string
  default  = "us-east-1"
  nullable = false
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
