resource "aws_instance" "wazuh" {
  
  ami           = "ami-00abdd4ea7dc7ec29" # Ubuntu wih docker
  instance_type = "t3.xlarge"             # Free tier

  vpc_security_group_ids = [
    aws_security_group.allow-http-https.id,
    aws_security_group.allow-ssh.id,
    aws_security_group.allow-wazuh.id
  ]

  subnet_id = aws_subnet.sbnt[0].id
  key_name = "aws-personal"

  tags = {
    Name = "wazuh-server"
  }
}

output "wazuh_public_ip" {
  value = aws_instance.wazuh.public_ip
}

output "wazuh_public_dns" {
  value = aws_instance.staging_backend.public_dns
}