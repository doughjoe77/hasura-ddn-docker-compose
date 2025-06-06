# delete existing folders and metadata for Hasura
$dirPath = "./hasura20/metadata"

if (Test-Path $dirPath) {
    Remove-Item -Path $dirPath -Recurse -Force
} else {
    Write-Host "INFO Directory does not exist, skipping removal."
}

# re-initialize folder for Hasura
.\hasura20\hasura.exe init ./hasura20/metadata/

#export metadata from the server for Hasura
.\hasura20\\hasura.exe metadata export --admin-secret="123456" --endpoint="http://localhost:8080/" --project=".\hasura20\metadata\"