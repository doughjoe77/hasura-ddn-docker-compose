# Starting point for a scirpt to convert Hasura 2.0 JSON metadata to Hasura DDN compliant YAML files
# this will allow us for the majority of functions to have a functioning UI we can use to create our
# YAML

# Install required module for YAML processing (if not already installed)
Install-Module -Name powershell-yaml -Scope CurrentUser -Force

# Prompt the user for the JSON metadata file path
$metadataPath = Read-Host "Enter the full path to your metadata JSON file"

# Verify if the file exists
if (Test-Path $metadataPath) {
    # Read the JSON file
    $jsonContent = Get-Content -Path $metadataPath -Raw | ConvertFrom-Json
    
    # Convert JSON to YAML
    $yamlContent = ConvertTo-Yaml -Data $jsonContent
    
    # Define output path (same directory, different extension)
    $yamlPath = $metadataPath -replace ".json$", ".yaml"
    
    # Save the YAML output to a file
    $yamlContent | Out-File -FilePath $yamlPath
    
    Write-Host "Conversion complete! Saved as $yamlPath"
} else {
    Write-Host "Error: The specified file does not exist. Please try again."
}
