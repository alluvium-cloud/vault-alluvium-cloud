terraform = {
  org = "ericreeves-demo"
}

vault = {
  addr             = "https://alluvium-vault-public-vault-7a711d5b.bf50cbcb.z1.hashicorp.cloud:8200/"
  auth_path        = "tfc/alluvium-cloud"
  auth_description = "JWT Auth for Terraform Cloud in alluvium-cloud"
}

roles = [
  {
    workspace_name = "tfc-jwt-test"
    token_policies = ["default"]
  }
]