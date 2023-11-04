resource "aws_instance" "prod_db" {
  
  ami           = "ami-00abdd4ea7dc7ec29" # Ubuntu wih docker - custom image with 8GB disk
  instance_type = "t2.micro"              # Free tier

  vpc_security_group_ids = [
    aws_security_group.allow-ssh.id,
    aws_security_group.allow-postgres.id
  ]

  subnet_id = aws_subnet.sbnt[0].id
  key_name = "aws-personal"

  tags = {
    Name = "textwizard-prod-db"
  }
}

output "prod_db_public_ip" {
  value = aws_instance.prod_db.public_ip
}

output "prod_db_public_dns" {
  value = aws_instance.prod_db.public_dns
}