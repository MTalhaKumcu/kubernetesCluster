variable "region" {
  description = "stockholm"
  type        = string
  default     = "eu-north-1"
}
variable "instance_type" {
  description = "ec2-t3.micro"
  type        = string
  default     = "t3.micro"
}
variable "ami_id" {
  default = "amazon-linux2"
  type    = string
}
variable "subnet_id" {
  description = "subnets"
  type        = string
}
variable "key_name" {
  default = "Key-name"
  type    = string
}
variable "tags_master" {
  description = "owner"
  type        = map(string)
  default = {
    "name" = "Key-name-owner"
  }
}
variable "tags_worker" {
  description = "owner"
  type        = map(string)
  default = {
    "name" = "Key-name-owner"
  }
}
variable "security_groups_master" {
  description = "master-sec-gr"
}
variable "security_groups_worker" {
  description = "worker-sec-gr"
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
