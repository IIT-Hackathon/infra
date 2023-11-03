resource "aws_instance" "sonarqube" {
  
  ami           = "ami-00abdd4ea7dc7ec29" # Ubuntu wih docker
  instance_type = "t3.xlarge"             # Free tier

  vpc_security_group_ids = [
    aws_security_group.allow-http-https.id,
    aws_security_group.allow-ssh.id
  ]

  subnet_id = aws_subnet.sbnt[0].id
  key_name = "aws-personal"

  tags = {
    Name = "sonarqube-server"
  }
}

output "sonarqube_public_ip" {
  value = aws_instance.sonarqube.public_ip
}

output "sonarqube_public_dns" {
  value = aws_instance.staging_backend.public_dns
}