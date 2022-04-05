# Provider
variable "aws_region" {
  default = "us-east-1"
}

# VPC variables
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "public_subnets_cidr" {
  type = list
  default = ["10.0.0.0/24", "10.1.0.0/24"]
}
variable "private_subnets_cidr" {
  type = list
  default = ["10.2.0.0/24", "10.3.0.0/24"]
}
variable "azs" {
  type = list
  default = ["us-east-1a", "us-east-1b"]
}
variable "prefix" {
  default = ug
}

# EC2 variables
variable "instance_name" {
  description = "Value of the name tag for EC2 instance"
  type        = string
  default     = "terraform-vm"
}

variable "amazonlinux2_ami" {
  default     = "ami-04893cdb768d0f9ee"
  description = "Amazon Linux2 AMI ID"
}


