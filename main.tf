provider "vault" {
  auth_login_userpass {
    username = var.TERRAFORM_USERNAME

  }
  alias     = "admin"
  namespace = "admin"
}

variable "VAULT_ADDR" {
  type        = string
  description = "Vault Address"
}

variable "TERRAFORM_VAULT_USERNAME" {
  type        = string
  description = "Vault Username"
}

variable "TERRAFORM_VAULT_PASSWORD" {
  type        = string
  description = "Vault Password"
}

#--------------------------------------
# Create 'admin/alluvium' namespace
#--------------------------------------
resource "vault_namespace" "alluvium" {
  provider = vault.admin
  path     = "alluvium"
}
