output "security_group_id" {
  value = aws_security_group.bosh.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "nat_gateway_route_table" {
  value = aws_route_table.route-table.id
}
