resource "aws_route_table" "rs_public_rt" {
  vpc_id = aws_vpc.rs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rs_gw.id
  }


  tags = {
    Name = "RS Public Route Table"
  }
}

resource "aws_route_table" "rs_private_rt" {
  vpc_id = aws_vpc.rs_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.rs_nat.id
  }


  tags = {
    Name = "RS Private Route Table"
  }
}


resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_cidrs)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.rs_public_rt.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_cidrs)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.rs_private_rt.id
}