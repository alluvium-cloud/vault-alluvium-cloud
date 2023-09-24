terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.37.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.23.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.11.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.40.0"
    }
  }

  cloud {
    organization = "ericreeves-demo"
    hostname     = "app.terraform.io"

    workspaces {
      name = "vault-alluvium-cloud"
    }
  }
}
