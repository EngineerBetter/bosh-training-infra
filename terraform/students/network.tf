data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_subnet" "students" {
  for_each                = { for student in var.students : student.name => student.subnet_cidr }
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Environment = each.key
  }
}

resource "aws_eip" "students" {
  for_each = aws_subnet.students
  vpc      = true

  tags = {
    Environment = each.key
  }
}
