provider "aws" {
  region = var.region
}
resource "aws_instance" "Master" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.master-sec-group.id]
  user_data              = templatefile("${path.module}/master.sh", {})
  key_name               = var.key_name
  tags                   = var.tags_master
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }
}

resource "aws_instance" "Worker" {
  count                  = 2
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.worker-sec-group.id]
  user_data              = templatefile("${path.module}/worker.sh", {})
  key_name               = var.key_name
  tags                   = var.tags_worker
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }
}
data "aws_vpc" "default" {
  default = true
}
resource "aws_security_group" "master-sec-group" {
  name        = var.security_groups_master
  description = "Security group for master node"
  vpc_id      = data.aws_vpc.default.id
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
  vpc_id      = data.aws_vpc.default.id
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
