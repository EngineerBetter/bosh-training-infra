data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_subnet" "students" {
  for_each                = var.students
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = each.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "bosh-training-${each.name}"
  }
}

resource "aws_eip" "students" {
  for_each = aws_subnet.students
  vpc      = true
}
