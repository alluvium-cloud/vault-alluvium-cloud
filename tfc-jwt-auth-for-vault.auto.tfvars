terraform = {
  org = "ericreeves-demo"
}

vault = {
  addr             = "https://alluvium-vault-public-vault-7a711d5b.bf50cbcb.z1.hashicorp.cloud:8200/"
  auth_path        = "tfc-vault-jwt"
  auth_description = "JWT for Dynamic Provider Credentials from Terraform Cloud to HCP Vault"
}

roles = [
  {
    workspace_name = "tfc-jwt-test"
    project_name   = "Alluvium Cloud"
    token_policies = ["default"]
  }
]