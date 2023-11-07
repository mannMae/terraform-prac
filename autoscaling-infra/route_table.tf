resource "aws_route_table" "web_route_table" {
  vpc_id = aws_vpc.goormVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Public Web Route Table"
  }
}

resource "aws_route_table_association" "web_route_table_association_a" {
  subnet_id = aws_subnet.public_web_a.id
  route_table_id = aws_route_table.web_route_table.id
}

resource "aws_route_table_association" "web_route_table_association_c" {
  subnet_id = aws_subnet.public_web_c.id
  route_table_id = aws_route_table.web_route_table.id
}


resource "aws_route_table" "app_route_table" {
  vpc_id = aws_vpc.goormVPC.id

  tags = {
    Name = "Private App Route Table"
  }
}

resource "aws_route_table_association" "app_route_table_association_a" {
  subnet_id = aws_subnet.private_app_a.id
  route_table_id = aws_route_table.app_route_table.id
}

resource "aws_route_table_association" "app_route_table_association_c" {
  subnet_id = aws_subnet.private_app_c.id
  route_table_id = aws_route_table.app_route_table.id
}

resource "aws_route" "private_route_table_route" {
  route_table_id = aws_route_table.app_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "app_db_route_table_association" {
  subnet_id = aws_subnet.private_db_a.id
  route_table_id = aws_route_table.app_route_table.id
}