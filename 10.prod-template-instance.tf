# Create a template instance for production
resource "aws_instance" "prod_instance" {
  ami           = var.prod-instance-ami   # Ubuntu wih docker, CodeDeploy Agent , Wazuh Agent, Node Exporter
  instance_type = "t3.large"              # 2 - 8

  vpc_security_group_ids = [
    aws_security_group.allow-http-https.id,
    aws_security_group.allow-monitoring-scarping.id
  ]

  subnet_id = aws_subnet.sbnt[0].id
  key_name = "aws-personal"

  tags = {
    Name = "textwizard-prod-instance"
    monitoring = "on"
  }

  iam_instance_profile = "CodeDeployAgent"
}


output "prod_public_ip" {
  value = aws_instance.prod_instance.public_ip
}

output "prod_public_dns" {
  value = aws_instance.prod_instance.public_dns
}