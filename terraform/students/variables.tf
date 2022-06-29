variable "vpc_id" {}

variable "region" {}

variable "security_group_id" {}

variable "students" {
  type = list(object({name = string, ips = list(string), subnet_cidr = string}))
}

variable "availability_zone" {}

variable "nat_gateway_route_table" {}
