# Declaration des variables utilisees par le projet
variable "provider_region" {
  description = "Région AWS de déploiement"
  type        = string
  default     = "eu-west-3"
}

variable "server_instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t3.micro"
}

variable "ami_instance_type" {
  description = "ID de l'AMI à utiliser (dépend de la région). Vide : dernière Amazon Linux 2023."
  type        = string
  default     = ""
}

variable "server_tag_name" {
  description = "Nom du serveur (étiquette Name de l'instance)"
  type        = string
  default     = "tp-terraform"
}

variable "security_group_name" {
  description = "Nom du groupe de sécurité"
  type        = string
  default     = "tp-terraform-ssh"
}

variable "ssh_public_key_path" {
  description = "Chemin de la clé publique SSH déposée sur l'instance"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "my_ip_cidr" {
  description = "Adresse IP (au format CIDR, ex: 1.2.3.4/32) autorisée à se connecter en SSH"
  type        = string

  validation {
    condition     = can(cidrhost(var.my_ip_cidr, 0))
    error_message = "my_ip_cidr doit être au format CIDR, par exemple 1.2.3.4/32."
  }

  validation {
    condition     = var.my_ip_cidr != "0.0.0.0/0"
    error_message = "N'ouvre pas le SSH au monde entier : indique ton adresse IP publique suivie de /32."
  }
}
