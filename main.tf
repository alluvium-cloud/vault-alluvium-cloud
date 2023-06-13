provider "vault" {
  namespace = "admin/alluvium-cloud"
}

resource "vault_mount" "conad-cluster" {
  path    = "conad-cluster"
  type    = "kv-v2"
  options = { version = "2" }
}
