resource "aws_instance" "prod_frontend" {
  
  ami           = "ami-093c288026bf8a70e" # Ubuntu wih docker - custom image with 100GB disk
  instance_type = "t3.xlarge"             # Free tier

  vpc_security_group_ids = [
    aws_security_group.allow-http-https.id,
    aws_security_group.allow-ssh.id
  ]

  subnet_id = aws_subnet.sbnt[0].id
  key_name = "aws-personal"

  tags = {
    Name = "textwizard-prod-frontend"
  }
}

output "prod_frontend_public_ip" {
  value = aws_instance.prod_frontend.public_ip
}

output "prod_frontend_public_dns" {
  value = aws_instance.prod_frontend.public_dns
}