# variables.tf — fixed

variable "region" {
  type        = string
  description = "AWS region to deploy the EKS cluster into."
}

variable "cluster_name" {
  type        = string
  description = "Name for the EKS cluster (used as a prefix for related resources)."
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the EKS cluster will be deployed."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the EKS control plane and node groups."
}

variable "node_instance_type" {
  type        = string
  default     = "t3.medium"
  description = "EC2 instance type for the EKS managed node group."
}

variable "desired_size" {
  type        = number
  default     = 2
  description = "Desired number of nodes in the node group."
}

variable "max_size" {
  type        = number
  default     = 5
  description = "Maximum number of nodes the cluster autoscaler can scale up to."
}

variable "min_size" {
  type        = number
  default     = 1
  description = "Minimum number of nodes the cluster autoscaler can scale down to."
}