# Adresse IP publique de l'instance EC2
output "instance_public_ip" {
  description = "Adresse IP publique de l'instance EC2"
  value       = aws_instance.mon_instance.public_ip
}

output "ami_id" {
  description = "AMI utilisée pour l'instance"
  value       = aws_instance.mon_instance.ami
}

output "ssh_command" {
  description = "Commande pour se connecter en SSH à l'instance (Amazon Linux : utilisateur ec2-user)"
  value       = "ssh ec2-user@${aws_instance.mon_instance.public_ip}"
}
