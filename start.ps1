# Quick Start Script for LAB-15 Spring Boot Application
# This script sets up the environment and runs the application

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  LAB-15 Spring Boot Application" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Set Java 21
Write-Host "[1/3] Setting Java 21..." -ForegroundColor Yellow
$env:JAVA_HOME = "C:\Program Files\Amazon Corretto\jdk21.0.10_7"
$env:Path = "$env:JAVA_HOME\bin;" + ($env:Path -replace [regex]::Escape("C:\Program Files\Amazon Corretto\jdk1.8.0_482\bin;"), "")

# Verify Java version
Write-Host "[2/3] Verifying Java version..." -ForegroundColor Yellow
$javaVersion = java -version 2>&1 | Select-String "version"
Write-Host "  $javaVersion" -ForegroundColor Green

# Run the application
Write-Host "[3/3] Starting Spring Boot application..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Application will start on: https://localhost:8443" -ForegroundColor Green
Write-Host "H2 Console: https://localhost:8443/h2-console" -ForegroundColor Green
Write-Host ""
Write-Host "Press Ctrl+C to stop the application" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Run Spring Boot
.\mvnw.cmd spring-boot:run
