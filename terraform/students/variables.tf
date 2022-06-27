variable "vpc_id" {}

variable "region" {}

variable "availability_zone" {}

variable "key_name" {}

variable "security_group_id" {}

variable "private_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "internal_cidr" {}

variable "students" {
  type = list(object({name = string, ips = list(string)}))
}