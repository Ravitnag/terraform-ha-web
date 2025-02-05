
provider "aws" {
  region = "us-east-2"
}

module "aws_vpc" {
  source           = "./modules/aws_vpc"
  cidr_block_value = "10.0.0.0/16"

}

output "vpc_id" {
  value = module.aws_vpc.vpc_id
}

output "cidr_block" {
  value = module.aws_vpc.cidr_block
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = module.aws_vpc.vpc_id
  cidr_block              = cidrsubnet(module.aws_vpc.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}
resource "aws_internet_gateway" "igw" {
  vpc_id = module.aws_vpc.vpc_id
}
resource "aws_route_table" "public" {
  vpc_id = module.aws_vpc.vpc_id
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0" # Route all traffic to the IGW
  gateway_id             = aws_internet_gateway.igw.id
}


module "aws_security_group" {
  source            = "./modules/aws_security_group"
  listen_port_value = 80
  vpc_id_value      = module.aws_vpc.vpc_id
}

output "security_group_instance_id" {
  value = module.aws_security_group.security_group_instance_id
}

output "security_group_lb_id" {
  value = module.aws_security_group.security_group_lb_id
}

module "aws_asg" {
  source                           = "./modules/aws_asg"
  ami_value                        = "ami-08970251d20e940b0"
  instance_type_value              = "t2.micro"
  name_prefix_value                = "ha-webapp"
  asg_min_size_value               = 1
  asg_max_size_value               = 2
  listen_port_value                = 80
  protocol_value                   = "HTTP"
  security_group_instance_id_value = module.aws_security_group.security_group_instance_id
  security_group_lb_id_value       = module.aws_security_group.security_group_lb_id
  subnets_value                    = aws_subnet.public[*].id
  vpc_id_value                     = module.aws_vpc.vpc_id
}

output "dns_name" {
  value = module.aws_asg.lb_dns_name
}
