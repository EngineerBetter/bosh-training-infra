data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_security_group_rule" "ssh" {
  security_group_id = var.security_group_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = toset(flatten([for student in var.students : [for ip in student.ips : "${ip}/32"]]))
}

resource "aws_subnet" "students" {
  for_each = { for student in var.students : student.name => student.subnet_cidr }

  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = "bosh-training-${each.key}"
  }
}
