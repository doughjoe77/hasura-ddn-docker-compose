$dirPath = "./hasura20/metadata"

if (Test-Path $dirPath) {
    .\hasura20\hasura.exe deploy export --admin-secret="123456" --endpoint="http://localhost:8080/" --project=".\hasura20\metadata\" --log-level FATAL
} else {
    Write-Host "WARN No metadata availate @ '{$dirPath}' you must export your metadata before you can load it...;"
}


