resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "main" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_security_group" "bosh" {
  name   = "bosh"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "internal_tcp" {
  security_group_id = aws_security_group.bosh.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  self              = true
}

resource "aws_security_group_rule" "internal_udp" {
  security_group_id = aws_security_group.bosh.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "udp"
  self              = true
}

resource "aws_security_group_rule" "egress_http" {
  security_group_id = aws_security_group.bosh.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_https" {
  security_group_id = aws_security_group.bosh.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.bosh.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.cs_office_ip}/32", "${var.eb_ci_nat_gateway}/32"]
}

resource "aws_security_group_rule" "mbus" {
  security_group_id = aws_security_group.bosh.id
  type              = "ingress"
  from_port         = 6868
  to_port           = 6868
  protocol          = "tcp"
  cidr_blocks       = ["${var.cs_office_ip}/32", "${var.eb_ci_nat_gateway}/32"]
}

resource "aws_security_group_rule" "uaa" {
  security_group_id = aws_security_group.bosh.id
  type              = "ingress"
  from_port         = 8443
  to_port           = 8444
  protocol          = "tcp"
  cidr_blocks       = ["${var.cs_office_ip}/32", "${var.eb_ci_nat_gateway}/32"]
}

resource "aws_security_group_rule" "director" {
  security_group_id = aws_security_group.bosh.id
  type              = "ingress"
  from_port         = 25555
  to_port           = 25555
  protocol          = "tcp"
  cidr_blocks       = ["${var.cs_office_ip}/32", "${var.eb_ci_nat_gateway}/32"]
}

resource "aws_subnet" "bastion" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
}

resource "aws_eip" "nat-ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat-ip.id
  subnet_id     = aws_subnet.bastion.id
  depends_on    = [aws_internet_gateway.main]
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}
