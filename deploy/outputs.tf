output "web_server_public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "The public IP address of the web server"
}

output "web_server_public_dns" {
  value       = aws_instance.web_server.public_dns
  description = "The public DNS of the web server"
}

output "ssh_connection_string" {
  value       = "ssh ec2-user@${aws_instance.web_server.public_ip}"
  description = "SSH connection string to connect to the instance"
}

output "deployment_instructions" {
  value       = "Run: rsync -avz --delete -e \"ssh -i /path/to/your/key.pem\" ../dist/ ec2-user@${aws_instance.web_server.public_ip}:/var/www/html/"
  description = "Command to deploy the static site to the EC2 instance"
}
