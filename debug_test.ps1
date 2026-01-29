# Debug test script
[ServerCertificateValidationCallback]::Ignore()

$baseUrl = "https://localhost:8443/api"
$randomInt = Get-Random -Minimum 10000 -Maximum 99999

Write-Host "Testing API Registration..." -ForegroundColor Cyan
$body = @{
    username = "debugtest"
    email    = "debugtest${randomInt}@example.com"
    password = "DebugTest123!"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/auth/register" -Method Post -Body $body -ContentType "application/json"
    
    Write-Host "Response received:" -ForegroundColor Yellow
    Write-Host ($response | ConvertTo-Json -Depth 3)
    
    Write-Host "`nResponse properties:" -ForegroundColor Yellow
    $response.PSObject.Properties | ForEach-Object {
        Write-Host "  $($_.Name): $($_.Value)"
    }
}
catch {
    Write-Host "[FAIL] Test failed: $_" -ForegroundColor Red
    Write-Host "Exception: $($_.Exception.Message)" -ForegroundColor Red
}
