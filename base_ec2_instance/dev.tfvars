aws_region          = "ap-south-1"

availability_zones  = [
    "ap-south-1a",
    "ap-south-1b",
    "ap-south-1c"
]

vpc_cidr            = "10.0.0.0/16"

subnet_cidrs        = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
]

ami_id            = "ami-02eb0c2388ee999f9" # Amazon Linux 2 (verify in AWS console)

instance_type     = "t2.micro"

key_name          = "test-key-pair"

instance_name     = "dev-instance"
