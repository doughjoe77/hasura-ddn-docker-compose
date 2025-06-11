# Define the IDP token endpoint URL, matching the Node.js IDP server.
$IDPTokenUrl = "http://localhost:3000/token"

do {
    $choice = Read-Host "Please choose an option ('hasura-admin' or 'user-john-doe')"
    if ($choice -ne "hasura-admin" -and $choice -ne "user-john-doe") {
        Write-Host "Invalid option. Please enter 'hasura-admin' or 'user-john-doe'."
    }
} until ($choice -eq "hasura-admin" -or $choice -eq "user-john-doe")

Write-Host "You selected: $choice"

# Set your client credentials as defined in your .env file.
$ClientID = $choice         # Replace with your actual client id
$ClientSecret = "test123" # Replace with your actual client secret

# Build the form data as a hashtable.
$Body = @{
    grant_type    = "client_credentials"
    client_id     = $ClientID
    client_secret = $ClientSecret
}

# Send the POST request to the token endpoint.
$response = Invoke-RestMethod -Uri $IDPTokenUrl -Method Post -Headers @{ "Content-Type" = "application/x-www-form-urlencoded" } -Body $Body

# Extract and display the JWT.
$JWT = $response.access_token
Write-Host "Your JWT token:" $JWT
$JWT | Set-Clipboard

