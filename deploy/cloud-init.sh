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
# Usage: setup-ssl.sh yourdomain.com (or no args to use the default domain)

# Default domain from Terraform
DEFAULT_DOMAIN="vibe-coding.bat.mn"

if [ $# -eq 0 ]; then
    DOMAIN=$DEFAULT_DOMAIN
    echo "Using default domain: $DOMAIN"
else
    DOMAIN=$1
fi

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
