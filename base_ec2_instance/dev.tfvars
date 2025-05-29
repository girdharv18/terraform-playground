aws_region        = "ap-south-1"
availability_zone = "ap-south-1a"
vpc_cidr          = "10.0.0.0/16"
subnet_cidr       = "10.0.1.0/24"
ami_id            = "ami-03bb6d83c60fc5f7c" # Amazon Linux 2 (verify in AWS console)
instance_type     = "t2.micro"
key_name          = "test-key-pair"
instance_name     = "dev-instance"
