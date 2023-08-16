# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

resource "aws_vpc" "main_region" {
  cidr_block = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
}

resource "aws_subnet" "sub_region_az_1" {
  vpc_id     = aws_vpc.main_region.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.az_1
}

resource "aws_subnet" "sub_region_az_2" {
  vpc_id     = aws_vpc.main_region.id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.az_2
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_region.id
}

resource "aws_route_table" "internet_route" {
  vpc_id = aws_vpc.main_region.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "rta_av1_internet" {
  subnet_id      = aws_subnet.sub_region_az_1.id
  route_table_id = aws_route_table.internet_route.id
}

resource "aws_route_table_association" "rta_av2_internet" {
  subnet_id      = aws_subnet.sub_region_az_2.id
  route_table_id = aws_route_table.internet_route.id
}