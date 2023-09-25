module "tfc-auth-alluvium-master" {
  source = "./modules/terraform-vault-terraform-cloud-jwt-auth"

  terraform = {
    org = var.tfc_org
  }

  vault = {
    addr      = var.vault_addr
    namespace = var.vault_namespace
    auth_path = "jwt-tfc-alluvium-master"
  }

  roles = [
    {
      workspace_name  = "tfc-jwt-test"
      project_name    = "Alluvium Cloud"
      token_policies  = ["tfc-policy"]
      backend         = "aws/alluvium-master"
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
