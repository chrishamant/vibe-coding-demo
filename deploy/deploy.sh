#!/bin/bash

# Build the static site
echo "Building the static site..."
cd ..
npm run build

# Check if the build was successful
if [ $? -ne 0 ]; then
  echo "Build failed. Aborting deployment."
  exit 1
fi

# Get the EC2 instance public IP from Terraform output
EC2_IP=$(cd deploy && terraform output -raw web_server_public_ip)

if [ -z "$EC2_IP" ]; then
  echo "Could not get EC2 IP address. Make sure Terraform has been applied."
  exit 1
fi

echo "Deploying to EC2 instance at $EC2_IP..."

# Use rsync or scp to copy the files to the EC2 instance
# Note: This assumes you have SSH access configured with key-based authentication
# Replace 'ec2-user' with the appropriate username if different
# Replace '/path/to/your/key.pem' with the path to your SSH key

# rsync -avz --delete -e "ssh -i /path/to/your/key.pem" dist/ ec2-user@$EC2_IP:/var/www/html/

echo "To manually deploy the files, run:"
echo "rsync -avz --delete -e \"ssh -i /path/to/your/key.pem\" dist/ ec2-user@$EC2_IP:/var/www/html/"

echo "Deployment instructions complete."
