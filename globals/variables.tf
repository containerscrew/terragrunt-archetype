variable "aws_account_id" {
  type = number
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}
variable "environment_prefix" {
  type = string
}

variable "tags" {
  type = object({
    terraform   = bool
    environment = string
    prefix      = string
    project     = string
  })
}
