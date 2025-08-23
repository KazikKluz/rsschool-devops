resource "aws_vpc" "rs_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "RS VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_cidrs)
  vpc_id            = aws_vpc.rs_vpc.id
  cidr_block        = element(var.public_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "RS Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidrs)
  vpc_id            = aws_vpc.rs_vpc.id
  cidr_block        = element(var.private_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "RS Private Subnet ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "rs_gw" {
  vpc_id = aws_vpc.rs_vpc.id

  tags = {
    Name = "RS IGW"
  }
}

resource "aws_nat_gateway" "rs_nat" {
  allocation_id = aws_eip.rs_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "RS NAT"
  }

  depends_on = [aws_internet_gateway.rs_gw]
}

resource "aws_eip" "rs_eip" {
  domain = "vpc"
}