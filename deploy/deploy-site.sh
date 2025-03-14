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
rsync -avz --delete dist/ ec2-user@${SERVER_IP}:/var/www/html/

echo "✅ Deployment complete!"
echo "🌐 Your site should be accessible at:"
echo "   http://${SERVER_IP}"
echo "   http://$(cd deploy && terraform output -raw web_server_public_dns)"

# Remind about SSL setup
echo ""
echo "🔒 To set up SSL with Let's Encrypt, run:"
echo "   ssh ec2-user@${SERVER_IP} 'sudo /usr/local/bin/setup-ssl.sh vibe-coding.bat.mn'"
