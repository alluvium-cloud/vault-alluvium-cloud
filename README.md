# Alluvium Cloud Vault Configuration
---

The intention of this repository is to manage the configuration of a Vault namespace 'alluvium-cloud'.

A few manual actions must be taken to bootstrap this workspace:

- Create the Vault namespace 'alluvium-cloud'
- Create an admin policy in namespace 'alluvium-cloud'
- Create a token from the above admin policy
- Configure environment variables VAULT_ADDR and VAULT_TOKEN in the TFC workspace for this repo.