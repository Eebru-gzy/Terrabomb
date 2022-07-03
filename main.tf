provider "aws" {}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}
variable "public_key_location" {}

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

//aws security group
resource "aws_security_group" "test-sg" {
  vpc_id      = aws_vpc.test-vpc.id
  name = "test-sg"
  tags = {
    Name = "${var.env_prefix}-sg"
  }

  ingress {
    cidr_blocks = [var.my_ip]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    }
    
    ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
    }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

data "aws_ami" "latest_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "test-key" {
  key_name = "new-test-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "test-instance" {
  ami           =  data.aws_ami.latest_ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.test-sg.id]
  subnet_id     = aws_subnet.dev-subnet.id
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  key_name = aws_key_pair.test-key.key_name
  user_data = file("user-data.sh")
  tags = {
    Name = "${var.env_prefix}-instance"
  }
}

output "EC2_IP" {
  value = aws_instance.test-instance.public_ip
}

