resource "aws_launch_template" "proxy_lt" {
  name_prefix   = "proxy-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.proxy_sg_id]
  key_name      = null

  user_data = filebase64("${path.module}/../../squid-install.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "proxy_asg" {
  name                 = "proxy-asg"
  max_size             = 3
  min_size             = 3
  desired_capacity     = 3
  vpc_zone_identifier  = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.proxy_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.proxy_tg.arn]

  tag {
    key                 = "Name"
    value               = "sidecar-proxy-instance"
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  force_delete = true
}

resource "aws_lb_target_group" "proxy_tg" {
  name        = "proxy-tg"
  port        = 3128
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 30
    port                = "3128"
    protocol            = "TCP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }
}