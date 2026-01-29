$baseUrl = "https://localhost:8443/api"
$randomInt = Get-Random -Minimum 10000 -Maximum 99999

# Trust all certificates (Self-signed)
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

function Test-Request {
    param (
        [string]$Name,
        [scriptblock]$Script
    )
    Write-Host "Testing: $Name..." -NoNewline
    try {
        & $Script
        Write-Host " [PASS]" -ForegroundColor Green
    }
    catch {
        Write-Host " [FAIL]" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Yellow
    }
}

Write-Host "Starting Comprehensive Lab Verification..."
Write-Host "----------------------------------------"

# 1. Test Weak Password Registration
Test-Request "Weak Password Policy Enforcement" {
    $body = @{
        username = "weakuser"
        email    = "weak${randomInt}@test.com"
        password = "weak" # Too short, no special chars
    } | ConvertTo-Json
    
    try {
        Invoke-RestMethod -Uri "$baseUrl/auth/register" -Method Post -Body $body -ContentType "application/json" -ErrorAction Stop
        throw "Registration should have failed with weak password"
    }
    catch {
        if ($_.Exception.Response.StatusCode -eq "BadRequest" -or $_.Exception.Response.StatusCode -eq 400) {
            # Expected
        }
        else {
            throw "Unexpected status code: $($_.Exception.Response.StatusCode)"
        }
    }
}

# 2. Test SQL Injection in Login
Test-Request "SQL Injection Resistance (Login)" {
    $body = @{
        email    = "' OR '1'='1"
        password = "anything"
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method Post -Body $body -ContentType "application/json" -ErrorAction Stop
        throw "SQL Injection login should not succeed"
    }
    catch {
        if ($_.Exception.Response.StatusCode -eq "Forbidden" -or $_.Exception.Response.StatusCode -eq 403 -or $_.Exception.Response.StatusCode -eq 401) {
            # Expected (Auth failed)
        }
        else {
            if ($_.Exception.Response.StatusCode -eq 200) { throw "SQL Injection succeeded!" }
        }
    }
}

# 3. Test Unauthorized Access to Protected Resource
Test-Request "Protected Endpoint Access Control (No Token)" {
    try {
        Invoke-RestMethod -Uri "$baseUrl/notes" -Method Get -ErrorAction Stop
        throw "Should not be able to access notes without token"
    }
    catch {
        if ($_.Exception.Response.StatusCode -eq "Forbidden" -or $_.Exception.Response.StatusCode -eq 403 -or $_.Exception.Response.StatusCode -eq 401) {
            # Expected
        }
        else {
            throw "Unexpected status code: $($_.Exception.Response.StatusCode)"
        }
    }
}

# 4. Test Valid Registration & Login (Sanity Check)
$validEmail = "valid${randomInt}@test.com"
$validPass = "StrongP@ss1!"
$token = ""

Test-Request "Valid Registration" {
    $body = @{
        username = "validuser"
        email    = $validEmail
        password = $validPass
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "$baseUrl/auth/register" -Method Post -Body $body -ContentType "application/json"
    if (-not $response.accessToken) { throw "No token received" }
    $global:token = $response.accessToken
}

Test-Request "Valid Login" {
    $body = @{
        email    = $validEmail
        password = $validPass
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method Post -Body $body -ContentType "application/json"
    if (-not $response.accessToken) { throw "No token received" }
}

# 5. Test Access with Token
Test-Request "Protected Endpoint Access (With Token)" {
    $headers = @{ Authorization = "Bearer $global:token" }
    $response = Invoke-RestMethod -Uri "$baseUrl/notes" -Method Get -Headers $headers
}

Write-Host "----------------------------------------"
Write-Host "Verification Complete."
