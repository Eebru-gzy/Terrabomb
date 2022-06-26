provider "aws" {}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}

resource "aws_vpc" "test-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "dev-subnet" {
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}


// create aws internet gateway
resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.test-vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.test-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }
  tags = {
    Name = "${var.env_prefix}-main-rt"
  }
}

