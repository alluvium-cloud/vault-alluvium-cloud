module "tfc-auth" {
  source  = "hashi-strawb/terraform-cloud-jwt-auth/vault"
  version = "0.2.1"

  terraform = {
    org = "ericreeves-demo"
  }

  vault = {
    addr             = var.vault_addr
    auth_path        = "tfc/alluvium-cloud"
    auth_description = "JWT Auth for Terraform Cloud in alluvium-cloud"
  }

  roles = [
    {
      workspace_name = "tfc-jwt-test"
      token_policies = ["default"]
    }
  ]
}
