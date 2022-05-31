variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "public_subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "availability_zone" {
  default = "eu-west-2a"
}

variable "cs_office_ip" {
  default = "212.140.222.159"
}
