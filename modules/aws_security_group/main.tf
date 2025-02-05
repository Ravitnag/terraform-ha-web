resource "aws_security_group" "ha-webapp_instance" {
  name = "ha-webapp-instance"
  ingress {
    from_port       = var.listen_port_value
    to_port         = var.listen_port_value
    protocol        = "tcp"
    security_groups = [aws_security_group.ha-webapp_lb.id]
  }
ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc_id_value
}

resource "aws_security_group" "ha-webapp_lb" {
  name = "ha-webapp-lb"
  ingress {
    from_port   = var.listen_port_value
    to_port     = var.listen_port_value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc_id_value
}

output "security_group_instance_id" {
  value = aws_security_group.ha-webapp_instance.id
}

output "security_group_lb_id" {
  value = aws_security_group.ha-webapp_lb.id
}