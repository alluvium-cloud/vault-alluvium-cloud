# TFC JWT Auth for Vault

Creates:
* A JWT Auth Method in Vault, for Terraform Cloud Dynamic Credentials https://developer.hashicorp.com/terraform/tutorials/cloud/dynamic-credentials
* Roles within that Auth Method for specified TFC Workspaces
* Environment variables in those TFC Workspaces to make use of the new roles


Example usage...

```

module "tfc-auth" {
  source  = "hashi-strawb/terraform-cloud-jwt-auth/vault"

  terraform = {
    org = "fancycorp"
  }

  vault = {
    addr             = "https://vault.fancycorp.io/"
    auth_path        = "tfc/fancycorp"
    auth_description = "JWT Auth for Terraform Cloud in fancycorp org"
  }

  roles = [
    {
      workspace_name = "tfc-jwt-test"
      token_policies = ["default"]
    }
  ]
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_variable.tfc_workspace_tfc_vault_addr](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfc_workspace_vault_addr](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfc_workspace_vault_auth_path](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfc_workspace_vault_provider_auth](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.tfc_workspace_vault_run_role](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [vault_jwt_auth_backend.tfc](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend) | resource |
| [vault_jwt_auth_backend_role.tfc_workspaces](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [tfe_workspace_ids.all](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/workspace_ids) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_roles"></a> [roles](#input\_roles) | n/a | <pre>list(object({<br>    workspace_name = string<br>    token_policies = list(string)<br><br>    project_name      = optional(string, "*") # Default to whatever project<br>    bound_audiences   = optional(list(string), ["vault.workload.identity"])<br>    bound_claims_type = optional(string, "glob")<br>    user_claim        = optional(string, "terraform_full_workspace")<br>    role_type         = optional(string, "jwt")<br>    token_ttl         = optional(number, 5 * 60)<br>  }))</pre> | `[]` | no |
| <a name="input_terraform"></a> [terraform](#input\_terraform) | n/a | <pre>object({<br>    org = string<br>  })</pre> | n/a | yes |
| <a name="input_vault"></a> [vault](#input\_vault) | n/a | <pre>object({<br>    addr = string<br><br>    auth_path               = optional(string, "tfc")<br>    auth_description        = optional(string, "JWT Auth for Terraform Cloud")<br>    auth_oidc_discovery_url = optional(string, "https://app.terraform.io")<br>    auth_bound_issuer       = optional(string, "https://app.terraform.io")<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
