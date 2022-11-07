locals {
  security_group_cidrs = { for s in var.students : "bosh-${s.name}" => toset([for ip in s.ips : "${ip}/32"]) }
  director_ips         = [for student in var.students : "${cidrhost(student.subnet_cidr, 6)}/32"]
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_security_group" "students" {
  for_each = local.security_group_cidrs

  name   = each.key
  vpc_id = data.aws_vpc.main.id
}

resource "aws_security_group_rule" "ingress_ssh" {
  for_each = local.security_group_cidrs

  security_group_id = aws_security_group.students[each.key].id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = each.value
  count             = length(each.value) == 0 ? 0 : 1
}

resource "aws_security_group_rule" "ingress_cf_api" {
  for_each = local.security_group_cidrs

  security_group_id = var.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = each.value
  count             = length(each.value) == 0 ? 0 : 1
}

resource "aws_security_group_rule" "ingress_agent" {
  for_each = local.security_group_cidrs

  security_group_id = var.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 6868
  to_port           = 6868
  cidr_blocks       = each.value
  count             = length(each.value) == 0 ? 0 : 1
}

resource "aws_security_group_rule" "ingress_uaa" {
  for_each = local.security_group_cidrs

  security_group_id = var.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8443
  to_port           = 8444
  cidr_blocks       = each.value
  count             = length(each.value) == 0 ? 0 : 1
}


resource "aws_security_group_rule" "ingress_lab_application" {
  for_each = local.security_group_cidrs

  security_group_id = var.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 9090
  to_port           = 9090
  cidr_blocks       = each.value
  count             = length(each.value) == 0 ? 0 : 1
}

resource "aws_security_group_rule" "ingress_director" {
  for_each = local.security_group_cidrs

  security_group_id = var.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 25555
  to_port           = 25555
  cidr_blocks       = each.value
  count             = length(each.value) == 0 ? 0 : 1
}

resource "aws_subnet" "students" {
  for_each = { for student in var.students : student.name => student.subnet_cidr }

  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "bosh-training-${each.key}"
  }
}

resource "aws_security_group_rule" "ingress_director_cf_api" {
  for_each          = aws_eip.students
  security_group_id = var.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["${each.value.public_ip}/32"]
}

resource "aws_security_group_rule" "ingress_director_uaa" {
  for_each          = aws_eip.students
  security_group_id = var.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8443
  to_port           = 8444
  cidr_blocks       = ["${each.value.public_ip}/32"]
}
resource "aws_eip" "students" {
  for_each = aws_subnet.students

  vpc = true
}
