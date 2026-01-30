# ✅ PRESENTATION DAY CHECKLIST

## 🕐 30 MINUTES BEFORE

- [ ] Read `QUICK_REFERENCE.md` one more time
- [ ] Close all unnecessary applications
- [ ] Clear browser cache and cookies
- [ ] Prepare two terminals (one for app, one for tests)
- [ ] Have code editor ready with files open

---

## 🕑 15 MINUTES BEFORE

### Start Application
```powershell
cd d:\Shared\Downloads\product
./mvnw.cmd spring-boot:run
```
- [ ] Wait for "Started Lab10Application"
- [ ] No errors in console

### Verify Application
```powershell
./verify_presentation.ps1
```
- [ ] All checks pass
- [ ] No critical errors

---

## 🕒 10 MINUTES BEFORE

### Browser Setup
- [ ] Open browser in **incognito mode**
- [ ] Navigate to `https://localhost:8443`
- [ ] Accept certificate warning
- [ ] Press **F12** to open DevTools
- [ ] Select **Network** tab

### Code Editor Setup
Open these files in tabs:
- [ ] `SecurityConfig.java`
- [ ] `NoteService.java`
- [ ] `UserDTO.java`
- [ ] `PasswordValidator.java`
- [ ] `AuthenticationEvents.java`
- [ ] `NoteRepository.java`
- [ ] `application.properties`
- [ ] `pom.xml`

---

## 🕓 5 MINUTES BEFORE

### Quick Test Run
- [ ] Go to `/register`
- [ ] Try invalid: `bad-email` / `123` → See errors ✅
- [ ] Register: `alice@demo.com` / `Password123!` ✅
- [ ] Login as Alice ✅
- [ ] Create note "Test" ✅
- [ ] Logout ✅
- [ ] Try `/dashboard` → Redirected ✅

### DevTools Check
- [ ] F12 → Network → Refresh
- [ ] See security headers ✅
- [ ] F12 → Application → Cookies
- [ ] See JSESSIONID with HttpOnly/Secure ✅

---

## 🎬 DURING PRESENTATION (10 MINUTES)

### ⏱️ Minutes 0-2: Authentication (15 pts)

#### Registration Validation
- [ ] Go to `/register`
- [ ] Enter: `bad-email` / `123`
- [ ] Click Register → **SHOW ERRORS**

#### Successful Registration
- [ ] Enter: `alice@demo.com` / `Password123!`
- [ ] Register → **REDIRECTED TO LOGIN**

#### Failed Login
- [ ] Login: `alice@demo.com` / `WrongPassword`
- [ ] **SHOW:** "Invalid username or password"

#### Successful Login
- [ ] Login: `alice@demo.com` / `Password123!`
- [ ] **REDIRECTED TO DASHBOARD**

#### Proof of Authentication
- [ ] F12 → Application → Cookies
- [ ] **SHOW JSESSIONID:**
  - [ ] HttpOnly ✅
  - [ ] Secure ✅
  - [ ] SameSite=Strict ✅

#### Show Code
- [ ] Open `SecurityConfig.java` line 114
- [ ] **POINT TO:** `BCryptPasswordEncoder(10)`

---

### ⏱️ Minutes 2-5: Authorization & Data Isolation (20 pts) ⭐

#### Protected Routes
- [ ] **LOGOUT**
- [ ] Try to access `/dashboard`
- [ ] **SHOW:** Redirected to login ✅

#### Data Isolation - THE MONEY SHOT
- [ ] Login as **Alice**
- [ ] Create note: "Confidential Strategy" / "Top Secret"
- [ ] **VERIFY NOTE APPEARS**
- [ ] **LOGOUT**
- [ ] Register **Bob**: `bob@demo.com` / `Password123!`
- [ ] Login as **Bob**
- [ ] **🎯 SHOW DASHBOARD IS EMPTY** ← **CRITICAL!**
- [ ] Bob creates: "Bob's Diary"
- [ ] **LOGOUT**
- [ ] Login as **Alice**
- [ ] **SHOW ONLY "Confidential Strategy"**

#### Show Code
- [ ] Open `NoteService.java` line 46
- [ ] **POINT TO:** `findByUserId(user.getId())`
- [ ] **EXPLAIN:** "Service layer enforces user_id from security context"

---

### ⏱️ Minutes 5-7: Security Headers (8 pts)

#### DevTools Demo
- [ ] **F12 → Network Tab**
- [ ] **Refresh (F5)**
- [ ] Click first request (e.g., `dashboard`)
- [ ] **SHOW RESPONSE HEADERS:**
  - [ ] `X-Content-Type-Options: nosniff` ✅
  - [ ] `X-Frame-Options: SAMEORIGIN` ✅
  - [ ] `Content-Security-Policy: ...` ✅
  - [ ] `Referrer-Policy: strict-origin-when-cross-origin` ✅
  - [ ] `Strict-Transport-Security: max-age=31536000` ✅

#### Show Cookies
- [ ] **Application → Cookies → JSESSIONID**
- [ ] **VERIFY:**
  - [ ] HttpOnly ✅
  - [ ] Secure ✅
  - [ ] SameSite=Strict ✅

---

### ⏱️ Minutes 7-8: Validation & Logging (15 pts)

#### Input Validation
- [ ] Open `UserDTO.java` lines 11-22
- [ ] **SHOW:**
  - [ ] `@NotBlank`
  - [ ] `@Email`
  - [ ] `@Size(min = 8)`
  - [ ] `@PasswordConstraint` ← **CUSTOM**

