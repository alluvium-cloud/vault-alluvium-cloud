#
# This code was all largey borrowed from the hashi-strawb/terrafom-cloud-jwt-auth/vault Module
# https://github.com/hashi-strawb/terraform-vault-terraform-cloud-jwt-auth
#
# The module is simply expanded here for demonstration purposes
# 
# Example of using the module directly:
#
# module "tfc-auth" {
#   source  = "hashi-strawb/terraform-cloud-jwt-auth/vault"
#   version = "0.2.1"

#   terraform = {
#     org = "ericreeves-demo"
#   }

#   vault = {
#     addr             = var.vault_addr
#     auth_path        = "tfc/alluvium-cloud"
#     auth_description = "JWT Auth for Terraform Cloud in alluvium-cloud"
#   }

#   roles = [
#     {
#       workspace_name = "tfc-jwt-test"
#       token_policies = ["default"]
#     }
#   ]
# }

##########################################################################
# Variables
##########################################################################
variable "terraform" {
  type = object({
    org = string
  })
}

variable "vault" {
  type = object({
    addr      = string
    namespace = optional(string)

    auth_path               = optional(string, "tfc")
    auth_description        = optional(string, "JWT Auth for Terraform Cloud")
    auth_oidc_discovery_url = optional(string, "https://app.terraform.io")
    auth_bound_issuer       = optional(string, "https://app.terraform.io")
  })
}

variable "roles" {
  type = list(object({
    workspace_name = string
    token_policies = list(string)

    project_name      = optional(string, "*") # Default to whatever project
    bound_audiences   = optional(list(string), ["vault.workload.identity"])
    bound_claims_type = optional(string, "glob")
    user_claim        = optional(string, "terraform_full_workspace")
    role_type         = optional(string, "jwt")
    token_ttl         = optional(number, 5 * 60)
  }))

  default = []
}


##########################################################################
# Data Lookups
##########################################################################
data "tfe_workspace_ids" "all" {
  names        = ["*"]
  organization = var.terraform.org
}

##########################################################################
# Resources
##########################################################################
resource "vault_jwt_auth_backend" "tfc" {
  description        = var.vault.auth_description
  path               = var.vault.auth_path
  oidc_discovery_url = var.vault.auth_oidc_discovery_url
  bound_issuer       = var.vault.auth_bound_issuer
}

resource "vault_jwt_auth_backend_role" "tfc_workspaces" {
  for_each = {
    for r in var.roles :
    "${var.terraform.org}_${r.workspace_name}" => r
  }

  backend = vault_jwt_auth_backend.tfc.path

  role_name      = each.key
  token_policies = each.value.token_policies

  bound_audiences   = each.value.bound_audiences
  bound_claims_type = each.value.bound_claims_type


  bound_claims = {
    "sub" = join(":", [
      "organization:${var.terraform.org}",
      "project:${each.value.project_name}",
      "workspace:${each.value.workspace_name}",
      "run_phase:*",
    ])
  }
  user_claim = each.value.user_claim
  role_type  = each.value.role_type
  token_ttl  = each.value.token_ttl
}

resource "tfe_variable" "tfc_workspace_vault_provider_auth" {
  for_each     = toset([for r in var.roles : r.workspace_name])
  key          = "TFC_VAULT_PROVIDER_AUTH"
  value        = true
  category     = "env"
  workspace_id = data.tfe_workspace_ids.all.ids[each.key]

  description = "Use TFC Dynamic Credentials to authenticate with Vault"
}

resource "tfe_variable" "tfc_workspace_tfc_vault_addr" {
  for_each     = toset([for r in var.roles : r.workspace_name])
  key          = "TFC_VAULT_ADDR"
  value        = var.vault.addr
  category     = "env"
  workspace_id = data.tfe_workspace_ids.all.ids[each.key]

  description = "Vault Address for TFC to use when authenticating with Vault"
}
resource "tfe_variable" "tfc_workspace_tfc_vault_namespace" {
  for_each = toset(var.vault.namespace != null ?
    [for r in var.roles : r.workspace_name] : []
  )
  key          = "TFC_VAULT_NAMESPACE"
  value        = var.vault.namespace
  category     = "env"
  workspace_id = data.tfe_workspace_ids.all.ids[each.key]

  description = "Vault Namespace for TFC to use when authenticating with Vault"
}

resource "tfe_variable" "tfc_workspace_vault_run_role" {
  for_each     = toset([for r in var.roles : r.workspace_name])
  key          = "TFC_VAULT_RUN_ROLE"
  value        = "${var.terraform.org}_${each.key}"
  category     = "env"
  workspace_id = data.tfe_workspace_ids.all.ids[each.key]

  description = "Role to use in the Vault auth method"
}

resource "tfe_variable" "tfc_workspace_vault_auth_path" {
  for_each     = toset([for r in var.roles : r.workspace_name])
  key          = "TFC_VAULT_AUTH_PATH"
  value        = vault_jwt_auth_backend.tfc.path
  category     = "env"
  workspace_id = data.tfe_workspace_ids.all.ids[each.key]

  description = "Path to use for the Vault auth method"
}

resource "tfe_variable" "tfc_workspace_vault_addr" {
  for_each     = toset([for r in var.roles : r.workspace_name])
  key          = "VAULT_ADDR"
  value        = var.vault.addr
  category     = "env"
  workspace_id = data.tfe_workspace_ids.all.ids[each.key]

  description = "Vault Address for the Vault Terraform Provider to use when running TF Plan/Apply"
}

resource "tfe_variable" "tfc_workspace_vault_namespace" {
  for_each = toset(var.vault.namespace != null ?
    [for r in var.roles : r.workspace_name] : []
  )
  key          = "VAULT_NAMESPACE"
  value        = var.vault.namespace
  category     = "env"
  workspace_id = data.tfe_workspace_ids.all.ids[each.key]

  description = "Vault Namespace for the Vault Terraform Provide to use when running TF Plan/Apply"
}
