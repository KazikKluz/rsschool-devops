resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc
  availability_zone       = var.availability_zones[0]
  cidr_block              = var.public_subnet_1_cidr
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${local.name}-public-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc
  availability_zone       = var.availability_zones[1]
  cidr_block              = var.public_subnet_2_cidr
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${local.name}-public-2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc
  availability_zone       = var.availability_zones[0]
  cidr_block              = var.private_subnet_1_cidr
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${local.name}-private-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc
  availability_zone       = var.availability_zones[1]
  cidr_block              = var.private_subnet_1_cidr
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${local.name}-private-2"
  }
}
