# check to see if you are logged in to the DDN, if you are not logged in you
# will be prompted to login to get your PAT
ddn auth login
$Env:HASURA_DDN_PAT = ddn auth print-access-token
$Env:PROMPTQL_SECRET_KEY = ddn auth print-promptql-secret-key

# bring up the data sources
docker compose -f ./domain-services/datasource/compose.yaml --env-file ./domain-services/datasource/.env up -d

# bring up the DDN and it's components
Push-Location "./domain-services/ddn"
ddn run docker-start -- -d
Pop-Location