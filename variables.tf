# VPC variables
variable "vpc-cidr" {
  description = "VPC CIDR"
  type = string
  default = "10.0.0.0/16"
}
variable "public-subnet-01" {
  description = "Public Subnet 01 CIDR"
  type = string
  default = "10.0.0.0/24"
}
variable "public-subnet-02" {
  description = "Public Subnet 02 CIDR"
  type = string
  default = "10.1.0.0/24"
}
variable "private-subnet-01" {
  description = "Private Subnet 01 CIDR"
  type = string
  default = "10.2.0.0/24"
}
variable "private-subnet-02" {
  description = "Private Subnet 02 CIDR"
  type = string
  default = "10.3.0.0/24"
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


