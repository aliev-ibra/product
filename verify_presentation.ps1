# Pre-Presentation Verification Script
# Run this script BEFORE your presentation to verify everything works

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PRE-PRESENTATION VERIFICATION SCRIPT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$baseUrl = "https://localhost:8443"
$errors = @()
$warnings = @()

# Ignore SSL certificate errors for self-signed cert
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint svcPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "1. Checking if application is running..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/login" -UseBasicParsing -SessionVariable session
    if ($response.StatusCode -eq 200) {
        Write-Host "   ✅ Application is running on HTTPS port 8443" -ForegroundColor Green
    }
} catch {
    Write-Host "   ❌ Application is NOT running!" -ForegroundColor Red
    $errors += "Application not running. Start with: ./mvnw.cmd spring-boot:run"
    Write-Host ""
    Write-Host "CRITICAL ERROR: Application must be running!" -ForegroundColor Red
    Write-Host "Run: ./mvnw.cmd spring-boot:run" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "2. Checking Security Headers..." -ForegroundColor Yellow

$headers = $response.Headers
$requiredHeaders = @{
    "X-Content-Type-Options" = "nosniff"
    "X-Frame-Options" = "SAMEORIGIN"
    "Strict-Transport-Security" = "max-age="
    "Referrer-Policy" = "strict-origin-when-cross-origin"
}

foreach ($header in $requiredHeaders.Keys) {
    if ($headers[$header]) {
        $value = $headers[$header]
        if ($value -like "*$($requiredHeaders[$header])*") {
            Write-Host "   ✅ $header : $value" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  $header : $value (unexpected value)" -ForegroundColor Yellow
            $warnings += "$header has unexpected value"
        }
    } else {
        Write-Host "   ❌ $header : MISSING" -ForegroundColor Red
        $errors += "$header header is missing"
    }
}

# Check for CSP header
if ($headers["Content-Security-Policy"]) {
    Write-Host "   ✅ Content-Security-Policy : Present" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Content-Security-Policy : MISSING" -ForegroundColor Yellow
    $warnings += "CSP header might be missing"
}

Write-Host ""
Write-Host "3. Checking Cookie Security..." -ForegroundColor Yellow

# Try to get session cookie
$cookies = $session.Cookies.GetCookies($baseUrl)
$sessionCookie = $cookies | Where-Object { $_.Name -eq "JSESSIONID" }

if ($sessionCookie) {
    Write-Host "   ✅ JSESSIONID cookie found" -ForegroundColor Green
    
    if ($sessionCookie.HttpOnly) {
        Write-Host "   ✅ HttpOnly: True" -ForegroundColor Green
    } else {
        Write-Host "   ❌ HttpOnly: False" -ForegroundColor Red
        $errors += "Cookie is not HttpOnly"
    }
    
    if ($sessionCookie.Secure) {
        Write-Host "   ✅ Secure: True" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Secure: False" -ForegroundColor Red
        $errors += "Cookie is not Secure"
    }
} else {
    Write-Host "   ⚠️  JSESSIONID cookie not found (might need login)" -ForegroundColor Yellow
    $warnings += "Session cookie not found - you'll need to show this during demo"
}

Write-Host ""
Write-Host "4. Testing Registration Endpoint..." -ForegroundColor Yellow

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/register" -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "   ✅ Registration page accessible" -ForegroundColor Green
    }
} catch {
    Write-Host "   ❌ Registration page error: $($_.Exception.Message)" -ForegroundColor Red
    $errors += "Registration page not accessible"
}

