# VPC, PRIVATE SUBNET, PUBLIC SUBNET, INTERNET GATEWAY, NAT GATEWAY, EIP

resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-ring-challenge"
  }
}

resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public.id

  tags = {
    Name = "nat-gateway-ring-challenge"
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_cidr

  tags = {
    Name = "private-subnet-ring-challenge"
  }
}
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-ring-challenge"
  }
}
data "local_file" "private_key" {
    filename = var.key_location
}
data "local_file" "script" {
    filename = "${path.cwd}/script.sh"
}