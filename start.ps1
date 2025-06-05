$Env:HASURA_DDN_PAT = ddn auth print-access-token
$Env:PROMPTQL_SECRET_KEY = ddn auth print-promptql-secret-key
# bring up the data sources
docker compose -f ./domain-services/datasource/compose.yaml --env-file ./domain-services/datasource/.env up -d

# bring up the DDN and it's components
docker compose -f ./domain-services/ddn/compose.yaml --env-file ./domain-services/ddn/.env up -d