output "master-ip" {
  value = aws_instance.Master.public_ip
}
output "worker-ips" {
  value = [for instance in aws_instance.Worker : instance.public_ip]
}
output "vpc" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}
output "subnet1_id" {
  description = "The ID of the subnet-1a"
  value       = aws_subnet.subnet-1a.id
}
output "subnet2_id" {
  description = "The ID of the subnet-1b"
  value       = aws_subnet.subnet-1b.id
}
output "gw_id" {
  description = "value"
  value       = aws_internet_gateway.gw.id
}
output "rt_id" {
  description = "value"
  value       = aws_route_table.rt.id
}
