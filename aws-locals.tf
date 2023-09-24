locals {
  terraform = {
    org = "ericreeves-demo"
  }

  vault = {
    addr             = var.vault_addr
    auth_path        = "tfc-vault-jwt"
    auth_description = "JWT Auth for Terraform Cloud"
  }
}
