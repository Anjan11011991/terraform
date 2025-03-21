
# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main_vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name = "private_subnet"
  }
}

# Create Internet Gateway if enabled
resource "aws_internet_gateway" "internet_gateway" {
  count = var.create_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "internet_gateway"
  }
}

# Create Route Table for Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create Route Table for Private Subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "private_route_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# Create NAT Gateway if enabled
resource "aws_eip" "nat_eip" {
  count = var.create_nat_gateway ? 1 : 0
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "nat_gateway"
  }
}

resource "aws_route" "private_nat_route" {
  count                   = var.create_nat_gateway ? 1 : 0
  route_table_id          = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.nat_gateway[0].id
}
