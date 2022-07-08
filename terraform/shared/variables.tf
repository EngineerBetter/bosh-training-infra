variable "region" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "key_name" {}

variable "public_key" {}

variable "cs_office_ip" {}

variable "availability_zone" {}

variable "eb_ci_nat_gateway" {}
