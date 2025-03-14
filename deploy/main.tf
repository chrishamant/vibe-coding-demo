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
  
  # User data script to install and configure nginx with Let's Encrypt
  user_data = <<-EOF
    #!/bin/bash
    # Update system packages
    dnf update -y
    
    # Install nginx and certbot
    dnf install -y nginx certbot python3-certbot-nginx
    
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
        listen [::]:80;
        server_name _;
        
        root /var/www/html;
        index index.html;
        
        location / {
            try_files $uri $uri/ =404;
        }
        
        # For Let's Encrypt verification
        location ~ /.well-known/acme-challenge {
            allow all;
            root /var/www/html;
        }
    }
    CONF
    
    # Remove default nginx configuration
    rm -f /etc/nginx/conf.d/default.conf
    
    # Restart nginx to apply changes
    systemctl restart nginx
    
    # Create a script to obtain and renew certificates
    cat > /usr/local/bin/setup-ssl.sh << 'SSLSCRIPT'
    #!/bin/bash
    
    # This script should be run after the DNS is properly set up
    # Usage: setup-ssl.sh yourdomain.com
    
    if [ $# -eq 0 ]; then
        echo "Usage: $0 yourdomain.com"
        exit 1
    fi
    
    DOMAIN=$1
    
    # Update the nginx config to include the domain name
    sed -i "s/server_name _;/server_name $DOMAIN;/" /etc/nginx/conf.d/static-site.conf
    systemctl reload nginx
    
    # Obtain SSL certificate
    certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN
    
    # Set up auto-renewal
    echo "0 3 * * * root certbot renew --quiet" > /etc/cron.d/certbot-renew
    
    echo "SSL setup complete for $DOMAIN"
    SSLSCRIPT
    
    chmod +x /usr/local/bin/setup-ssl.sh
    
    # Create instructions file
    cat > /home/ec2-user/README.txt << 'README'
    Static Site with SSL Setup
    
    Your static site is now running on this server with Nginx.
    
    To set up SSL with Let's Encrypt:
    
    1. Make sure your domain (e.g., yourdomain.com) points to this server's IP address
    2. Run the following command:
       sudo /usr/local/bin/setup-ssl.sh yourdomain.com
    
    This will:
    - Configure Nginx to use your domain name
    - Obtain an SSL certificate from Let's Encrypt
    - Set up automatic renewal of the certificate
    
    Your site will then be accessible via HTTPS.
    README
    
    chown ec2-user:ec2-user /home/ec2-user/README.txt
  EOF

  tags = {
    Name = "static-site-web-server"
  }
}
