variable "vpc_id" {
  description = "VPC ID where NLB and endpoint service are created"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the NLB"
  type        = list(string)
}