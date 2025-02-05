resource "aws_launch_template" "ha-webapp" {
  name_prefix          = var.name_prefix_value
  image_id             = var.ami_value
  instance_type        = var.instance_type_value
  user_data            = file("./modules/aws_asg/user-data.sh")
  # security_groups = [var.security_group_instance_id_value]

  network_interfaces {
    security_groups = [var.security_group_instance_id_value]
    associate_public_ip_address = true    
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ha-webapp" {
  min_size         = var.asg_min_size_value
  max_size         = var.asg_max_size_value
  desired_capacity = var.asg_min_size_value
  launch_template {
    id      = aws_launch_template.ha-webapp.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnets_value
}

resource "aws_lb" "ha-webapp" {
  name               = "ha-webapp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_lb_id_value]
  subnets            = var.subnets_value
}

resource "aws_lb_target_group" "ha-webapp" {
  name     = "ha-webapp"
  port     = var.listen_port_value
  protocol = var.protocol_value
  vpc_id   = var.vpc_id_value
}

resource "aws_autoscaling_attachment" "ha-webapp" {
  autoscaling_group_name = aws_autoscaling_group.ha-webapp.id
  lb_target_group_arn    = aws_lb_target_group.ha-webapp.arn
}

resource "aws_lb_listener" "ha-webapp" {
  load_balancer_arn = aws_lb.ha-webapp.arn
  port              = var.listen_port_value
  protocol          = var.protocol_value

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ha-webapp.arn
  }
}

output "lb_dns_name" {
  value = aws_lb.ha-webapp.dns_name
}

