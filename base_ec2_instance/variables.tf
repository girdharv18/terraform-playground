variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "availability_zone" {
  description = "AZ in the region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair for SSH"
  type        = string
}

variable "instance_name" {
  description = "Tag name for EC2"
  type        = string
}
