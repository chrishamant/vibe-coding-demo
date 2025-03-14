variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"  # Consider restricting this in production
}

variable "domain_name" {
  description = "Domain name for the static site"
  type        = string
  default     = "vibe-coding.bat.mn"
}

variable "public_key" {
  description = "Public key for SSH access to the EC2 instance"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGysOV7IdOkjM497uYdQydKWA4ZLCGK7/JfFsGpVwuV"
}
