#!/bin/bash
set -e

echo "🚀 Starting site deployment..."

# Navigate to project root directory
cd "$(dirname "$0")/.."

# Build the site
echo "🔨 Building site..."
node build.js

# Get the server IP from terraform output
cd deploy
SERVER_IP=$(terraform output -raw web_server_public_ip)
cd ..

# Deploy to server
echo "📤 Deploying to server at ${SERVER_IP}..."

# Check if rsync is available
if command -v rsync &> /dev/null; then
    rsync -avz --delete dist/ ec2-user@${SERVER_IP}:/var/www/html/
else
    echo "rsync not found, using scp instead..."
    # Create a temporary tar file
    tar -czf dist.tar.gz -C dist .
    # Copy the tar file to the server
    scp dist.tar.gz ec2-user@${SERVER_IP}:~
    # Extract the tar file on the server
    ssh ec2-user@${SERVER_IP} "sudo rm -rf /var/www/html/* && sudo tar -xzf ~/dist.tar.gz -C /var/www/html && rm ~/dist.tar.gz"
    # Remove the local tar file
    rm dist.tar.gz
fi

echo "✅ Deployment complete!"
echo "🌐 Your site should be accessible at:"
echo "   http://${SERVER_IP}"
echo "   http://$(cd deploy && terraform output -raw web_server_public_dns)"

# Remind about SSL setup
echo ""
echo "🔒 To set up SSL with Let's Encrypt, run:"
echo "   ssh ec2-user@${SERVER_IP} 'sudo /usr/local/bin/setup-ssl.sh vibe-coding.bat.mn'"
