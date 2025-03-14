#!/bin/bash
set -e

echo "🚀 Starting infrastructure deployment..."

# Navigate to the deploy directory if not already there
cd "$(dirname "$0")"

echo "🔧 Initializing Terraform..."
terraform init

echo "🔍 Planning Terraform deployment..."
terraform plan

echo "🏗️ Applying Terraform configuration..."
terraform apply -auto-approve

echo "✅ Deployment complete!"
echo ""
echo "📋 Deployment Summary:"
terraform output

echo ""
echo "🌐 Your site should be accessible soon at the IP address shown above."
echo "🔑 You can SSH to your instance using your configured SSH key."
