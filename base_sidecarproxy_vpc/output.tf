output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "proxy_target_group_arn" {
  value = module.proxy_asg.target_group_arn
}

output "vpc_endpoint_service_name" {
  value = module.privatelink.vpc_endpoint_service_name
}

output "nlb_dns_name" {
  value = module.privatelink.nlb_dns_name
}