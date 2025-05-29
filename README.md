# 🌱 Terraform Playground

Welcome to the **Terraform Playground** – a growing repository of Terraform configurations for provisioning cloud infrastructure on AWS and beyond. This repo is designed for **learning, experimentation, and collaboration** in the world of Infrastructure as Code (IaC).

---

## 🚀 Purpose

This project is created to:
- Practice and master Terraform through real-world examples
- Build a collection of reusable Terraform scripts
- Explore AWS infrastructure provisioning (EC2, VPC, S3, IAM, etc.)
- Encourage open collaboration among DevOps enthusiasts

---

## 📁 Structure

Each directory contains a specific Terraform use-case or module:

terraform-playground/
│
├── ec2-instance/ # Create EC2 instance with networking
├── s3-bucket/ # Provision and manage S3 buckets
├── vpc-basic/ # Custom VPC, subnets, route tables, etc.
├── iam-roles/ # IAM users, groups, roles, and policies
├── README.md # You're reading this
└── ...


Each sub-directory contains:
- `main.tf` – main configuration
- `variables.tf` – input variables
- `dev.tfvars` – sample variable values
- `output.tf` – Terraform outputs
- `README.md` (optional) – module-specific notes

---

## ✅ Getting Started

To try a Terraform configuration:

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/terraform-playground.git
   cd terraform-playground/<project-folder>

2. Initialize Terraform:
   terraform init

3. Plan and apply:
   terraform plan -var-file="dev.tfvars"
   terraform apply -var-file="dev.tfvars"


👥 Contributing
Contributions are welcome! Here’s how you can help:
Add new Terraform modules or use-cases
Improve existing configurations or structure
Open issues for bugs, improvements, or questions
Submit pull requests with clear documentation

📌 Guidelines
Keep each resource example in its own directory
Follow Terraform best practices (naming, variables, modules)
Include a dev.tfvars and output.tf where relevant
Add meaningful commit messages

📚 Prerequisites
Terraform installed
AWS CLI installed and configured (aws configure)
A valid AWS account with appropriate IAM permissions
An EC2 key pair for SSH access (for instance-related modules)

📄 License
This project is open-source under the MIT License.

🤝 Let's Collaborate!
If you're learning Terraform, interested in DevOps, or just like automating the cloud – this repo is for you!
Star ⭐ the repo, fork it, and start contributing!

Happy Terraforming! ⚙️

---

Let me know if you'd like help creating a `CONTRIBUTING.md`, issue templates, or GitHub Actions for CI/linting Terraform code.

