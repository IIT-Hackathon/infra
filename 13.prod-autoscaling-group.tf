resource "aws_autoscaling_group" "textwizard-autoscaling-group" {
    
    name = "textwizard-autoscaling-group"
    vpc_zone_identifier = aws_subnet.sbnt.*.id

    launch_template {
        id      = aws_launch_template.textwizard-launch-template.id
        version = "$Latest"
    }
    min_size = 2
    max_size = 5
    desired_capacity = 3
    health_check_type = "EC2"
    health_check_grace_period = 300
    force_delete = true
    tag {
        key = "Name"
        value = "textwizard-autoscaling-group"
        propagate_at_launch = true
    }
    tag {
        key = "Environment"
        value = "Production"
        propagate_at_launch = true
    }
    lifecycle {
        create_before_destroy = true
    }
}

# Autoscaling with Application Load Balancer
resource "aws_autoscaling_attachment" "textwizard-autoscaling-attachment" {
    autoscaling_group_name = aws_autoscaling_group.textwizard-autoscaling-group.id
    lb_target_group_arn = aws_lb_target_group.textwizard-target-group.arn
}