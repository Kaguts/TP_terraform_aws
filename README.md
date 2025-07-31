# Deploiement d'une intance AWS EC2 avec Terraform
Ce dépôt contient les fichiers Terraform nécessaires pour déployer une instance ec2 infrastructure de base sur AWS.
## Prerequis
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    - [Configuration de AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
- [Générer les crédentials de connexion AWS](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
- [Clé SSH](https://docs.github.com/fr/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

## Configuration AWS
Assurez-vous d'avoir configuré vos informations d'identification AWS avant d'exécuter Terraform. Vous pouvez utiliser les variables d'environnement ou les fichiers de configuration AWS (`~/.aws/credentials` et `~/.aws/config`).

## Structure du Projet
- `00_providers.tf`: Contient la configuration Terraform pour se connecter et échanger avec de provider AWS.
- `01_resources.tf`: Contient la configuration Terraform pour déployer une VPC, un groupe de sécurité, un sous-réseau, et une instance EC2.
- `variables.tfvar`: Définit les variables utilisées dans le fichier `01_resources.tf`.
- `variables.tf`: Définit les types de variables.

## Instructions d'utilisation

1. Clonez ce dépôt sur votre machine locale :

    ```bash
    git clone https://github.com/Kaguts/TP_terraform_aws.git
    ```

2. Accédez au répertoire du projet :

    ```bash
    cd TP_terraform_aws
    ```

3. Initialisez Terraform :

    ```bash
    terraform init
    ```

4. Vérifiez les modifications à appliquer :

    ```bash
    terraform plan -var-file="variables.tfvar"
    ```

5. Appliquez les modifications :

    ```bash
    terraform apply -var-file="variables.tfvar"
    ```

    Répondez "yes" quand vous êtes prêt à déployer.

6. Une fois le déploiement terminé, vérifiez votre compte AWS pour vous assurer que les ressources ont été créées correctement.

7. Pour supprimer l'infrastructure

    ```bash
    terraform destroy -var-file="variables.tfvar"
    ```

## Variables
```hcl
provider_region      = "region_de_deploiement"
secret_access_key    = "clé_d'accès"
secret_key           = "clé_secrète"
server_instance_type = "type_d_instance"
ami_instance_type    = "numéro_ami"
server_tag_name      = "nom_serveur"
security_group_name  = "nom_groupe_securite"
ssh_public_key_path  = "chemin_clé_ssh/key.pub"
```

## Avertissement

- Assurez-vous de comprendre les implications des changements apportés à votre infrastructure AWS avant de les appliquer.
- Créer un utilisateur spécifique avec des droits uniquement pour EC2 et S3.

## Licence

Ce projet est sous licence [MIT](LICENSE).