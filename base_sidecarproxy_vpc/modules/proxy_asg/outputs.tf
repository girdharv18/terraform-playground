output "target_group_arn" {
  description = "ARN of the proxy target group"
  value       = aws_lb_target_group.proxy_tg.arn
}