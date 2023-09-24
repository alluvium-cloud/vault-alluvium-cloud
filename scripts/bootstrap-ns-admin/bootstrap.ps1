#!/usr/bin/pwsh
$Env:VAULT_ADDR=""
$Env:VAULT_NAMESPACE="alluvium-cloud"

vault namespace create $Env:VAULT_NAMESPACE
vault policy write $Env:VAULT_NAMESPACE-admin sudo-policy.hcl

vault token create -namespace admin/$Env:VAULT_NAMESPACE -policy $Env:VAULT_NAMESPACE-admin


