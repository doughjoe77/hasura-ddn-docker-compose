# check to see if you are logged in to the DDN, if you are not logged in you
# will be prompted to login to get your PAT
ddn auth login
$Env:HASURA_DDN_PAT = ddn auth print-access-token
$Env:PROMPTQL_SECRET_KEY = ddn auth print-promptql-secret-key

# check if the DDN .env file exists, if not then create it
$envFile = ".\domain-services\ddn\.env"
$exampleFile = ".\domain-services\ddn\.env_example"
$firstTimeSetup = $false
if (-Not (Test-Path $envFile)) {
    Copy-Item $exampleFile $envFile
    Write-Host ".env for running Hasura DDN Created!!!" -ForegroundColor Green
    $firstTimeSetup =$true
} 

# create the external network for Docker
docker network create ddn

# bring up the data sources
docker compose -f ./domain-services/datasource/compose.yaml --env-file ./domain-services/datasource/.env up -d

# bring up the DDN and it's components
Push-Location "./domain-services/ddn"
ddn run docker-start -- -d
Pop-Location

# load Hasura 2.0 metadata if this is a first time setup
if($firstTimeSetup -eq $true){
    .\hasura20\load-metadata.ps1
    Write-Host "Hasura 2.0 metadata loaded!!!" -ForegroundColor Green
    Write-Host "First time setup completed successfully!!!" -ForegroundColor Green
}