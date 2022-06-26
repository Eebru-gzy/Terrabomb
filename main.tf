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


resource "aws_route_table" "test-rt" {
  vpc_id = aws_vpc.test-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }
  tags = {
    Name = "${var.env_prefix}-rt"
  }
}

// create aws internet gateway
resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.test-vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}


resource "aws_route_table_association" "test-rt-assoc" {
  route_table_id = aws_route_table.test-rt.id
  subnet_id      = aws_subnet.dev-subnet.id
}

# data "aws_vpc" "existing-vpc" {
#   default = true
#   # tags = {
#   #   "Name" = "test-vpc"
#   # }
# }

# resource "aws_subnet" "dev-subnet-2" {
#   vpc_id            = data.aws_vpc.existing-vpc.id
#   cidr_block        = "172.31.48.0/20"
#   availability_zone = "eu-west-3b"

# }

# output "vpc" {
#   value = aws_vpc.vpc.id
#   # arn = aws_vpc.vpc.arn
# }

# output "subnet" {
#   value = aws_subnet.dev-subnet-2.id
#   # arn = aws_subnet.dev-subnet-2.arn
# }
