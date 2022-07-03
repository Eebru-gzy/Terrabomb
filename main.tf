



resource "aws_vpc" "test-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "local-subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.test-vpc.id
  default_route_table_id = aws_vpc.test-vpc.default_route_table_id
}

module "webserver" {
  source = "./modules/webserver"
  public_key_location = var.public_key_location
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.test-vpc.id
  instance_type = var.instance_type
  subnet_id = module.local-subnet.subnet.id
  my_ip = var.my_ip
  image_name = var.image_name
  user_data_location = var.user_data_location
}
