provider "vault" {
  namespace = "admin/alluvium-cloud"
}

resource "vault_mount" "conad-cluster" {
  path    = "conad-cluster"
  type    = "kv-v2"
  options = { version = "2" }
}

resource "vault_auth_backend" "approle" {
  type = "approle"
}

module "approle" {
  source = "app.terraform.io/ericreeves-demo/approle/vault"

  role_name   = "conad-cluster-role"
  policy_name = "conad-cluster-policy"
  policy      = <<EOT
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
