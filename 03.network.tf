
# ----- VPC ----- #
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    tags = {
        Name = "textwizard-vpc"
    }
}

# ----- Subnet ----- #
resource "aws_subnet" "sbnt" {

    count  = length(var.subnets_cidr)
    vpc_id = aws_vpc.vpc.id
    
    cidr_block              = element(var.subnets_cidr , count.index) 
    availability_zone       = element(var.availability_zones , count.index)
    map_public_ip_on_launch = true

    tags = {
        Name = "textwizard-subnet-${count.index + 1}"
    }

    depends_on = [ aws_vpc.vpc ]
}

# ----- Internet Gateway ----- #
resource "aws_internet_gateway" "igw" {

    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "textwizard-igw"
    }

    depends_on = [ aws_internet_gateway.igw ]
}

# ----- Route Table ----- #

resource "aws_route_table" "rt" {

    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "textwizard-route-table"
    }

    depends_on = [ aws_internet_gateway.igw ]
}

# Attaching Routing table to Subnets
resource "aws_route_table_association" "rta" {
    count          = length(var.subnets_cidr)
    subnet_id      = element(aws_subnet.sbnt.*.id , count.index)
    route_table_id = aws_route_table.rt.id

    depends_on = [ aws_route_table.rt ]
}

