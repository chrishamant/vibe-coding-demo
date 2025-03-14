# Deployment TODO List

## Prerequisites
- Make sure AWS CLI is installed and configured
- Ensure you have an SSH key pair for EC2 access
- Verify domain DNS settings for vibe-coding.bat.mn
- Ensure package-lock.json is committed to git

## Deployment Steps

### 1. Set up AWS credentials
```bash
export AWS_PROFILE=milewide
```

### 2. Initialize Terraform
```bash
cd deploy
terraform init
```

### 3. Plan the deployment
```bash
terraform plan
```
Review the plan output carefully to ensure it will create:
- EC2 instance (t3.micro)
- Security group with ports 22, 80, and 443 open
- All necessary configurations

### 4. Apply the Terraform configuration
```bash
terraform apply
```
When prompted, type `yes` to confirm.

### 5. Note the outputs
After deployment completes, note:
- EC2 instance public IP
- SSH connection string
- Deployment instructions

### 6. Update DNS records
Create an A record for vibe-coding.bat.mn pointing to the EC2 instance's IP address.

### 7. Deploy the static site
```bash
./deploy.sh
```

### 8. Set up SSL with Let's Encrypt
After DNS propagation (usually 5-30 minutes, but can take up to 24 hours):
```bash
ssh -i /path/to/your/key.pem ec2-user@<EC2_IP_ADDRESS> 'sudo /usr/local/bin/setup-ssl.sh vibe-coding.bat.mn'
```

## Verification
- Visit http://vibe-coding.bat.mn - should redirect to HTTPS
- Visit https://vibe-coding.bat.mn - should load without certificate errors
- Check that the spinning triangle appears and works correctly

## Cleanup (when no longer needed)
```bash
cd deploy
terraform destroy
```
When prompted, type `yes` to confirm.
