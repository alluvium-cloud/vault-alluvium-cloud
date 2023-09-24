module "tfc-auth-alluvium-cloud" {
  source = "./terraform-vault-terraform-cloud-jwt-auth"

  terraform = local.terraform
  vault     = local.vault

  roles = [
    {
      workspace_name = "alluvium-infrastructure"
      project_name   = "Alluvium Cloud"
      token_policies = ["aws/alluvium-cloud/traditional", "aws/alluvium-cloud/admin"]
    }
  ]
}
