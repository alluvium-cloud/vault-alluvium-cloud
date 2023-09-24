terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"

      # Needed for https://github.com/hashicorp/terraform-provider-vault/pull/1479
      version = ">= 3.7.0"
    }

    tfe = {
      source = "hashicorp/tfe"

      # Untested, but this seems like the minimum version that should work, based on:
      # https://github.com/hashicorp/terraform-provider-tfe/pull/698
      version = ">= 0.40.0"
    }
  }
}



# TODO: Use the create/find pattern we've established here:
# https://github.com/hashi-strawb/terraform-aws-tfc-dynamic-creds-provider/blob/main/main.tf

# TODO: optionally separate plan and apply roles

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

data "tfe_workspace_ids" "all" {
  names        = ["*"]
  organization = var.terraform.org
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
