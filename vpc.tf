terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "vpc_project" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = { Name = "vpc: eu-central-1" }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.cidr_public_subnet)
  vpc_id            = aws_vpc.vpc_project.id
  cidr_block        = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.aws_availability_zone, count.index)

  tags = {
    "Name" = "Public Subnet: ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.cidr_private_subnet)
  vpc_id            = aws_vpc.vpc_project.id
  cidr_block        = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.aws_availability_zone, count.index)

  tags = {
    "Name" = "Private Subnet: ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.vpc_project.id
  tags = {
    "Name" = "IGW: project"
  }
}

resource "aws_eip" "nat_elastic_ip" {
  count = length(var.cidr_private_subnet)
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.cidr_private_subnet)
  depends_on    = [aws_eip.nat_elastic_ip]
  allocation_id = aws_eip.nat_elastic_ip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    "Name" = "Private NAT gateway: project"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_igw.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_project.id

  tags = {
    "Name" = "Public route table: project"
  }
}

resource "aws_route" "private_route" {
  count                  = length(var.cidr_private_subnet)
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_route_table[count.index].id
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
}

resource "aws_route_table" "private_route_table" {
  count      = length(var.cidr_private_subnet)
  vpc_id     = aws_vpc.vpc_project.id
  depends_on = [aws_nat_gateway.nat_gateway]

  tags = {
    "Name" = "Private Route table: project"
  }
}

resource "aws_route_table_association" "public_subnet_route_association" {
  count          = length(var.cidr_public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id

  depends_on = [
    aws_subnet.public_subnet,
    aws_route_table.public_route_table
  ]

}

resource "aws_route_table_association" "private_subnet_route_association" {
  count          = length(var.cidr_private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id

  depends_on = [
    aws_subnet.private_subnet,
    aws_route_table.private_route_table
  ]

}