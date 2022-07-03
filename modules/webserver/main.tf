resource "aws_security_group" "test-sg" {
  vpc_id      = var.vpc_id
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
    values = [var.image_name]
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

  user_data = file(var.user_data_location)

  vpc_security_group_ids = [aws_security_group.test-sg.id]
  subnet_id     = var.subnet_id
  availability_zone = var.avail_zone

  associate_public_ip_address = true
  key_name = aws_key_pair.test-key.key_name

  tags = {
    Name = "${var.env_prefix}-instance"
  }
}
