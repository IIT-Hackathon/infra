resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    tags = {
        Name = "textwizard-vpc"
    }
}

resource "aws_subnet" "sbnt" {

    count  = length(var.subnets_cidr)
    vpc_id = aws_vpc.vpc.id
    
    cidr_block              = element(var.subnets_cidr , count.index) 
    availability_zone       = element(var.availability_zones , count.index)
    map_public_ip_on_launch = true

    tags = {
        Name = "textwizard-subnet-${count.index + 1}"
    }
}