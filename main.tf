

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs            = [var.avail_zone]
  public_subnets = [var.subnet_cidr_block]
  public_subnet_tags = {
    Name = "${var.env_prefix}-public-subnet"
  }

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}


module "webserver" {
  source              = "./modules/webserver"
  public_key_location = var.public_key_location
  avail_zone          = var.avail_zone
  env_prefix          = var.env_prefix
  vpc_id              = module.vpc.vpc_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc.public_subnets[0]
  my_ip               = var.my_ip
  image_name          = var.image_name
  user_data_location  = var.user_data_location
}
