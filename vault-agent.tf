
resource "vault_mount" "vault-agent" {
  path    = "conad-cluster"
  type    = "kv-v2"
  options = { version = "2" }
}

resource "vault_auth_backend" "vault-agent" {
  type = "approle"
}

resource "vault_policy" "vault-agent" {
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

resource "vault_approle_auth_backend_role" "vault-agent" {
  backend        = vault_auth_backend.vault-agent.path
  role_name      = "vault-agent-approle"
  token_policies = ["default", "vault-agent-policy"]
}

resource "vault_approle_auth_backend_role_secret_id" "vault-agent" {
  backend   = vault_auth_backend.vault-agent.path
  role_name = vault_approle_auth_backend_role.vault-agent.role_name
  metadata = jsonencode(
    {
      "hello" = "world"
    }
  )
}

output "vault_agent_role_id" {
  description = "The role ID of created approle"
  value       = vault_approle_auth_backend_role.vault-agent.role_id
}

output "vault_agent_secret_id" {
  description = "The secret ID of created approle"
  value       = vault_approle_auth_backend_role_secret_id.vault-agent.*.secret_id
  sensitive   = true
}

output "vault_agent_policy_id" {
  description = "The policy ID"
  value       = vault_policy.vault-agent.id
}
