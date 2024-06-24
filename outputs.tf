output "master-ip" {
  value = aws_instance.Master.public_ip
}
output "worker-ips" {
  value = [for instance in aws_instance.Worker : instance.public_ip]
}

