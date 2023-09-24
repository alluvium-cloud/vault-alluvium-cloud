#!/usr/bin/pwsh
$Env:VAULT_ADDR=""
$Env:VAULT_TOKEN=""
$Env:VAULT_NAMESPACE="admin"

Write-Output "--- Enable JWT Auth"
vault auth enable jwt

Write-Output "--- Configure JWT Auth"
vault write auth/jwt/config oidc_discovery_url="https://app.terraform.io" bound_issuer="https://app.terraform.io"

Write-Output "--- Write tfc-policy"
vault policy write tfc-policy tfc-policy.hcl

Write-Output "--- Write Vault JWT Auth Role"
vault write auth/jwt/role/tfc-role @vault-jwt-auth-role.json


