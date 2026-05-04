############################
# dev.tfvars
# Variable values for the development environment.
# Usage: terraform plan  -var-file="dev.tfvars"
#        terraform apply -var-file="dev.tfvars"
############################

# ── AWS ──────────────────────────────────────────────────────────────────────
region       = "ap-south-1"
cluster_name = "dev-eks-cluster"

# ── Networking ────────────────────────────────────────────────────────────────
# Replace these with the actual IDs from your dev VPC.
# Retrieve them with:
#   aws ec2 describe-vpcs --filters "Name=tag:Env,Values=dev"
#   aws ec2 describe-subnets --filters "Name=tag:Env,Values=dev"
vpc_id             = "vpc-07b02afb38157bf66"
private_subnet_ids = [
  "subnet-0e9296bea3827d3dc",
  "subnet-042033a82e4a42f62",
  "subnet-0df14f909977fa8bd"
]

# ── Node group ────────────────────────────────────────────────────────────────
# t3.medium is a cost-effective default for dev; upgrade for heavier workloads.
node_instance_type = "t3.medium"

# Keep the node count low in dev to reduce cost.
# The autoscaler can still scale up to max_size under load.
desired_size = 2
min_size     = 1
max_size     = 3