resource "aws_lb" "nlb" {
  name               = "sidecar-nlb-${substr(md5(var.vpc_id), 0, 6)}"
  load_balancer_type = "network"
  subnets            = var.private_subnet_ids
  internal           = true

  enable_deletion_protection = false

  tags = {
    Name = "Sidecar-Proxy-NLB"
  }
}

resource "aws_lb_target_group" "nlb_tg" {
  name        = "sidecar-nlb-tg-${substr(md5(var.vpc_id), 0, 6)}"
  port        = 3128
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    protocol            = "TCP"
    port                = "3128"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 3128
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}

resource "aws_vpc_endpoint_service" "proxy_endpoint_service" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.nlb.arn]

  tags = {
    Name = "sidecar-proxy-endpoint-service"
  }
}