data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bastion" {
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.bastion.id
  key_name      = aws_key_pair.bastion.key_name
  ami           = data.aws_ami.ubuntu.id

  tags = {
    "Name" = "bosh-training-bastion"
  }

  vpc_security_group_ids = [aws_security_group.bosh.id]
}
