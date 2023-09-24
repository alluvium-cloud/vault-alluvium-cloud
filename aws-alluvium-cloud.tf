module "tfc-auth-alluvium-cloud" {
  source = "./modules/terraform-vault-terraform-cloud-jwt-auth"

  terraform = local.terraform
  vault     = local.vault

  roles = [
    {
      workspace_name = "alluvium-infrastructure"
      project_name   = "Alluvium Cloud"
      auth_path      = "aws/alluvium-cloud"
      token_policies = ["traditional", "admin"]
    }
  ]
}
