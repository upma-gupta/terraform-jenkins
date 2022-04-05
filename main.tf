# Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "${prefix}-vpc"
  }
}

# Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${prefix}-igw"
  }
}
# Create EIP for NAT GW
resource "aws_eip" "nat-eip" {
  vpc = true
}

# Create NAT Gateway
resource "aws_nat_gateway" "natgw" {
  subnet_id = aws_subnet.ug-public-subnet-01.id
  allocation_id = aws_eip.nat-eip.id
}

# Create public subnets
resource "aws_subnet" "public" {
  count = len(var.public_subnets_cidr)
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.public_subnets_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${prefix}-public-subnet-${count.index+1}"
  }
}
# Create Private Subnet
resource "aws_subnet" "private" {
  count = len(var.private_subnets_cidr)
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.private_subnets_cidr,count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "${prefix}-private-subnet-${count.index+1}"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Route Table for Private Subnets
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
}

# Route Table Association with Public Subnet
resource "aws_route_table_association" "public-rt-asso" {
  count = len(var.public_subnets_cidr)
  route_table_id = aws_route_table.public-rt.id
  subnet_id = element(aws_subnet.public.*.id, count.index)
}

# Route Table Association with Private Subnet
resource "aws_route_table_association" "private-rt-asso" {
  route_table_id = aws_route_table.private-rt.id
  subnet_id = element(aws_subnet.private.*.id, count.index)
}
