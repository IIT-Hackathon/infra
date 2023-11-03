resource "aws_instance" "prometheus" {
  
  ami           = "ami-00abdd4ea7dc7ec29" # Ubuntu wih docker
  instance_type = "t3.xlarge"             # Free tier

  vpc_security_group_ids = [
    aws_security_group.allow-http-https.id,
    aws_security_group.allow-ssh.id,
    aws_security_group.allow-monitoring.id
  ]

  subnet_id = aws_subnet.sbnt[0].id
  key_name = "aws-personal"

  tags = {
    Name = "prometheus-server"
  }
}

output "prometheus_public_ip" {
  value = aws_instance.prometheus.public_ip
}

output "prometheus_public_dns" {
  value = aws_instance.prometheus.public_dns
}

# Allow to scrape metrics at 9100 from specific IPs
resource "aws_security_group" "allow-monitoring-scarping" {
  name        = "allow-scraping"
  description = "Expose node exporter"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Prometheus"
    from_port        = 9100
    to_port          = 9100
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/8"]
    
  }

  tags = {
    Name = "allow-scraping"
  }
}