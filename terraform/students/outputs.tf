output "students" {
  value = [for student in var.students : {
    name                    = student.name,
    subnet_id               = aws_subnet.students[student.name].id
    internal_cidr           = aws_subnet.students[student.name].cidr_block
    internal_gw             = cidrhost(aws_subnet.students[student.name].cidr_block, 1)
    internal_ip             = cidrhost(aws_subnet.students[student.name].cidr_block, 6)
    region                  = var.region
    az                      = var.availability_zone
    default_security_groups = "[${data.aws_security_group.main.name}]"
  }]
}
