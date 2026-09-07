output "vpc_endpoint_service_name" {
  description = "VPC Endpoint Service name for PrivateLink"
  value       = aws_vpc_endpoint_service.proxy_endpoint_service.service_name
}

output "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = aws_lb.nlb.dns_name
}