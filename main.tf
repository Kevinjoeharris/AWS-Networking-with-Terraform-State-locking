#VPC
resource "aws_vpc" "aws-networking-vpc" {
  cidr_block = "10.0.0.0/16"

   tags = {
    Name = "aws-networking-vpc"
  }
}

#Private subnets
resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.aws-networking-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private 1"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id     = aws_vpc.aws-networking-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private 2"
  }
}

#Public subnets
resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.aws-networking-vpc.id
  cidr_block = "10.0.101.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public 1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id     = aws_vpc.aws-networking-vpc.id
  cidr_block = "10.0.102.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public 2"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.aws-networking-vpc.id
}

#IG Route table
resource "aws_route_table" "IGW_Route_table" {
  vpc_id = aws_vpc.aws-networking-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "IGW Route-table"
  }
}

#Route table association
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.IGW_Route_table.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.IGW_Route_table.id
}

#NAT Gateway for Private subnets
resource "aws_nat_gateway" "nat-1" {
  connectivity_type = "public"
  subnet_id         = aws_subnet.public-1.id
  allocation_id = aws_eip.eip1.id
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat-2" {
  connectivity_type = "public"
  subnet_id         = aws_subnet.public-2.id
  allocation_id = aws_eip.eip2.id
  depends_on = [aws_internet_gateway.igw]
}

#Elastic IP
resource "aws_eip" "eip1" {
  domain   = "vpc"
}

resource "aws_eip" "eip2" {
  domain   = "vpc"
}



#Auto-Scaling Groups