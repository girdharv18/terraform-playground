output "instance_id" {
  value       = aws_instance.web.id
  description = "EC2 Instance ID"
}

output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of EC2"
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID"
}

output "subnet_id" {
  value       = aws_subnet.main.id
  description = "Subnet ID"
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

output "wordpress_url" {
  value = "http://${aws_instance.web.public_ip}"
}
