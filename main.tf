provider "vault" {
  namespace = "admin/alluvium-cloud"
}

resource "vault_mount" "this" {
  path    = "conad-cluster"
  type    = "kv-v2"
  options = { version = "2" }
}

resource "vault_auth_backend" "this" {
  type = "approle"

}

resource "vault_policy" "this" {
  name   = "vault-agent-policy"
  policy = <<EOT
  # Allow approle to read from conad-cluster/*
  path "secret/conad-cluster/*" {
    capabilities = ["read","list"]
  }
  # Allow tokens to query themselves
  path "auth/token/lookup-self" {
    capabilities = ["read"]
  }

  # Allow tokens to renew themselves
  path "auth/token/renew-self" {
      capabilities = ["update"]
  }

  # Allow tokens to revoke themselves
  path "auth/token/revoke-self" {
      capabilities = ["update"]
  }
  EOT

}

resource "vault_approle_auth_backend_role" "this" {
  backend        = vault_auth_backend.this.path
  role_name      = "vault-agent-approle"
  token_policies = ["default", "vault-agent-policy"]
}

resource "vault_approle_auth_backend_role_secret_id" "this" {
  backend   = vault_auth_backend.this.path
  role_name = vault_approle_auth_backend_role.this.role_name
  metadata = jsonencode(
    {
      "hello" = "world"
    }
  )
}

output "role_id" {
  description = "The role ID of created approle"
  value       = vault_approle_auth_backend_role.this.role_id
}

output "secret_id" {
  description = "The secret ID of created approle"
  value       = vault_approle_auth_backend_role_secret_id.this.*.secret_id
  sensitive   = true
}

output "policy_id" {
  description = "The policy ID"
  value       = vault_policy.this.id
}
