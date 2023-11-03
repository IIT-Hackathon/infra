
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


# ----- Security Group ----- #
resource "aws_security_group" "allow-http-https" {
  name        = "allow-http-https"
  description = "Allow HTTP HTTPS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-http-https"
  }
}


resource "aws_security_group" "allow-ssh" {
  name        = "allow-ssh"
  description = "Allow SSH"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-ssh"
  }
}

resource "aws_security_group" "allow-postgres" {
  name        = "allow-postgres"
  description = "Allow postgres"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "postgres from anywhere"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-postgres"
  }
}

resource "aws_security_group" "allow-wazuh" {
  name        = "allow-wazuh"
  description = "Allow wazuh"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "wazuh from anywhere"
    from_port        = 1514
    to_port          = 1514
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "wazuh from anywhere"
    from_port        = 1515
    to_port          = 1515
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "wazuh from anywhere"
    from_port        = 55000
    to_port          = 55000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-wazuh"
  }
}
