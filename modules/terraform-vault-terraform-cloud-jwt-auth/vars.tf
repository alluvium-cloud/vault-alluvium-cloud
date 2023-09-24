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
