Clear-Host
Write-Host "Building Image"
docker build -t hasura-ddn-cli .
docker images hasura-ddn-cli
Write-Host "Image Built"