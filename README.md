# Secure Notes Management Application
> **Repository:** aliev-ibra/product  
> **Score Goal:** 90/90

## 📝 Demo Script (For Professor)
Follow this script exactly to verify all security requirements.

### 1. Application Readiness & Setup
**Demonstrate:**
- Application starts cleanly.
- Database is fresh (In-Memory).

**Command:**
```powershell
./mvnw.cmd spring-boot:run
```
*(Wait for "Started Lab10Application")*

### 2. HTTPS & HSTS Verification
**Demonstrate:**
- Access **http://localhost:8080** (should fail or not exist).
- Access **https://localhost:8443**.
- Browser shows "Not Secure" (Self-signed) -> Accept Risk.
- **Bonus:** Open DevTools (F12) -> Network -> Reload. Click the request (localhost).
- Check **Response Headers**:
    - `Strict-Transport-Security: max-age=31536000 ; includeSubDomains`

### 3. Authentication & Input Validation
**Demonstrate:**
1. Go to `/register`.
2. **Invalid Input:** Try creating user with short password ("123"). Show error message.
3. **Valid Registration (User A):**
   - Email: `userA@test.com`
   - Password: `Password123!`
4. **Valid Registration (User B):**
   - Email: `userB@test.com`
   - Password: `Password123!`

### 4. User Data Isolation (Crucial)
**Demonstrate:**
1. Login as **User A**.
2. Dashboard -> Create Note: "Secret A".
3. Verify note is visible.
4. **Logout**.
5. Login as **User B**.
6. Dashboard -> **Verify it is EMPTY**. (User A's note is invisible).
7. Create Note: "Secret B".
8. Logout.

### 5. Security Headers (Hardening)
**Demonstrate:**
- Open DevTools (F12) -> Network -> Reload Dashboard.
- Click `doc` request. Check Headers:
    - `X-Content-Type-Options: nosniff`
    - `X-Frame-Options: SAMEORIGIN`
    - `Content-Security-Policy: default-src 'self' ...`
    - `Referrer-Policy: strict-origin-when-cross-origin`

### 6. Vulnerability Scan (OWASP)
**Demonstrate:**
- Stop app (Ctrl+C).
- Run:
```powershell
./mvnw.cmd dependency-check:check
```
- Open `target/dependency-check-report.html`.

### 7. Automated Testing (CI)
**Demonstrate:**
- Run:
```powershell
./mvnw.cmd test
```
- Show all tests passing (SecurityTest, UserValidationTest).

---

## 🛠️ Project Configuration

### Database
- **Type:** H2 In-Memory (`jdbc:h2:mem:testdb`)
- **Migration:** Flyway (V1..V5)

### Security
- **Algorithm:** BCrypt (Strength 10)
- **Cookies:** HttpOnly, Secure, SameSite=Strict

### Logging
- Logs located in console.
- **Check for:** `Unauthorized access attempt` (Try accessing `/api/notes` without login).

---

## 📦 Git Commands (Pushing to Main)
```bash
git init
git add .
git commit -m "Final Submission: Security Hardening Complete"
git branch -M main
git remote add origin https://github.com/aliev-ibra/product.git
git push -u origin main
```