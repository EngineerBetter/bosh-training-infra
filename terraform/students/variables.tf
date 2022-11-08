variable "vpc_id" {
  type = string
}

variable "region" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "students" {
  type = list(object({name = string, ips = list(string), subnet_cidr = string}))
}

variable "availability_zone" {
  type = string
}
