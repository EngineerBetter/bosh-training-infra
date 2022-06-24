output "bosh_ip" {
  value = aws_eip.bosh.public_ip
}

output "subnet_id" {
  value = aws_subnet.public.id
}
