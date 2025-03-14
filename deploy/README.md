# Static Site Deployment

This directory contains Terraform configuration to deploy the static site to an AWS EC2 instance.

## Prerequisites

1. [Terraform](https://www.terraform.io/downloads.html) installed
2. AWS CLI configured with appropriate credentials
3. SSH key pair for accessing the EC2 instance

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

## Customization

You can customize the deployment by modifying the variables in `variables.tf` or by providing values at runtime:

```
terraform apply -var="instance_type=t3.small" -var="aws_region=us-west-2"
```

## Cleanup

To destroy all resources created by Terraform:

```
terraform destroy
```
