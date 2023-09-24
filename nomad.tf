# resource "vault_nomad_secret_backend" "nomad-backend" {
#   backend                   = "nomad"
#   description               = "Conad Nomad Cluster Backend"
#   default_lease_ttl_seconds = "3600"
#   max_lease_ttl_seconds     = "7200"
#   max_ttl                   = "240"
#   address                   = "https://nomad.consul.service:4646"
#   token                     = "ae20ceaa-..."
#   ttl                       = "120"
# }

# resource "vault_policy" "nomad-cluster" {
#   name   = "nomad-cluster-policy"
#   policy = <<EOT
#   # Allow approle to read from conad-cluster/*
#   path "secret/conad-cluster/*" {
#     capabilities = ["read","list"]
#   }
#   # Allow tokens to query themselves
#   path "auth/token/lookup-self" {
#     capabilities = ["read"]
#   }

#   # Allow tokens to renew themselves
#   path "auth/token/renew-self" {
#       capabilities = ["update"]
#   }

#   # Allow tokens to revoke themselves
#   path "auth/token/revoke-self" {
#       capabilities = ["update"]
#   }
#   EOT
# }

# resource "vault_token_auth_backend_role" "nomad-cluster" {
#   role_name              = "nomad-cluster"
#   allowed_policies       = ["nomad-cluster-policy"]
#   token_explicit_max_ttl = 0
#   orphan                 = true
#   token_period           = 259200
#   renewable              = true
# }

# resource "vault_token" "nomad-cluster-token" {
#   policies  = ["nomad-cluster-policy"]
#   renewable = true
#   ttl       = "365d"
# }

# output "nomad_cluster_token" {
#   value     = vault_token.nomad-cluster-token.client_token
#   sensitive = true
# }
