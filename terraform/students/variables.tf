variable "vpc_id" {}

variable "region" {}

variable "security_group_id" {}

variable "students" {
  type = list(object({name = string, ips = list(string)}))
}
