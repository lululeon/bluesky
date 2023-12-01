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
