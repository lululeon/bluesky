variable "prefix" {
  type    = string
  default = "bsky"
}

variable "project" {
  type    = string
  default = "BlueSky"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "s3bucket" {
  type    = string
  default = ""
}

variable "dynamodb_table" {
  type    = string
  default = ""
}
