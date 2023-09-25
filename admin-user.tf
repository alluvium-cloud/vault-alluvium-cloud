resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

resource "vault_policy" "admin" {
  name   = "admin-policy"
  policy = <<EOT
  path "*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
  }
  EOT
}

resource "random_string" "password" {
  length  = 18
  special = true
  upper   = true
}

variable "admin-username" {
  type    = string
  default = "alluvium-admin"
}

resource "vault_generic_endpoint" "admin" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/${var.admin-username}"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["admin-policy"],
  "password": "${random_string.password.result}"
}
EOT
}

output "vault_admin_username" {
  description = "The username of created user"
  value       = var.admin-username
}

output "vault_admin_password" {
  description = "The password of created user"
  value       = random_string.password.result
}

