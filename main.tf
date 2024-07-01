provider "aws" {
  region = var.region
}
resource "aws_instance" "Master" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet-1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.master-sec-group.id]
  user_data                   = templatefile("${path.module}/master.sh", {})
  key_name                    = var.key_name
  tags                        = var.tags_master
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }
}
resource "aws_instance" "Worker" {
  count                  = 2
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet-1a.id
  vpc_security_group_ids = [aws_security_group.worker-sec-group.id]
  user_data              = templatefile("${path.module}/worker.sh", {})
  key_name               = var.key_name
  tags                   = var.tags_worker
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }
}
resource "aws_security_group" "master-sec-group" {
  name        = var.security_groups_master
  description = "Security group for master node"
  vpc_id      = aws_vpc.main.id
  tags        = var.tags_master
  dynamic "ingress" {
    for_each = var.master_ports
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "ingress" {
    for_each = var.ssh_ports
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "worker-sec-group" {
  name        = "worker-sec-group"
  description = "Security group for worker nodes"
  vpc_id      = aws_vpc.main.id
  tags        = var.tags_worker
  dynamic "ingress" {
    for_each = var.worker_ports
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "ingress" {
    for_each = var.ssh_ports
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = var.vpc_tags
}
resource "aws_subnet" "subnet-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidrs[0]
  map_public_ip_on_launch = true

  tags = var.vpc_tags
}
resource "aws_subnet" "subnet-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidrs[1]
  map_public_ip_on_launch = true

  tags = var.vpc_tags
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = var.vpc_tags
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = var.vpc_tags
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1a.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet-1b.id
  route_table_id = aws_route_table.rt.id
}

