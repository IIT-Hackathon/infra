# Application Load balancer
resource "aws_lb" "textwizard-load-balancer" {
  name = "textwizard-load-balancer"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.allow-http-https.id]
  subnets = [aws_subnet.sbnt[0].id, aws_subnet.sbnt[1].id]
  enable_cross_zone_load_balancing = "true"

  tags = {
    Environment = "Production"
  }
}

# Target group
resource "aws_lb_target_group" "textwizard-target-group" {
  name = "textwizard-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc.id
  target_type = "instance"
  deregistration_delay = 10

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    path = "/"
    port = "traffic-port"
  }

  tags = {
    Environment = "Production"
  }

  depends_on = [ aws_lb.textwizard-load-balancer ]
}

# Forwarding rule from port 80 to port 80
resource "aws_lb_listener" "textwizard-listener" {
  load_balancer_arn = aws_lb.textwizard-load-balancer.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.textwizard-target-group.arn
  }

  depends_on = [ aws_lb_target_group.textwizard-target-group ]
}


# Target group attachment
resource "aws_lb_target_group_attachment" "textwizard-target-group-attachment" {
  target_group_arn = aws_lb_target_group.textwizard-target-group.arn
  target_id = aws_instance.prod_instance.id
  port = 80

  depends_on = [ aws_lb_listener.textwizard-listener ]
}