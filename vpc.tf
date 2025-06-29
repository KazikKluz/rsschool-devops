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