- [ ] Open `PasswordValidator.java` line 18
- [ ] **EXPLAIN:** "Regex validates digit, lowercase, uppercase, special char"

#### Secure Logging
- [ ] **SHOW TERMINAL** with app running
- [ ] Scroll to failed login attempt
- [ ] **POINT TO:** `WARN: Failed login attempt for user: a***@***`
- [ ] **SAY:** "Passwords and tokens are NOT logged"

- [ ] Open `AuthenticationEvents.java` line 19
- [ ] **SHOW:** `LoggingUtils.maskEmail()`

---

### ⏱️ Minutes 8-9: Testing (Core Requirement)

#### Run Tests
- [ ] Open **NEW TERMINAL**
- [ ] Run: `./mvnw.cmd test`
- [ ] **WAIT ~8 seconds**
- [ ] **SHOW OUTPUT:**
  - [ ] `Tests run: 3, Failures: 0, Errors: 0`
  - [ ] `BUILD SUCCESS`

- [ ] **SAY:** "We have security tests for protected endpoints and validation"

---

### ⏱️ Minutes 9-10: Bonus Features (+15 pts)

#### HTTPS + HSTS (+5 pts)
- [ ] **SHOW BROWSER:** URL is `https://localhost:8443`
- [ ] **SHOW DEVTOOLS:** `Strict-Transport-Security` header
- [ ] Open `application.properties` lines 31-37
- [ ] **SHOW:** SSL configuration

#### Rate Limiting (+3 pts)
- [ ] Open `RateLimitFilter.java` line 21
- [ ] **SHOW:** `MAX_REQUESTS_PER_MINUTE = 50`
- [ ] **SAY:** "Returns HTTP 429 after 50 requests/min per IP"

#### GitHub Actions (+3 pts)
- [ ] Open `.github/workflows/maven.yml`
- [ ] **SAY:** "CI pipeline runs tests on every push"

#### OWASP Check (+4 pts)
- [ ] Open `pom.xml` lines 104-112
- [ ] **SAY:** "OWASP Dependency Check configured for vulnerability scanning"

---

### ⏱️ Minute 10: Closing

- [ ] **SAY:** "This application demonstrates all required security features including authentication, authorization with data isolation, comprehensive security headers, input validation, secure logging, and automated testing. Thank you."

---

## 🎯 CRITICAL SUCCESS FACTORS

### Must Show Live
- ✅ Registration with validation errors
- ✅ Login (failed + successful)
- ✅ Cookie in DevTools
- ✅ Data isolation (Bob can't see Alice's notes)
- ✅ All 5 security headers in DevTools
- ✅ Cookie attributes (HttpOnly, Secure, SameSite)
- ✅ Tests running and passing
- ✅ Logs without passwords/tokens

### Must Explain in Code
- ✅ Password hashing: `SecurityConfig.java` line 114
- ✅ Data isolation: `NoteService.java` line 46
- ✅ Custom validation: `PasswordValidator.java` line 18
- ✅ Secure logging: `AuthenticationEvents.java` line 19
- ✅ Prepared statements: `NoteRepository.java` line 31

### Must NOT Happen
- ❌ App crashes
- ❌ Bob sees Alice's data
- ❌ Headers not visible
- ❌ Tests fail
- ❌ Passwords in logs

---

## ⚠️ AUTOMATIC FAIL CONDITIONS

- ❌ Application doesn't start
- ❌ Passwords stored in plain text
- ❌ User B can access User A's data

---

## 🎯 EXPECTED SCORE: 90/90

**Core Points:** 75/75
- Application Readiness: 5
- Authentication: 15
- Authorization: 20
- Input Validation: 10
- Security Headers: 8
- Session Management: 7
- Database Security: 5
- Secure Logging: 5

**Bonus Points:** 15/15
- HTTPS + HSTS: 5
- Rate Limiting: 3
- GitHub Actions: 3
- OWASP Check: 4

---

## 🆘 EMERGENCY CONTACTS

### If App Crashes
```powershell
Ctrl + C
./mvnw.cmd spring-boot:run
```

### If Tests Fail
```powershell
./mvnw.cmd clean test
```

### If Browser Issues
- Close and reopen incognito
- Clear cookies
- Try different browser

---

## 📝 PROFESSOR QUESTIONS - QUICK ANSWERS

**Q: Where is password hashing?**
A: `SecurityConfig.java` line 114 - `BCryptPasswordEncoder(10)`

**Q: How do you prevent User B from accessing User A's data?**
A: `NoteService.java` line 46 - `findByUserId(user.getId())` from security context

**Q: How do you prevent SQL injection?**
A: `NoteRepository.java` line 31 - JdbcTemplate with prepared statements (`?` placeholders)

**Q: What security headers do you implement?**
A: 5 headers in `SecurityConfig.java` lines 76-87: X-Content-Type-Options, X-Frame-Options, CSP, Referrer-Policy, HSTS

**Q: How do you ensure passwords aren't logged?**
A: `AuthenticationEvents.java` line 19 - `LoggingUtils.maskEmail()` masks sensitive data

---

## ✅ FINAL CONFIDENCE CHECK

**I am ready if I can answer YES to all:**

- [ ] App starts without errors
- [ ] Tests pass in under 15 seconds
- [ ] I can register and login
- [ ] I can demonstrate data isolation
- [ ] I can show all security headers
- [ ] I can show cookie attributes
- [ ] I can explain password hashing
- [ ] I can explain data isolation logic
- [ ] I know where each feature is in code
- [ ] I can complete demo in under 10 minutes

**If all YES → GO GET THAT 90/90! 🎯🚀**

---
