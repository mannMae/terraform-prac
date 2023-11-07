resource "aws_vpc" "goormVPC" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "goormVPC"
  }
}

resource "aws_subnet" "public_web_a" {
  vpc_id = aws_vpc.goormVPC.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "public_web_a"
  }
}

resource "aws_subnet" "public_web_c" {
  vpc_id = aws_vpc.goormVPC.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "public_web_c"
  }
}

resource "aws_subnet" "private_app_a" {
  vpc_id = aws_vpc.goormVPC.id
  cidr_block = "10.10.10.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "private_app_a"
  }
}

resource "aws_subnet" "private_app_c" {
  vpc_id = aws_vpc.goormVPC.id
  cidr_block = "10.10.20.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "private_app_c"
  }
}

resource "aws_subnet" "private_db_a" {
  vpc_id = aws_vpc.goormVPC.id
  cidr_block = "10.10.100.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "private_db_a"
  }
}

resource "aws_subnet" "private_db_c" {
  vpc_id = aws_vpc.goormVPC.id
  cidr_block = "10.10.200.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "private_db_c"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.goormVPC.id

  tags = {
    Name = "internet_gateway"
  }
}

resource "aws_eip" "nat_gateway_ip" {
  domain = "vpc"
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_ip.id
  subnet_id = aws_subnet.public_web_a.id

  tags = {
    Name = "NAT Gateway"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}
