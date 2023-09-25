module "tfc-auth-alluvium-cloud" {
  source = "./modules/terraform-vault-terraform-cloud-jwt-auth"

  terraform = {
    org = var.tfc_org
  }

  vault = {
    addr      = var.vault_addr
    auth_path = "tfc-alluvium-cloud"
  }

  roles = [
    {
      workspace_name  = "alluvium-infrastructure"
      project_name    = "Alluvium Cloud"
      token_policies  = ["default"]
      backend         = "aws/alluvium-cloud"
      policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
    }
  ]
}
