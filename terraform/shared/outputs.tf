output "security_group_id" {
  value = aws_security_group.bosh.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "bastion_ip" {
  value = aws_eip.bastion.public_ip
}
