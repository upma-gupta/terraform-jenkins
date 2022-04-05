# Create the VPC
resource "aws_vpc" "ug-vpc" {
  cidr_block = var.vpc-cidr
  instance_tenancy = "default"
  tags = {
    Name = "ug-vpc"
  }
}

# Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "ug-igw" {
  vpc_id = aws_vpc.ug-vpc.id
  tags = {
    Name = "ug-igw"
  }
}
# Create EIP for NAT GW
resource "aws_eip" "ug-natgw-eip" {
  vpc = true
}

# Create NAT Gateway
resource "aws_nat_gateway" "ug-natgw" {
  subnet_id = aws_subnet.ug-public-subnet-01.id
  allocation_id = aws_eip.ug-natgw-eip.id
}

# Create public subnets
resource "aws_subnet" "ug-public-subnet-01" {
  vpc_id = aws_vpc.ug-vpc.id
  cidr_block = "${var.public-subnet-01}"
}
resource "aws_subnet" "ug-public-subnet-02" {
  vpc_id = aws_vpc.ug-vpc.id
  cidr_block = "${var.public-subnet-02}"
}

# Create private subnets
resource "aws_subnet" "ug-private-subnet-01" {
  vpc_id = aws_vpc.ug-vpc.id
  cidr_block = "${var.private-subnet-01}"
}
resource "aws_subnet" "ug-private-subnet-02" {
  vpc_id = aws_vpc.ug-vpc.id
  cidr_block = "${var.private-subnet-02}"
}

# Route Table for Public Subnets
resource "aws_route_table" "ug-public-rt" {
  vpc_id         = aws_vpc.ug-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ug-igw.id
  }
}

# Route Table for Private Subnets
resource "aws_route_table" "ug-private-rt" {
  vpc_id = aws_vpc.ug-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ug-natgw.id
  }
}

# Route Table Association with Public Subnet
resource "aws_route_table_association" "ug-public-rt-asso" {
  route_table_id = aws_route_table.ug-public-rt.id
  subnet_id = aws_subnet.ug-public-subnet-01.id
}

# Route Table Association with Private Subnet
resource "aws_route_table_association" "ug-private-rt-asso" {
  route_table_id = aws_route_table.ug-private-rt.id
  subnet_id = aws_subnet.ug-private-subnet-01.id
}
