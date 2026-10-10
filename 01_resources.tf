# Zones de disponibilité de la région choisie (évite de figer "eu-west-3a")
data "aws_availability_zones" "available" {
  state = "available"
}

# Dernière image Amazon Linux 2023 de la région, publiée par AWS dans SSM.
# Utilisée quand la variable ami_instance_type est laissée vide.
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  ami_id = var.ami_instance_type != "" ? var.ami_instance_type : data.aws_ssm_parameter.al2023.value
}

# Définition de l'instance EC2
resource "aws_instance" "mon_instance" {
  ami                    = local.ami_id
  instance_type          = var.server_instance_type
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  subnet_id              = aws_subnet.my_subnet.id # Spécification du sous-réseau

  # Configuration pour une adresse IP publique
  associate_public_ip_address = true

  key_name = aws_key_pair.my_key_pair.key_name # Associez la clé SSH ici

  # IMDSv2 obligatoire : les métadonnées de l'instance (dont ses identifiants
  # temporaires) ne sont accessibles qu'avec un jeton de session.
  metadata_options {
    http_tokens = "required"
  }

  # Disque système chiffré
  root_block_device {
    encrypted = true
  }

  tags = {
    Name = var.server_tag_name
  }
}

# Déclaration de la clé ssh pour l'instance ec2
resource "aws_key_pair" "my_key_pair" {
  key_name   = "${var.server_tag_name}-key"
  public_key = file(pathexpand(var.ssh_public_key_path)) # Utilisation de la variable
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

# Passerelle Internet : sans elle, rien n'entre ni ne sort du VPC,
# même avec une adresse IP publique sur l'instance.
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyIGW"
  }
}

# Définition d'un sous-réseau
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id # Association avec la VPC principale
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "MySubnetPublic"
  }
}

# Table de routage du sous-réseau : tout le trafic sortant passe par la
# passerelle Internet (c'est ce qui en fait un sous-réseau "public").
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "MyRouteTablePublic"
  }
}

resource "aws_route_table_association" "my_subnet" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Définition du groupe de sécurité
resource "aws_security_group" "my_security_group" {
  name        = var.security_group_name
  description = "SSH depuis l'adresse autorisee uniquement"
  vpc_id      = aws_vpc.my_vpc.id

  # Règle d'entrée : SSH depuis ton adresse IP uniquement
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  # Règles de sortie autorisant tout le trafic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}
