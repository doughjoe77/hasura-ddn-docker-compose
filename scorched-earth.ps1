docker compose -f ./domain-services/datasource/compose.yaml down -v
docker compose -f ./domain-services/ddn/compose.yaml down -v
docker image rm -f datasource-sample-gql:latest
docker image rm -f datasource-idp:latest
docker image rm -f datasource-otel-api:latest
docker network remove ddn

# remove .env file, this will force the next .\start.ps1 run to re-create
# the .env file AND reload the Hasura 2.0 metadata
$envFile = ".\domain-services\ddn\.env"
if (Test-Path $envFile) {
    Remove-Item $envFile -Force
    Write-Host "Deleted .env file"
} 

Write-Host "Environment torn down sucessfully, run the command '.\start.ps1' to recreate it from scratch... " -ForegroundColor Yellow