# Définition de l'instance EC2
resource "aws_instance" "mon_instance" {
  ami                    = "${var.ami_instance_type}" # Amazon Linux 2023
  instance_type          = "${var.server_instance_type}"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  subnet_id              = aws_subnet.my_subnet.id # Spécification du sous-réseau
  
  # Configuration pour une adresse IP publique
  associate_public_ip_address = true

  key_name = aws_key_pair.my_key_pair.key_name # Associez la clé SSH ici

  tags = {
    Name = "${var.server_tag_name}"
  }
}
# Déclaration de la clé ssh pour l'instance ec2
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-aws-key" # Remplacez par le nom de votre paire de clés
  public_key = file(var.ssh_public_key_path) # Utilisation de la variable
}

# Définition du VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

# Définition du groupe de sécurité
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "My Security Group"
  vpc_id      = aws_vpc.my_vpc.id

  # Règles d'entrée autorisant le trafic SSH depuis n'importe où
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Règles de sortie autorisant tout le trafic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.security_group_name}"
  }
}

# Définition d'un sous-réseau
resource "aws_subnet" "my_subnet" {
  vpc_id               = aws_vpc.my_vpc.id     # Association avec la VPC principale
  cidr_block           = "10.0.0.0/16"
  availability_zone    = "eu-west-3a"           # Zone de disponibilité pour le sous-réseau
}