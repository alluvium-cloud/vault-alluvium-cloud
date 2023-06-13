NS=alluvium-cloud

vault namespace create ${NS}
vault policy write ${NS}-admin sudo-policy.hcl

vault token create -namespace admin/${NS} -policy ${NS}-admin


