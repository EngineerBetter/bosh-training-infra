data "aws_security_group" "main" {
  id = var.security_group_id
}

resource "aws_security_group" "students" {
  for_each = local.students
  name     = each.key
  vpc_id   = var.vpc_id

  tags = {
    Environment = each.key
  }
}

resource "aws_security_group_rule" "ingress_ssh" {
  for_each          = local.students
  security_group_id = aws_security_group.students[each.key].id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = each.value
}

resource "aws_security_group_rule" "ingress_cf_http" {
  for_each          = local.students
  security_group_id = aws_security_group.students[each.key].id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = each.value
}

resource "aws_security_group_rule" "ingress_cf_ssh" {
  for_each          = local.students
  security_group_id = aws_security_group.students[each.key].id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 2222
  to_port           = 2222
  cidr_blocks       = each.value
}

resource "aws_security_group_rule" "ingress_cf_api" {
  for_each          = local.students
  security_group_id = aws_security_group.students[each.key].id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = each.value
}

resource "aws_security_group_rule" "ingress_agent" {
  for_each          = local.students
  security_group_id = aws_security_group.students[each.key].id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 6868
  to_port           = 6868
  cidr_blocks       = each.value
}

resource "aws_security_group_rule" "ingress_uaa" {
  for_each          = local.students
  security_group_id = aws_security_group.students[each.key].id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8443
  to_port           = 8444
  cidr_blocks       = each.value
}

resource "aws_security_group_rule" "ingress_lab_application" {
  for_each          = local.students
  security_group_id = aws_security_group.students[each.key].id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 9090
  to_port           = 9090
  cidr_blocks       = each.value
}

resource "aws_security_group_rule" "ingress_director" {
  for_each          = local.students
  security_group_id = aws_security_group.students[each.key].id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 25555
  to_port           = 25555
  cidr_blocks       = each.value
}

resource "aws_security_group_rule" "ingress_director_cf_api" {
  for_each          = local.students
  security_group_id = aws_security_group.students[each.key].id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["${aws_eip.students[each.key].public_ip}/32"]
}

resource "aws_security_group_rule" "ingress_director_uaa" {
  for_each          = local.students
  security_group_id = aws_security_group.students[each.key].id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8443
  to_port           = 8444
  cidr_blocks       = ["${aws_eip.students[each.key].public_ip}/32"]
}
