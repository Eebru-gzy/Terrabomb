provider "aws" {
  # region     = "eu-west-3"
  # access_key = "AKIAWYCB7GEIX5EN7LYV"
  # secret_key = "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"
}

variable "cidr_blocks" {
  # default = ""
  description = "List of CIDR blocks and name to use for the VPC and subnet"
  type = list(object({
    cidr_block = string
    name       = string
  }))
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name = var.cidr_blocks[0].name
  }
}

resource "aws_subnet" "dev-subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_blocks[1].cidr_block
  availability_zone = "eu-west-3a"
  tags = {
    Name = var.cidr_blocks[1].name
  }
}

data "aws_vpc" "existing-vpc" {
  default = true
  # tags = {
  #   "Name" = "test-vpc"
  # }
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id            = data.aws_vpc.existing-vpc.id
  cidr_block        = "172.31.48.0/20"
  availability_zone = "eu-west-3b"

}

output "vpc" {
  value = aws_vpc.vpc.id
  # arn = aws_vpc.vpc.arn
}

output "subnet" {
  value = aws_subnet.dev-subnet-2.id
  # arn = aws_subnet.dev-subnet-2.arn
}
