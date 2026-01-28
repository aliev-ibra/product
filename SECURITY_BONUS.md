# Security Bonus Requirements

## 🛡️ 1. OWASP Dependency Check
This tool scans all libraries (JARs) used in the project and compares them against the National Vulnerability Database (NVD).

**How it prevents vulnerabilities:**
- It directly addresses **OWASP Top 10 - A06:2021 (Vulnerable and Outdated Components)**.
- Many breaches occur not because of custom code errors, but because of using a library with a known security flaw (e.g., Log4Shell).
- By running this check during the build, we prevent vulnerable code from ever reaching production.

### ✅ Command to Generate Report
To run the check and generate the `dependency-check-report.html` file in your `target` folder, run:

```powershell
.\mvnw.cmd verify -DskipTests
```
*(Using `-DskipTests` speeds it up if you just want the report, but `.\mvnw.cmd verify` is the standard full command).*

---

## 🤖 2. GitHub Actions CI Pipeline
We have configured a pipeline in `.github/workflows/maven.yml`.

**How it ensures Application Readiness:**
- **Automated Verification:** Every time you push code or open a Pull Request, GitHub automatically boots up a server (Ubuntu), installs Java 21, and runs your tests.
- **Fail Fast:** If any security test (like `SecurityTest.java`) fails, the build fails. This prevents broken or insecure code from being merged.
- **Consistency:** It eliminates "it works on my machine" issues by testing in a clean, isolated environment.

---

## 🎯 Verification for Teacher
1. **Show `pom.xml`**: Point out the `dependency-check-maven` plugin.
2. **Show Report**: Run the command above, then open `target/dependency-check-report.html` in a browser.
3. **Show Pipeline**: Open the `.github/workflows/maven.yml` file.
