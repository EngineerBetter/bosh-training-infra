data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_subnet" "public" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = var.internal_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false
}

resource "aws_security_group_rule" "ssh" {
  security_group_id = var.security_group_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = [
    "3.8.37.24/29",
    "86.152.174.112/32",
    "79.67.170.213/32" # Marcus
  ]
}

resource "aws_security_group_rule" "http_ingress" {
  security_group_id = var.security_group_id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = [
    "3.8.37.24/29",
    "86.152.174.112/32",
    "79.67.170.213/32" # Marcus
  ]
}

resource "aws_security_group_rule" "https_ingress" {
  security_group_id = var.security_group_id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = [
    "3.8.37.24/29",
    "86.152.174.112/32",
    "79.67.170.213/32" # Marcus
  ]
}


resource "aws_security_group_rule" "agent" {
  security_group_id = var.security_group_id
  type              = "ingress"
  from_port         = 6868
  to_port           = 6868
  protocol          = "tcp"
  cidr_blocks = [
    "86.152.174.112/32", # Tom
    "79.67.170.213/32"   # Marcus
  ]
}

resource "aws_security_group_rule" "uaa-credhub" {
  security_group_id = var.security_group_id
  type              = "ingress"
  from_port         = 8443
  to_port           = 8444
  protocol          = "tcp"
  cidr_blocks = [
    "86.152.174.112/32", # Tom
    "79.67.170.213/32"   # Marcus
  ]
}

resource "aws_security_group_rule" "director" {
  security_group_id = var.security_group_id
  type              = "ingress"
  from_port         = 25555
  to_port           = 25555
  protocol          = "tcp"
  cidr_blocks = [
    "86.152.174.112/32", # Tom
    "79.67.170.213/32"   # Marcus
  ]
}

resource "aws_eip" "bosh" {
  vpc = true
}
