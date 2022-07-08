data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_security_group" "main" {
  id = var.security_group_id
}

locals {
  student_ips  = toset(flatten([for student in var.students : [for ip in student.ips : "${ip}/32"]]))
  director_ips = [for student in var.students : "${cidrhost(student.subnet_cidr, 6)}/32"]
}

resource "aws_security_group_rule" "ingress_ssh" {
  security_group_id = var.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = local.student_ips
}

resource "aws_security_group_rule" "ingress_agent" {
  security_group_id = var.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 6868
  to_port           = 6868
  cidr_blocks       = local.student_ips
}

resource "aws_security_group_rule" "ingress_uaa" {
  security_group_id = var.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8443
  to_port           = 8444
  cidr_blocks       = local.student_ips
}

resource "aws_security_group_rule" "ingress_lab_application" {
  security_group_id = var.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 9090
  to_port           = 9090
  cidr_blocks       = local.student_ips
}

resource "aws_security_group_rule" "ingress_director" {
  security_group_id = var.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 25555
  to_port           = 25555
  cidr_blocks       = local.student_ips
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

resource "aws_eip" "students" {
  for_each = aws_subnet.students

  vpc = true
}

resource "aws_network_interface" "students" {
  for_each = aws_subnet.students

  subnet_id       = each.value.id
  security_groups = [var.security_group_id]
}

resource "aws_eip_association" "students" {
  for_each = aws_subnet.students

  allocation_id        = aws_eip.students[each.key].allocation_id
  network_interface_id = aws_network_interface.students[each.key].id
}

resource "aws_route_table_association" "students" {
  for_each       = aws_subnet.students
  subnet_id      = each.value.id
  route_table_id = var.nat_gateway_route_table
}
