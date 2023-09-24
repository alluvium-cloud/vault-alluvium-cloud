#!/usr/bin/pwsh
. .\env.ps1

vault namespace create $Env:VAULT_NAMESPACE
vault policy write $Env:VAULT_NAMESPACE-admin sudo-policy.hcl

vault token create -namespace admin/$Env:VAULT_NAMESPACE -policy $Env:VAULT_NAMESPACE-admin
