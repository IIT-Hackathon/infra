resource "aws_launch_template" "textwizard-launch-template" {
    name = "textwizard-launch-template"
    image_id = var.prod-instance-ami
    instance_type = "t3.large"              # Free tier
    key_name = "aws-personal"
    
    iam_instance_profile {
        name = "CodeDeployAgent"
    }
    
    vpc_security_group_ids = [
        aws_security_group.allow-http-https.id,
        aws_security_group.allow-ssh.id,
        aws_security_group.allow-monitoring-scarping.id
    ]

    block_device_mappings {
        device_name = "/dev/sda1"
        ebs {
            volume_size = 20
        }
    }
}