#!/usr/bin/pwsh
. .\env.ps1

#--------------------------------------------------------------------
Write-Output "=== aws/alluvium-cloud"

Write-Output "--- Disable Old Secrets Engine"
vault secrets disable aws/alluvium-cloud

Write-Output "--- Enable Secrets Engine"
vault secrets enable -path aws/alluvium-cloud aws

Write-Output "--- Configure Secrets Engine"
&vault write aws/alluvium-cloud/config/root `
access_key=KEY `
secret_key=KEY `
region=us-west-2

Write-Output "--- Rotate Credential"
vault write -f aws/alluvium-cloud/config/rotate-root

#--------------------------------------------------------------------
Write-Output "=== aws/alluvium-master"

Write-Output "--- Disable Old Secrets Engine"
vault secrets disable aws/alluvium-master

Write-Output "--- Enable Secrets Engine"
vault secrets enable -path aws/alluvium-master aws

Write-Output "--- Configure Secrets Engine"
&vault write aws/alluvium-master/config/root `
access_key=KEY `
secret_key=KEY `
region=us-west-2

Write-Output "--- Rotate Credential"
vault write -f aws/alluvium-master/config/rotate-root