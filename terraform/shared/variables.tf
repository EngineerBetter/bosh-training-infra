variable "region" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "key_name" {
  type = string
}

variable "public_key" {
  type = string
}

variable "cs_office_ip" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "eb_ci_nat_gateway" {
  type = string
}
