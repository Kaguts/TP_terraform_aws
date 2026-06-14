# Declaration de la region
provider_region      = "region_de_deploiement"
# Declaration du type d'instance
server_instance_type = "t2.micro"
# Declaration de l'AMI a utiliser (ID dependant de la region, ex: ami-xxxxxxxx)
# Recuperer AMI ici https://eu-west-3.console.aws.amazon.com/ec2/home?region=eu-west-3#AMICatalog:
ami_instance_type    = "numéro_ami"
# Nom du serveur
server_tag_name      = "nom_serveur"
# Nom du groupe de securite
security_group_name  = "nom_groupe_securite"
# Chemin de la clé ssh pour l'instance ec2
ssh_public_key_path  = "chemin_cle_ssh/key.pub"
