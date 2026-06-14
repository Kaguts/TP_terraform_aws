# Le provider va permettre d'intéragir avec une API d'un fournisseur comme AWS
terraform {
    required_version = ">= 1.5"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Configuration pour pouvoir communiquer avec le provider AWS
# Les credentials sont lus depuis la configuration AWS CLI (~/.aws/credentials, variables d'environnement, etc.)
provider "aws" {
    region = "${var.provider_region}"
}