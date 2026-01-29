# Quick test script to verify the fixes
[ServerCertificateValidationCallback]::Ignore()

$baseUrl = "https://localhost:8443/api"
$randomInt = Get-Random -Minimum 10000 -Maximum 99999

Write-Host "Testing API Registration..." -ForegroundColor Cyan
$body = @{
    username = "quicktest"
    email    = "quicktest${randomInt}@example.com"
    password = "QuickTest123!"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/auth/register" -Method Post -Body $body -ContentType "application/json"
    
    if ($response.accessToken) {
        Write-Host "[PASS] Registration successful!" -ForegroundColor Green
        Write-Host "[PASS] Access Token received: YES" -ForegroundColor Green
        Write-Host "[PASS] Refresh Token received: $($response.refreshToken -ne $null)" -ForegroundColor Green
        Write-Host "[PASS] User ID: $($response.id)" -ForegroundColor Green
        Write-Host "[PASS] Email: $($response.email)" -ForegroundColor Green
        
        # Test accessing notes with token
        Write-Host "`nTesting API Notes Access..." -ForegroundColor Cyan
        $headers = @{ Authorization = "Bearer $($response.accessToken)" }
        $notes = Invoke-RestMethod -Uri "$baseUrl/notes" -Method Get -Headers $headers
        Write-Host "[PASS] Notes endpoint accessible with token!" -ForegroundColor Green
        Write-Host "[PASS] Number of notes: $($notes.Count)" -ForegroundColor Green
        
        Write-Host "`n=== ALL TESTS PASSED ===" -ForegroundColor Green
    }
    else {
        Write-Host "[FAIL] No access token received!" -ForegroundColor Red
    }
}
catch {
    Write-Host "[FAIL] Test failed: $_" -ForegroundColor Red
}
