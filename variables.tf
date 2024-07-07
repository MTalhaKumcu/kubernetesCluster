variable "region" {
  description = "stockholm"
  type        = string
  default     = "eu-north-1"
}
variable "instance_type" {
  description = "ec2-t3.micro"
  type        = string
  default     = "t3.small"
}
variable "ami_id" {
  default = "amazon-linux2"
  type    = string
}
variable "key_name" {
  default = "Key-name"
  type    = string
}
variable "tags_master" {
  description = "Tags for the master instance"
  type        = map(string)
  default = {
    "Name"        = "Master"
    "Environment" = "kubernetes-cluster-dev"
  }
}
variable "tags_worker" {
  description = "Tags for the worker instances"
  type        = map(string)
  default = {
    "Name"        = "Worker"
    "Environment" = "kubernetes-cluster-dev"
  }
}
variable "security_groups_master" {
  description = "Security groups for master"
  type        = string
}
variable "security_group_name" {
  description = "Ec2-Sec-Gr"
  type        = string
}
variable "security_groups_worker" {
  description = "Security groups for worker"
  type        = list(string)
}
variable "master_ports" {
  description = "List of ports open"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
variable "worker_ports" {
  description = "List of ports open"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
variable "ssh_ports" {
  description = "list of ssh ports to open"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "subnet_cidrs" {
  description = "A list of CIDR blocks for the subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "vpc_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "name" = "main-vpc"
  }
}
variable "tags_master_role" {
  description = "master role policy description"
  type        = string
}

