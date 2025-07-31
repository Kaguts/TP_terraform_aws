# Le provider va permettre d'intéragir avec une API d'un fournisseur comme AWS 
terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Configuration pour pouvoir communiquer avec le provider AWS
provider "aws" {
    access_key = "${var.secret_access_key}"
    secret_key = "${var.secret_key}"
    region  = "${var.provider_region}"
}