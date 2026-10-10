# Deploiement d'une intance AWS EC2 avec Terraform
Ce dépôt contient les fichiers Terraform nécessaires pour déployer une instance EC2 joignable en SSH, avec son réseau, sur AWS.

## Ressources créées
- Un VPC (`10.0.0.0/16`) et un sous-réseau public (`10.0.1.0/24`)
- Une passerelle Internet et une table de routage (sans elles, l'instance est injoignable)
- Un groupe de sécurité qui n'autorise le SSH que depuis ton adresse IP
- Une paire de clés SSH
- Une instance EC2 Amazon Linux 2023 (IMDSv2 obligatoire, disque chiffré)

## Prerequis
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    - [Configuration de AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform) >= 1.5
- [Générer les crédentials de connexion AWS](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
- [Clé SSH](https://docs.github.com/fr/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

## Configuration AWS
Assurez-vous d'avoir configuré vos informations d'identification AWS avant d'exécuter Terraform. Vous pouvez utiliser les variables d'environnement ou les fichiers de configuration AWS (`~/.aws/credentials` et `~/.aws/config`).

## Structure du Projet
- `00_providers.tf`: Contient la configuration Terraform pour se connecter et échanger avec de provider AWS.
- `01_resources.tf`: Contient la configuration Terraform pour déployer le VPC, le réseau, le groupe de sécurité et l'instance EC2.
- `variables.tf`: Définit les variables, leur description et leur valeur par défaut.
- `terraform.tfvars.example`: Modèle à copier en `terraform.tfvars` (non versionné) pour donner tes valeurs.
- `outputs.tf`: Définit les valeurs affichées après le déploiement (IP publique, commande SSH).

## Instructions d'utilisation

1. Clonez ce dépôt sur votre machine locale :

    ```bash
    git clone https://github.com/Kaguts/TP_terraform_aws.git
    ```

2. Accédez au répertoire du projet :

    ```bash
    cd TP_terraform_aws
    ```

3. Créez votre fichier de variables et renseignez au minimum `my_ip_cidr`
   (votre IP publique, récupérable avec `curl ifconfig.me`) :

    ```bash
    cp terraform.tfvars.example terraform.tfvars
    ```

4. Initialisez Terraform :

    ```bash
    terraform init
    ```

5. Vérifiez les modifications à appliquer :

    ```bash
    terraform plan
    ```

6. Appliquez les modifications :

    ```bash
    terraform apply
    ```

    Répondez "yes" quand vous êtes prêt à déployer.

7. Connectez-vous à l'instance avec la commande affichée en sortie (`ssh_command`).

8. Pour supprimer l'infrastructure (et arrêter la facturation) :

    ```bash
    terraform destroy
    ```

## Variables
| Variable | Rôle | Défaut |
|---|---|---|
| `my_ip_cidr` | Adresse autorisée en SSH, au format CIDR (**obligatoire**) | aucun |
| `provider_region` | Région de déploiement | `eu-west-3` |
| `server_instance_type` | Type d'instance | `t3.micro` |
| `ami_instance_type` | ID d'AMI ; vide = dernière Amazon Linux 2023 | vide |
| `server_tag_name` | Nom du serveur | `tp-terraform` |
| `security_group_name` | Nom du groupe de sécurité | `tp-terraform-ssh` |
| `ssh_public_key_path` | Clé publique SSH déposée sur l'instance | `~/.ssh/id_ed25519.pub` |

## Avertissement

- Assurez-vous de comprendre les implications des changements apportés à votre infrastructure AWS avant de les appliquer.
- Créer un utilisateur spécifique avec des droits limités à ce dont le TP a besoin (EC2, VPC et lecture du paramètre SSM de l'AMI).
- Une instance allumée et son adresse IP publique sont facturées hors offre gratuite : pensez à `terraform destroy`.

## Licence

Ce projet est sous licence [MIT](LICENSE).
