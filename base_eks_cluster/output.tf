############################
# outputs.tf
############################

############################
# CLUSTER IDENTITY
############################
output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = aws_eks_cluster.eks.name
}

output "cluster_arn" {
  description = "ARN of the EKS cluster."
  value       = aws_eks_cluster.eks.arn
}

output "cluster_version" {
  description = "Kubernetes version running on the cluster."
  value       = aws_eks_cluster.eks.version
}

############################
# CLUSTER CONNECTIVITY
############################
output "cluster_endpoint" {
  description = "API server endpoint for the EKS cluster."
  value       = aws_eks_cluster.eks.endpoint
}

output "cluster_certificate_authority" {
  description = "Base64-encoded certificate authority data for the cluster."
  value       = aws_eks_cluster.eks.certificate_authority[0].data
  sensitive   = true
}

# Convenience: ready-to-use kubeconfig update command.
output "kubeconfig_command" {
  description = "Run this command to configure kubectl for the dev cluster."
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.eks.name}"
}

############################
# OIDC / IRSA
############################
output "oidc_provider_arn" {
  description = "ARN of the IAM OIDC provider — required for creating additional IRSA roles."
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  description = "Issuer URL of the OIDC provider (without https://)."
  value       = replace(aws_iam_openid_connect_provider.eks.url, "https://", "")
}

############################
# IAM ROLES
############################
output "cluster_iam_role_arn" {
  description = "ARN of the IAM role used by the EKS control plane."
  value       = aws_iam_role.eks_cluster_role.arn
}

output "node_group_iam_role_arn" {
  description = "ARN of the IAM role used by the managed node group."
  value       = aws_iam_role.node_group_role.arn
}

output "autoscaler_iam_role_arn" {
  description = "ARN of the IRSA role bound to the cluster-autoscaler service account."
  value       = aws_iam_role.autoscaler_role.arn
}

output "alb_controller_iam_role_arn" {
  description = "ARN of the IRSA role bound to the aws-load-balancer-controller service account."
  value       = aws_iam_role.alb_role.arn
}

############################
# NODE GROUP
############################
output "node_group_arn" {
  description = "ARN of the primary managed node group."
  value       = aws_eks_node_group.node_group.arn
}

output "node_group_status" {
  description = "Current status of the managed node group."
  value       = aws_eks_node_group.node_group.status
}

output "node_group_scaling_config" {
  description = "Current scaling configuration (desired / min / max) for the node group."
  value = {
    desired_size = aws_eks_node_group.node_group.scaling_config[0].desired_size
    min_size     = aws_eks_node_group.node_group.scaling_config[0].min_size
    max_size     = aws_eks_node_group.node_group.scaling_config[0].max_size
  }
}

############################
# ADDONS
############################
output "addon_versions" {
  description = "Resolved versions of each EKS managed addon."
  value = {
    vpc_cni    = aws_eks_addon.vpc_cni.addon_version
    coredns    = aws_eks_addon.coredns.addon_version
    kube_proxy = aws_eks_addon.kube_proxy.addon_version
  }
}