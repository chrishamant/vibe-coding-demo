# Static Site Deployment

This directory contains Terraform configuration to deploy the static site to an AWS EC2 instance with HTTPS support using Let's Encrypt.

## Prerequisites

1. [Terraform](https://www.terraform.io/downloads.html) installed
2. AWS CLI configured with appropriate credentials
3. SSH key pair for accessing the EC2 instance
4. A domain name pointing to your server (for SSL setup)

## Deployment Steps

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Plan the deployment:
   ```
   terraform plan
   ```

3. Apply the configuration:
   ```
   terraform apply
   ```

4. After the EC2 instance is created, build and deploy the static site:
   ```
   ./deploy.sh
   ```

5. Set up SSL with Let's Encrypt (after your domain is pointing to the server):
   ```
   ssh ec2-user@<server-ip> 'sudo /usr/local/bin/setup-ssl.sh yourdomain.com'
   ```

## Customization

You can customize the deployment by modifying the variables in `variables.tf` or by providing values at runtime:

```
terraform apply -var="instance_type=t3.small" -var="aws_region=us-west-2"
```

## SSL Configuration

The server is pre-configured with Certbot for Let's Encrypt SSL certificates. After deploying:

1. Make sure your domain name's DNS records point to the server's IP address
2. SSH into the server and run the SSL setup script:
   ```
   sudo /usr/local/bin/setup-ssl.sh yourdomain.com
   ```

This will:
- Configure Nginx to use your domain name
- Obtain an SSL certificate from Let's Encrypt
- Set up automatic renewal of the certificate

## Cleanup

To destroy all resources created by Terraform:

```
terraform destroy
```
