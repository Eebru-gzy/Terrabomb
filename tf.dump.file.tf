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

# resource "aws_route_table" "test-rt" {
#   vpc_id = aws_vpc.test-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.test-igw.id
#   }
#   tags = {
#     Name = "${var.env_prefix}-rt"
#   }
# }

# resource "aws_route_table_association" "test-rt-assoc" {
#   route_table_id = aws_route_table.test-rt.id
#   subnet_id      = aws_subnet.dev-subnet.id
# }

# output "vpc" {
#   value = aws_vpc.vpc.id
#   # arn = aws_vpc.vpc.arn
# }

# output "subnet" {
#   value = aws_subnet.dev-subnet-2.id
#   # arn = aws_subnet.dev-subnet-2.arn
# }