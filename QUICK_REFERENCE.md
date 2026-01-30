# 🎯 QUICK REFERENCE CARD - PRESENTATION CHEAT SHEET

## 🚀 BEFORE YOU START

### 1. Start App
```powershell
./mvnw.cmd spring-boot:run
```
Wait for: `Started Lab10Application`

### 2. Open Browser
- **Incognito mode**: `https://localhost:8443`
- **F12** → Network Tab
- Accept certificate warning

### 3. Have Ready
- Terminal with app running
- Second terminal for tests
- Code editor with files open

---

## 📝 DEMO CREDENTIALS

### User A (Alice)
- Email: `alice@demo.com`
- Password: `Password123!`

### User B (Bob)
- Email: `bob@demo.com`
- Password: `Password123!`

### Invalid Test Data
- Email: `bad-email`
- Password: `123`

---

## 🎬 10-MINUTE DEMO FLOW

### 1️⃣ AUTHENTICATION (2 min) - 15 pts

**Registration Validation:**
1. Go to `/register`
2. Enter: `bad-email` / `123`
3. Click Register → **SHOW ERRORS**

**Successful Registration:**
1. Enter: `alice@demo.com` / `Password123!`
2. Register → **REDIRECTED TO LOGIN**

**Failed Login:**
1. Login: `alice@demo.com` / `WrongPassword`
2. **SHOW SAFE ERROR:** "Invalid username or password"

**Successful Login:**
1. Login: `alice@demo.com` / `Password123!`
2. **REDIRECTED TO DASHBOARD**

**Proof of Authentication:**
1. **F12 → Application → Cookies**
2. **SHOW `JSESSIONID`:**
   - ✅ HttpOnly
   - ✅ Secure
   - ✅ SameSite=Strict

**Show Code:**
- `SecurityConfig.java` line 114: `BCryptPasswordEncoder(10)`

---

### 2️⃣ AUTHORIZATION & DATA ISOLATION (3 min) - 20 pts ⭐ CRITICAL

**Protected Routes:**
1. **Logout**
2. Try to access `/dashboard`
3. **REDIRECTED TO LOGIN** ✅

**Data Isolation (THE MONEY SHOT):**
1. Login as **Alice**
2. Create note: "Confidential Strategy" / "Top Secret"
3. **VERIFY NOTE APPEARS**
4. **LOGOUT**
5. Register **Bob**: `bob@demo.com` / `Password123!`
6. Login as **Bob**
7. **🎯 SHOW DASHBOARD IS EMPTY** ← **CRITICAL**
8. Bob creates: "Bob's Diary"
9. **LOGOUT**
10. Login as **Alice**
11. **SHOW ONLY "Confidential Strategy"**

**Show Code:**
- `NoteService.java` line 46: `findByUserId(user.getId())`
- **EXPLAIN:** "Service layer enforces user_id from security context"

---

### 3️⃣ SECURITY HEADERS (2 min) - 8 pts

**DevTools Demo:**
1. **F12 → Network Tab**
2. **Refresh (F5)**
3. Click first request (e.g., `dashboard`)
4. **SHOW RESPONSE HEADERS:**
   - `X-Content-Type-Options: nosniff` ✅
   - `X-Frame-Options: SAMEORIGIN` ✅
   - `Content-Security-Policy: default-src 'self'...` ✅
   - `Referrer-Policy: strict-origin-when-cross-origin` ✅
   - `Strict-Transport-Security: max-age=31536000` ✅ (BONUS!)

**Show Cookies:**
1. **Application → Cookies → `JSESSIONID`**
2. **VERIFY:**
   - HttpOnly ✅
   - Secure ✅
   - SameSite=Strict ✅

---

### 4️⃣ INPUT VALIDATION (1 min) - 10 pts

**Show Code:**
1. `UserDTO.java` lines 11-22:
   - `@NotBlank`
   - `@Email`
   - `@Size(min = 8)`
   - `@PasswordConstraint` ← **CUSTOM VALIDATION**

2. `PasswordValidator.java` line 18:
   - **EXPLAIN:** "Regex validates: digit, lowercase, uppercase, special char"

---

### 5️⃣ SECURE LOGGING (1 min) - 5 pts

**Show Terminal:**
1. Scroll to failed login attempt
2. **POINT TO:** `WARN: Failed login attempt for user: a***@***`
3. **POINT TO:** `WARN: Unauthorized access attempt`
4. **SAY:** "Passwords and tokens are NOT logged"

**Show Code:**
- `AuthenticationEvents.java` line 19: `LoggingUtils.maskEmail()`

---

### 6️⃣ TESTING (1 min) - Core Requirement

**Run Tests:**
```powershell
./mvnw.cmd test
```

**Show Output:**
- `Tests run: 3, Failures: 0, Errors: 0`
- `BUILD SUCCESS`

