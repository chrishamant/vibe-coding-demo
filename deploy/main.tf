# AWS Provider configuration
provider "aws" {
  region = var.aws_region
}

# Data source to get the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# VPC and Security Group for the EC2 instance
resource "aws_security_group" "web_server" {
  name        = "web-server-sg"
  description = "Security group for web server"

  # Allow HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH traffic (for management)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-server-sg"
  }
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_server.id]
  
  # User data script to install and configure nginx
  user_data = <<-EOF
    #!/bin/bash
    # Update system packages
    dnf update -y
    
    # Install nginx
    dnf install -y nginx
    
    # Start and enable nginx
    systemctl start nginx
    systemctl enable nginx
    
    # Create directory for the static site
    mkdir -p /var/www/html
    
    # Set proper permissions
    chown -R nginx:nginx /var/www/html
    chmod -R 755 /var/www/html
    
    # Configure nginx to serve the static site
    cat > /etc/nginx/conf.d/static-site.conf << 'CONF'
    server {
        listen 80;
        server_name _;
        
        root /var/www/html;
        index index.html;
        
        location / {
            try_files $uri $uri/ =404;
        }
    }
    CONF
    
    # Remove default nginx configuration
    rm -f /etc/nginx/conf.d/default.conf
    
    # Restart nginx to apply changes
    systemctl restart nginx
  EOF

  tags = {
    Name = "static-site-web-server"
  }
}
