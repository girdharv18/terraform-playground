# provider.tf — fixed

terraform {
  required_providers {
    aws        = { source = "hashicorp/aws",        version = "~> 5.0"  }
    helm       = { source = "hashicorp/helm",       version = "~> 2.10" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.25" }
    tls        = { source = "hashicorp/tls",        version = "~> 4.0"  }  # ADDED
  }
}

provider "aws" {
  region = var.region
}

# ✅ NEW: Fetch cluster details AFTER creation
data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks.name
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token  # FIXED
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token  # FIXED
}