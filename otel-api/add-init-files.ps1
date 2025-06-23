# Recursively find all directories under 'opentelemetry' that don't have __init__.py
$root = "opentelemetry"
$dirs = Get-ChildItem -Path $root -Recurse -Directory

# Include the root directory itself
$dirs = @((Get-Item $root)) + $dirs

foreach ($dir in $dirs) {
    $initPath = Join-Path $dir.FullName "__init__.py"
    if (-not (Test-Path $initPath)) {
        New-Item -ItemType File -Path $initPath -Force | Out-Null
        Write-Host "Created: $initPath"
    }
}
