# Adresse IP publique de l'instance EC2
output "instance_public_ip" {
  description = "Adresse IP publique de l'instance EC2"
  value       = aws_instance.mon_instance.public_ip
}
