provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "main-vpc"
  }
}

# Subnet
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "main-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "main-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

# Security Group
resource "aws_security_group" "main_sg" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  description = "HTTPS"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-sg"
  }
}

# EC2 Instance with SQLite WordPress Setup
resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.main_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

      user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update and install required packages
              yum update -y
              amazon-linux-extras enable php8.2
              amazon-linux-extras install -y php8.2
              yum install -y httpd php php-pdo php-mbstring php-dom php-gd php-json php-sqlite3 wget unzip

              # Start and enable Apache
              systemctl enable httpd
              systemctl start httpd

              # Disable SELinux (if enabled)
              if selinuxenabled; then
                setenforce 0
                sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
              fi

              # Open HTTP port in firewall if firewalld is running
              if systemctl is-active --quiet firewalld; then
                firewall-cmd --permanent --add-service=http
                firewall-cmd --reload
              fi

              # Download and install WordPress
              cd /var/www/html
              wget https://wordpress.org/latest.zip
              unzip latest.zip
              mv wordpress/* .
              rm -rf wordpress latest.zip

              # Download and configure SQLite Integration plugin
              wget https://downloads.wordpress.org/plugin/sqlite-integration.1.8.1.zip
              unzip sqlite-integration.1.8.1.zip
              cp -r sqlite-integration/wp-content/* wp-content/
              cp sqlite-integration/db.php wp-content/db.php
              rm -rf sqlite-integration sqlite-integration.1.8.1.zip

              # Set permissions
              mkdir -p wp-content/database
              chown -R apache:apache /var/www/html
              chmod -R 755 /var/www/html

              # Setup wp-config.php with SQLite compatible config
              cp wp-config-sample.php wp-config.php
              sed -i '/DB_/d' wp-config.php

              cat <<CONFIG >> wp-config.php
              define('DB_FILE', __DIR__ . '/wp-content/database/wordpress.db');
              define('WP_HOME', 'http://' . \$_SERVER['HTTP_HOST']);
              define('WP_SITEURL', 'http://' . \$_SERVER['HTTP_HOST']);
              CONFIG

              # Restart Apache to apply changes
              systemctl restart httpd

              # Health check
              curl -I http://localhost || true
              EOF
  tags = {
    Name = var.instance_name
    Environment = "dev"
    Project = "Nishant-Wordpress-sqlite"
  }
}
