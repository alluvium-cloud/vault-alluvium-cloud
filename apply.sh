NS=alluvium

vault namespace create $NS
vault policy write vault-admin sudo-policy.hcl

vault auth enable userpass

vault write \
        auth/userpass/users/vault-admin password="ch@s4giBoNYdKr6antkH" \
		policies="vault-admin"