Write-Host ""
Write-Host "5. Testing Protected Endpoint (should redirect)..." -ForegroundColor Yellow

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/dashboard" -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
} catch {
    if ($_.Exception.Response.StatusCode -eq 302 -or $_.Exception.Response.StatusCode -eq 401 -or $_.Exception.Response.StatusCode -eq 403) {
        Write-Host "   ✅ Protected endpoint requires authentication" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Unexpected response: $($_.Exception.Response.StatusCode)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "6. Checking Project Files..." -ForegroundColor Yellow

$criticalFiles = @(
    "src/main/java/com/example/lab10/config/SecurityConfig.java",
    "src/main/java/com/example/lab10/service/NoteService.java",
    "src/main/java/com/example/lab10/dto/UserDTO.java",
    "src/main/java/com/example/lab10/validation/PasswordValidator.java",
    "src/main/java/com/example/lab10/security/AuthenticationEvents.java",
    "src/main/java/com/example/lab10/repository/NoteRepository.java",
    "src/main/java/com/example/lab10/filter/RateLimitFilter.java",
    "src/test/java/com/example/lab10/SecurityTest.java",
    ".github/workflows/maven.yml",
    "pom.xml"
)

foreach ($file in $criticalFiles) {
    if (Test-Path $file) {
        Write-Host "   ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $file MISSING" -ForegroundColor Red
        $errors += "$file is missing"
    }
}

Write-Host ""
Write-Host "7. Running Tests..." -ForegroundColor Yellow
Write-Host "   (This may take 10-15 seconds...)" -ForegroundColor Gray

try {
    $testOutput = & ./mvnw.cmd test -q 2>&1
    $testResult = $LASTEXITCODE
    
    if ($testResult -eq 0) {
        Write-Host "   ✅ All tests PASSED" -ForegroundColor Green
        
        # Check for specific test classes
        if ($testOutput -match "SecurityTest") {
            Write-Host "   ✅ SecurityTest found" -ForegroundColor Green
        }
        if ($testOutput -match "UserValidationTest") {
            Write-Host "   ✅ UserValidationTest found" -ForegroundColor Green
        }
    } else {
        Write-Host "   ❌ Tests FAILED" -ForegroundColor Red
        $errors += "Tests are failing - run './mvnw.cmd test' to see details"
    }
} catch {
    Write-Host "   ❌ Error running tests: $($_.Exception.Message)" -ForegroundColor Red
    $errors += "Could not run tests"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VERIFICATION SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($errors.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "🎉 ALL CHECKS PASSED! You're ready for the presentation!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Cyan
    Write-Host "1. Review MAX_POINTS_CHECKLIST.md" -ForegroundColor White
    Write-Host "2. Review QUICK_REFERENCE.md" -ForegroundColor White
    Write-Host "3. Practice your demo flow (aim for under 10 minutes)" -ForegroundColor White
    Write-Host "4. Have browser in incognito mode with DevTools ready" -ForegroundColor White
    Write-Host "5. Have code editor with files open" -ForegroundColor White
    Write-Host ""
    Write-Host "Expected Score: 90/90 ⭐⭐⭐" -ForegroundColor Green
} else {
    if ($errors.Count -gt 0) {
        Write-Host "❌ ERRORS FOUND ($($errors.Count)):" -ForegroundColor Red
        foreach ($error in $errors) {
            Write-Host "   • $error" -ForegroundColor Red
        }
        Write-Host ""
    }
    
    if ($warnings.Count -gt 0) {
        Write-Host "⚠️  WARNINGS ($($warnings.Count)):" -ForegroundColor Yellow
        foreach ($warning in $warnings) {
            Write-Host "   • $warning" -ForegroundColor Yellow
        }
        Write-Host ""
    }
    
    if ($errors.Count -gt 0) {
        Write-Host "⚠️  FIX ERRORS BEFORE PRESENTATION!" -ForegroundColor Red
    } else {
        Write-Host "✅ No critical errors, but review warnings" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "DEMO CHECKLIST" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Before presentation, verify you can:" -ForegroundColor White
Write-Host "  [ ] Register user with validation errors" -ForegroundColor Gray
Write-Host "  [ ] Register Alice successfully" -ForegroundColor Gray
Write-Host "  [ ] Login with wrong password (show safe error)" -ForegroundColor Gray
Write-Host "  [ ] Login successfully" -ForegroundColor Gray
Write-Host "  [ ] See JSESSIONID cookie in DevTools" -ForegroundColor Gray
Write-Host "  [ ] Access denied when logged out" -ForegroundColor Gray
Write-Host "  [ ] Alice creates note" -ForegroundColor Gray
Write-Host "  [ ] Bob cannot see Alice's note (CRITICAL!)" -ForegroundColor Gray
Write-Host "  [ ] Show security headers in DevTools" -ForegroundColor Gray
Write-Host "  [ ] Show cookie attributes in DevTools" -ForegroundColor Gray
Write-Host "  [ ] Show validation code (UserDTO, PasswordValidator)" -ForegroundColor Gray
Write-Host "  [ ] Show logs (no passwords/tokens)" -ForegroundColor Gray
Write-Host "  [ ] Run tests successfully" -ForegroundColor Gray
Write-Host ""
Write-Host "Good luck! 🍀" -ForegroundColor Cyan