**Mention:**
- `SecurityTest.java` - Tests protected endpoints
- `UserValidationTest.java` - Tests DTO validation

---

### 7️⃣ BONUS FEATURES (30 sec) - +15 pts

**HTTPS (+5 pts):**
- **SHOW BROWSER:** `https://localhost:8443`
- **SHOW HEADER:** `Strict-Transport-Security: max-age=31536000`
- **CODE:** `application.properties` lines 31-37

**Rate Limiting (+3 pts):**
- **CODE:** `RateLimitFilter.java` line 21: `MAX_REQUESTS_PER_MINUTE = 50`
- **SAY:** "Returns HTTP 429 after 50 requests/min per IP"

**GitHub Actions (+3 pts):**
- **CODE:** `.github/workflows/maven.yml`
- **SAY:** "CI pipeline runs tests on every push"

**OWASP Dependency Check (+4 pts):**
- **CODE:** `pom.xml` lines 104-112
- **SAY:** "Configured for vulnerability scanning"

---

## 🗣️ KEY TALKING POINTS

### Password Hashing
"Passwords are hashed using BCrypt with strength 10, configured in SecurityConfig.java"

### Data Isolation
"The service layer enforces user_id filtering by retrieving the current user from the security context and using prepared statements with JdbcTemplate"

### Prepared Statements
"We use Spring's JdbcTemplate which automatically creates prepared statements, preventing SQL injection"

### Security Headers
"All security headers are configured in SecurityConfig.java and applied automatically by Spring Security"

### Logging
"Security events are logged but sensitive data like passwords and tokens are masked using LoggingUtils"

---

## ⚠️ CRITICAL REMINDERS

### AUTOMATIC FAIL
- ❌ App doesn't start
- ❌ Passwords in plain text
- ❌ User B can see User A's data

### ZERO POINTS
- ❌ Not shown live (screenshots/recordings)
- ❌ Passwords/tokens in logs
- ❌ Headers not demonstrated

### MUST DEMONSTRATE LIVE
- ✅ Registration with validation
- ✅ Login (failed + successful)
- ✅ Data isolation (Alice vs Bob)
- ✅ Security headers in DevTools
- ✅ Cookies in DevTools
- ✅ Tests running
- ✅ Logs in terminal

---

## 📂 CODE FILES TO HAVE OPEN

1. `SecurityConfig.java` - Password encoder, security chains
2. `NoteService.java` - Data isolation logic
3. `UserDTO.java` - Validation annotations
4. `PasswordValidator.java` - Custom validation
5. `AuthenticationEvents.java` - Secure logging
6. `NoteRepository.java` - Prepared statements
7. `application.properties` - HTTPS config
8. `pom.xml` - OWASP plugin

---

## 🎯 EXPECTED SCORE: 90/90

**Core:** 75 pts
- Application Readiness: 5
- Authentication: 15
- Authorization: 20 ⭐
- Input Validation: 10
- Security Headers: 8
- Session Management: 7
- Database Security: 5
- Secure Logging: 5

**Bonus:** 15 pts
- HTTPS + HSTS: 5
- Rate Limiting: 3
- GitHub Actions: 3
- OWASP Check: 4

---

## 🔥 THE MONEY SHOTS

### 1. Data Isolation (Worth 20 pts)
**Bob's empty dashboard while Alice has notes**

### 2. Security Headers (Worth 8 pts)
**DevTools showing all 5 headers + cookie attributes**

### 3. Password Hashing (Worth 15 pts if missing)
**BCryptPasswordEncoder in SecurityConfig**

### 4. Tests Passing (Core requirement)
**BUILD SUCCESS with all tests green**

---

## ⏱️ TIME MANAGEMENT

- 0-2 min: Authentication
- 2-5 min: Authorization & Data Isolation ⭐
- 5-7 min: Security Headers
- 7-8 min: Validation & Logging
- 8-9 min: Testing
- 9-10 min: Bonus Features

**PRACTICE THIS FLOW MULTIPLE TIMES!**

---

## 🎤 CLOSING STATEMENT

"This application demonstrates all required security features including:
- BCrypt password hashing
- Session-based authentication with secure cookies
- Role-based authorization with strict data isolation
- Comprehensive security headers including HSTS
- Input validation with custom validators
- Secure logging without sensitive data exposure
- Prepared statements for SQL injection prevention
- Automated testing and CI/CD pipeline
- OWASP dependency scanning

Thank you."

---

## 🆘 TROUBLESHOOTING

### App won't start
```powershell
./mvnw.cmd clean install
./mvnw.cmd spring-boot:run
```

### Tests fail
```powershell
./mvnw.cmd clean test
```

### Browser certificate error
Click "Advanced" → "Proceed to localhost (unsafe)"

### Can't see cookies
Make sure you're on HTTPS, not HTTP

### Headers not showing
Make sure you're looking at Response Headers, not Request Headers

---

**GOOD LUCK! 🍀**
