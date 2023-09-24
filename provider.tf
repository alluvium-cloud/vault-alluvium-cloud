provider "vault" {
  address   = "https://alluvium-vault-public-vault-7a711d5b.bf50cbcb.z1.hashicorp.cloud:8200/"
  namespace = "admin/alluvium-cloud"
}

provider "tfe" {
  token = var.tfc_token
}
