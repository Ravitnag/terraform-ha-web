provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "ha-webapp_vpc" {
  cidr_block = var.cidr_block_value
}



output "vpc_id" {
  value = aws_vpc.ha-webapp_vpc.id
}

output "cidr_block" {
  value = aws_vpc.ha-webapp_vpc.cidr_block
}

