variable "region" {}

variable "availability_zone" {}

variable "key_name" {}

variable "security_group_name" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "internal_cidr" {}

variable "cs_office_ip" {
  default = "212.140.222.159"
}
