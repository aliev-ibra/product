# Skip SSL certificate validation for self-signed certificates
if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type) {
    $certCallback = @"
    using System;
    using System.Net;
    using System.Net.Security;
    using System.Security.Cryptography.X509Certificates;
    public class ServerCertificateValidationCallback
    {
        public static void Ignore()
        {
            if(ServicePointManager.ServerCertificateValidationCallback == null)
            {
                ServicePointManager.ServerCertificateValidationCallback += 
                    delegate
                    (
                        Object obj, 
                        X509Certificate certificate, 
                        X509Chain chain, 
                        SslPolicyErrors errors
                    )
                    {
                        return true;
                    };
            }
        }
    }
"@
    Add-Type $certCallback
}
[ServerCertificateValidationCallback]::Ignore()

$baseUrl = "https://localhost:8443/api"
$randomInt = Get-Random -Minimum 10000 -Maximum 99999
$email = "secureuser${randomInt}@example.com"
$password = "SecurePass1!"

Write-Host "--- 1. Register User ---"
$registerBody = @{
    username = "secureuser"
    email    = $email
    password = $password
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/auth/register" -Method Post -Body $registerBody -ContentType "application/json"
    $token = $response.accessToken
    Write-Host "Registered successfully. Token: $token"
}
catch {
    Write-Host "Registration failed: $_"
    $_.Exception.Response.GetResponseStream() | ForEach-Object { $_.ReadToEnd() }
    exit
}

$headers = @{
    Authorization = "Bearer $token"
}

Write-Host "`n--- 2. Create Note ---"
$noteBody = @{
    title   = "Secret Note"
    content = "This is a private note for user $email"
} | ConvertTo-Json

try {
    $noteResponse = Invoke-RestMethod -Uri "$baseUrl/notes" -Method Post -Body $noteBody -Headers $headers -ContentType "application/json"
    $noteId = $noteResponse.id
    Write-Host "Note created with ID: $noteId"
    Write-Host "Note content: $($noteResponse.content)"
}
catch {
    Write-Host "Create note failed: $_"
    exit
}

Write-Host "`n--- 3. Get My Notes ---"
try {
    $notes = Invoke-RestMethod -Uri "$baseUrl/notes" -Method Get -Headers $headers
    Write-Host "Retrieved $($notes.Count) notes"
}
catch {
    Write-Host "Get notes failed: $_"
}

Write-Host "`n--- 4. Access Note by ID ---"
try {
    $note = Invoke-RestMethod -Uri "$baseUrl/notes/$noteId" -Method Get -Headers $headers
    Write-Host "Accessed note $noteId successfully: $($note.title)"
}
catch {
    Write-Host "Access note failed: $_"
}

Write-Host "`n--- 5. Register Another User (Attacker) ---"
$attackerEmail = "attacker${randomInt}@example.com"
$attackerBody = @{
    username = "attacker"
    email    = $attackerEmail
    password = $password
} | ConvertTo-Json

$attackerResponse = Invoke-RestMethod -Uri "$baseUrl/auth/register" -Method Post -Body $attackerBody -ContentType "application/json"
$attackerToken = $attackerResponse.accessToken
$attackerHeaders = @{
    Authorization = "Bearer $attackerToken"
}

Write-Host "`n--- 6. Attacker Tries to Access Victim's Note ---"
try {
    Invoke-RestMethod -Uri "$baseUrl/notes/$noteId" -Method Get -Headers $attackerHeaders
    Write-Host "ERROR: Attacker was able to access the note!"
}
catch {
    Write-Host "SUCCESS: Attacker denied access. Error: $($_.Exception.Message)"
}

Write-Host "`n--- 7. Delete Note ---"
try {
    Invoke-RestMethod -Uri "$baseUrl/notes/$noteId" -Method Delete -Headers $headers
    Write-Host "Note deleted successfully"
}
catch {
    Write-Host "Delete note failed: $_"
}
