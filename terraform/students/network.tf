data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_security_group_rule" "ssh" {
  security_group_id = var.security_group_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = toset(flatten([for student in var.students: [for ip in student.ips: "${ip}/32"]]))
}
