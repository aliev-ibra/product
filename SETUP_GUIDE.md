# Spring Boot LAB-15 Setup Guide

## ✅ Completed Steps

1. ✅ **Maven Wrapper Added** - You can now use `.\mvnw.cmd` instead of `mvn`
2. ✅ **SSL Keystore Exists** - `src/main/resources/keystore.p12` is present
3. ✅ **Data Directory Created** - `./data` folder is ready for H2 database
4. ✅ **Project Structure Verified** - All files are in place

---

## ⚠️ Critical Issue: Java Version

**Current Java Version:** Java 8 (1.8.0_482)  
**Required Version:** Java 17 or 21 (your project uses Spring Boot 3.4.2 which requires Java 17+)

### Why This Matters
Spring Boot 3.x requires **minimum Java 17**. Your project will **NOT run** with Java 8.

---

## 🔧 Next Steps

### Step 1: Install Java 17 or 21

Choose one of these options:

#### Option A: Amazon Corretto 21 (Recommended - you already have Corretto 8)
```powershell
# Download and install from:
# https://corretto.aws/downloads/latest/amazon-corretto-21-x64-windows-jdk.msi
```

#### Option B: Eclipse Temurin 21
```powershell
# Download and install from:
# https://adoptium.net/temurin/releases/?version=21
```

#### Option C: Using Chocolatey (if installed)
```powershell
choco install corretto21jdk
```

### Step 2: Set JAVA_HOME Environment Variable

After installing Java 21, set the `JAVA_HOME` environment variable:

```powershell
# Example (adjust path based on your installation):
[System.Environment]::SetEnvironmentVariable('JAVA_HOME', 'C:\Program Files\Amazon Corretto\jdk21.0.x_xx', 'Machine')

# Or for Eclipse Temurin:
[System.Environment]::SetEnvironmentVariable('JAVA_HOME', 'C:\Program Files\Eclipse Adoptium\jdk-21.0.x.x-hotspot', 'Machine')
```

**Important:** After setting JAVA_HOME, **restart your terminal** or VS Code.

### Step 3: Verify Java Installation

```powershell
java -version
# Should show: openjdk version "21.x.x" or similar
```

---

## 🚀 Running the Application

Once Java 17/21 is installed and configured:

### 1. Clean and Build
```powershell
.\mvnw.cmd clean install -DskipTests
```

### 2. Run the Application
```powershell
.\mvnw.cmd spring-boot:run
```

### 3. Verify the Application

The application should start on **HTTPS port 8443**. Look for these log messages:

```
✅ Flyway Migrations: Successfully applied 4 migrations...
✅ Tomcat started on port 8443 (https)
```

### 4. Run Verification Script

After the application starts successfully:

```powershell
powershell -ExecutionPolicy Bypass -File .\verify_lab.ps1
```

---

## 📝 Application Configuration

- **HTTPS Port:** 8443
- **Database:** H2 (file-based at `./data/snippetdb`)
- **H2 Console:** https://localhost:8443/h2-console
- **Keystore Password:** password123
- **Database Username:** sa
- **Database Password:** (empty)

---

## 🔍 Troubleshooting

### Issue: "UnsupportedClassVersionError"
**Cause:** Java version is too old  
**Solution:** Install Java 17 or 21 as described above

### Issue: "Could not find keystore.p12"
**Cause:** SSL certificate missing  
**Solution:** Already exists at `src/main/resources/keystore.p12` ✅

### Issue: "Failed to configure a DataSource"
**Cause:** Database directory missing  
**Solution:** Already created at `./data` ✅

### Issue: Maven Wrapper not working
**Cause:** Execution policy or permissions  
**Solution:** Run PowerShell as Administrator or use:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 📚 Useful Commands

```powershell
# Check Java version
java -version

# Check Maven version (via wrapper)
.\mvnw.cmd -version

# Clean build
.\mvnw.cmd clean

# Install dependencies
.\mvnw.cmd install -DskipTests

# Run application
.\mvnw.cmd spring-boot:run

# Run with debug logging
.\mvnw.cmd spring-boot:run -Dspring-boot.run.arguments=--logging.level.root=DEBUG

# Package as JAR
.\mvnw.cmd package -DskipTests
```

---

## 🎯 Quick Start (After Java 17/21 Installation)

```powershell
# 1. Navigate to project directory
cd "c:\Users\aliye\.gemini\antigravity\scratch\LAB-15\Lab10Application"

# 2. Build the project
.\mvnw.cmd clean install -DskipTests

# 3. Run the application
.\mvnw.cmd spring-boot:run

# 4. In another terminal, verify
.\verify_lab.ps1
```

---

## 📞 Need Help?

- Check `README.md` for project documentation
- Review `SECURITY_NOTES.md` for security configuration details
- See `API_DOCS.md` for API endpoint documentation
- Read `HTTPS_DEMO.md` for HTTPS setup details
