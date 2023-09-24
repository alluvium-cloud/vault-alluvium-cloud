module "tfc-auth-alluvium-master" {
  source = "./terraform-vault-terraform-cloud-jwt-auth"

  terraform = local.terraform
  vault     = local.vault

  roles = [
    {
      workspace_name = "tfc-jwt-test"
      project_name   = "Alluvium Cloud"
      token_policies = ["aws/alluvium-master/traditional", "aws/alluvium-master/admin"]
    }
  ]
}
