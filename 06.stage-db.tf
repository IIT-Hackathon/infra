resource "aws_instance" "staging_db" {
  
  ami           = "ami-00abdd4ea7dc7ec29" # Ubuntu wih docker - custom image with 8GB disk
  instance_type = "t2.micro"              # Free tier

  vpc_security_group_ids = [
    aws_security_group.allow-http-https.id,
    aws_security_group.allow-ssh.id
  ]

  subnet_id = aws_subnet.sbnt[0].id
  key_name = "aws-personal"

  tags = {
    Name = "textwizard-staging-db"
  }
}

output "staging_db_public_ip" {
  value = aws_instance.staging_db.public_ip
}

output "staging_db_public_dns" {
  value = aws_instance.staging_db.public_dns
}