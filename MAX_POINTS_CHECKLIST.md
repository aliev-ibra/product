# 🎯 MAXIMUM POINTS CHECKLIST (90/90)

## ✅ PRE-PRESENTATION SETUP (DO THIS FIRST!)

### 1. Start the Application
```powershell
./mvnw.cmd spring-boot:run
```
**Wait for:** `Started Lab10Application` message

### 2. Open Browser (Incognito Mode)
- URL: `https://localhost:8443`
- **Accept the self-signed certificate warning**
- Open DevTools (F12) → **Network Tab**

### 3. Have Code Editor Ready
Open these files in tabs:
- `SecurityConfig.java`
- `NoteService.java`
- `UserDTO.java`
- `AuthenticationEvents.java`
- `PasswordValidator.java`

### 4. Have Terminal Ready
- One terminal running the app
- One terminal ready for test commands

---

## 📊 POINT-BY-POINT VERIFICATION

### ✅ 1. Application Readiness (5 pts)

| Requirement | Status | How to Verify |
|------------|--------|---------------|
| App starts without errors | ✅ | App is running on port 8443 |
| Can restart quickly | ✅ | Use `./mvnw.cmd spring-boot:run` |
| Demo is live | ⚠️ | **YOU MUST DO LIVE - NO SCREENSHOTS** |
| Complete within 10 min | ⚠️ | **PRACTICE YOUR FLOW** |

**⚠️ CRITICAL:** If app fails to run → **AUTOMATIC FAIL**

---

### ✅ 2. Authentication – Registration and Login (15 pts)

#### Registration (7.5 pts)

| Requirement | Status | Demo Steps |
|------------|--------|------------|
| Register new user live | ✅ | Go to `/register`, create user `alice@demo.com` / `Password123!` |
| Show validation errors | ✅ | Try: `bad-email` / `123` → See error messages |
| Passwords hashed (BCrypt) | ✅ | Show `SecurityConfig.java` line 114: `BCryptPasswordEncoder(10)` |
| Explain hashing location | ✅ | Point to `passwordEncoder()` bean in `SecurityConfig.java` |

**⚠️ CRITICAL:** Plain-text passwords → **0 for entire section**

#### Login (7.5 pts)

| Requirement | Status | Demo Steps |
|------------|--------|------------|
| Show failed login | ✅ | Login with wrong password → See "Invalid username or password" |
| Show successful login | ✅ | Login with correct credentials → Redirected to dashboard |
| Proof of authentication | ✅ | **DevTools → Application → Cookies → Show `JSESSIONID`** |
| Safe error messages | ✅ | Failed login shows generic message (no details leaked) |

**🎯 DEMO SCRIPT:**
1. Go to `/register`
2. Try invalid: `bad-email` / `123` → **SHOW ERRORS**
3. Register: `alice@demo.com` / `Password123!` → **SUCCESS**
4. Login wrong password → **SHOW SAFE ERROR**
5. Login correct → **SHOW COOKIE IN DEVTOOLS**

---

### ✅ 3. Authorization and Access Control (20 pts)

#### Protected Routes (10 pts)

| Requirement | Status | Demo Steps |
|------------|--------|------------|
| Access without login denied | ✅ | Logout, try `/dashboard` → Redirected to login |
| Access with wrong role denied | ✅ | (If you have roles, demo this) |
| Access with correct role allowed | ✅ | Login → Access `/dashboard` successfully |
| Know which class enforces | ✅ | `SecurityConfig.java` line 73-75 |

#### User Data Isolation (10 pts) **MOST CRITICAL**

| Requirement | Status | Demo Steps |
|------------|--------|------------|
| User A can create data | ✅ | Alice creates note "Secret A" |
| User B cannot see A's data | ✅ | Bob logs in → Dashboard is EMPTY |
| User B cannot modify A's data | ✅ | Bob cannot access Alice's note ID |
| User B cannot delete A's data | ✅ | Bob cannot delete Alice's notes |
| Explain user_id enforcement | ✅ | Show `NoteService.java` line 46: `findByUserId(user.getId())` |

**⚠️ CRITICAL:** If User B can access User A's data → **0 for entire section**

**🎯 DEMO SCRIPT:**
1. **Logout** (if logged in)
2. Try to access `/dashboard` → **REDIRECTED TO LOGIN**
3. Login as **Alice** (`alice@demo.com` / `Password123!`)
4. Create note: "Confidential Strategy" / "Top Secret Data"
5. **Verify note appears**
6. **LOGOUT**
7. Register **Bob** (`bob@demo.com` / `Password123!`)
8. Login as **Bob**
9. **SHOW DASHBOARD IS EMPTY** ← **THIS IS THE MONEY SHOT**
10. Bob creates note: "Bob's Diary"
11. **LOGOUT**
12. Login as Alice → **SHOW ONLY "Confidential Strategy"**
13. **OPEN CODE:** `NoteService.java` line 44-46 → **EXPLAIN `findByUserId()`**

---

### ✅ 4. Input Validation and Error Handling (10 pts)

| Requirement | Status | Demo Steps |
|------------|--------|------------|
| DTO validation annotations | ✅ | Show `UserDTO.java` lines 11-22 |
| Custom validation rule | ✅ | Show `@PasswordConstraint` + `PasswordValidator.java` |
| Invalid input → HTTP 400 | ✅ | Try registration with invalid data |
| Error responses structured | ✅ | Show `GlobalExceptionHandler.java` |
| No stack traces | ✅ | Verify error responses are clean |

**🎯 DEMO SCRIPT:**
1. Go to `/register`
2. Enter: `a` / `a@a` / `123` → **SHOW VALIDATION ERRORS**
3. **OPEN CODE:** `UserDTO.java` → **SHOW `@NotBlank`, `@Email`, `@Size`, `@PasswordConstraint`**
4. **OPEN CODE:** `PasswordValidator.java` line 18 → **EXPLAIN REGEX VALIDATION**

---

### ✅ 5. HTTP and Browser Security Headers (8 pts)

| Requirement | Status | How to Verify |
|------------|--------|---------------|
| Open DevTools Network | ✅ | Press F12 → Network tab |
| X-Content-Type-Options | ✅ | Look for `nosniff` |
| X-Frame-Options | ✅ | Look for `SAMEORIGIN` |
| Content-Security-Policy | ✅ | Look for CSP header |
| Referrer-Policy | ✅ | Look for `strict-origin-when-cross-origin` |
| HttpOnly cookie | ✅ | Application → Cookies → `JSESSIONID` has HttpOnly |
| Secure cookie | ✅ | Application → Cookies → `JSESSIONID` has Secure |
| SameSite cookie | ✅ | Application → Cookies → `JSESSIONID` has SameSite=Strict |

**⚠️ CRITICAL:** Not shown live → **0 for this section**

**🎯 DEMO SCRIPT:**
1. **F12** → **Network Tab**
2. Refresh page (F5)
3. Click first request (e.g., `dashboard`)
4. **Scroll to Response Headers** → **SHOW:**
   - `X-Content-Type-Options: nosniff`
   - `X-Frame-Options: SAMEORIGIN`
   - `Content-Security-Policy: default-src 'self'...`
   - `Referrer-Policy: strict-origin-when-cross-origin`
   - `Strict-Transport-Security: max-age=...` (BONUS!)
5. **Application Tab** → **Cookies** → **SHOW `JSESSIONID`:**
   - ✅ HttpOnly
   - ✅ Secure
   - ✅ SameSite=Strict

---

### ✅ 6. Session/Token Management (7 pts)

#### MVC (Session-based) - 3.5 pts

| Requirement | Status | Demo Steps |
|------------|--------|------------|
| Logout works | ✅ | Click logout → Redirected to login |
| Refresh after logout keeps logged out | ✅ | After logout, refresh → Still logged out |

#### REST (JWT-based) - 3.5 pts

| Requirement | Status | Demo Steps |
|------------|--------|------------|
| Access token expiration works | ✅ | JWT configured in `JwtUtils.java` |
| Refresh token rotation works | ✅ | `AuthRestController.refreshtoken()` implements rotation |
| Old refresh tokens don't work | ✅ | After refresh, old token is invalidated |

**🎯 DEMO SCRIPT (MVC):**
1. Login as Alice
2. **Click Logout**
3. **Verify redirected to `/login?logout`**
4. **Refresh page (F5)** → **Still at login page**
5. Try to access `/dashboard` → **Redirected to login**

**🎯 DEMO SCRIPT (REST - Optional):**
1. Use Postman/curl to get JWT
2. Show token expiration
3. Use refresh token endpoint
4. Show old refresh token fails

---

### ✅ 7. Database and Persistence Security (5 pts)

| Requirement | Status | Demo Steps |
|------------|--------|------------|
| Entity has user_id FK | ✅ | Show `Note.java` entity with `userId` field |
| Safe queries exist | ✅ | Show `NoteRepository.findByUserId()` uses Spring Data JPA |

**🎯 DEMO SCRIPT:**
1. **OPEN CODE:** `Note.java` → **SHOW `userId` field**
2. **OPEN CODE:** `NoteService.java` line 46 → **EXPLAIN:**
   - "We use Spring Data JPA which generates prepared statements"
   - "Query filters by `user.getId()` from security context"
   - "This prevents SQL injection and enforces data isolation"

---

### ✅ 8. Secure Logging (5 pts)

| Requirement | Status | Demo Steps |
|------------|--------|------------|
| Failed login logged | ✅ | Check terminal for failed login attempts |
| Unauthorized access logged | ✅ | Check terminal for 403 attempts |
| Passwords NOT logged | ✅ | Verify logs don't show passwords |
| JWTs NOT logged | ✅ | Verify logs don't show tokens |
| Logs visible during demo | ✅ | Show terminal with logs |

**⚠️ CRITICAL:** Passwords or tokens logged → **0 for this section**

**🎯 DEMO SCRIPT:**
1. **SHOW TERMINAL** with app running
2. Scroll to where you failed login earlier
3. **POINT TO:** `WARN: Failed login attempt for user: a***@***`
4. **POINT TO:** `WARN: Unauthorized access attempt`
5. **SAY:** "Notice passwords and tokens are NOT visible - we use `LoggingUtils.maskEmail()`"
6. **OPEN CODE:** `AuthenticationEvents.java` → **SHOW logging implementation**

---

### ✅ 9. Testing (Core Requirement)

| Requirement | Status | Demo Steps |
|------------|--------|------------|
| Unit tests run successfully | ✅ | Run `./mvnw.cmd test` |
| Security unit test exists | ✅ | `SecurityTest.java` exists |
| Integration test exists | ✅ | `SecurityTest.java` is integration test |
| Can run tests quickly | ✅ | Takes ~8 seconds |

**🎯 DEMO SCRIPT:**
1. **OPEN NEW TERMINAL**
2. Run: `./mvnw.cmd test`
3. **WAIT ~8 seconds**
4. **SHOW OUTPUT:**
   - `Tests run: 3, Failures: 0, Errors: 0`
   - `BUILD SUCCESS`
5. **SAY:** "We have security tests including protected endpoint access control"

---

## 🌟 BONUS FEATURES (+15 pts)

### Rate Limiting (+3 pts)

| Requirement | Status | Demo Steps |
|------------|--------|------------|
| Rate limiting implemented | ✅ | `RateLimitFilter.java` exists |
| Demonstrable | ✅ | Show code or test with multiple requests |

**🎯 DEMO:**
- **OPEN CODE:** `RateLimitFilter.java` line 21 → **SHOW `MAX_REQUESTS_PER_MINUTE = 50`**
- **SAY:** "We have a rate limiter that returns HTTP 429 after 50 requests per minute per IP"

### HTTPS (+5 pts)

| Requirement | Status | Demo Steps |
|------------|--------|------------|
| HTTPS enabled | ✅ | Running on `https://localhost:8443` |
| HTTP → HTTPS redirect | ⚠️ | Need to verify |
| HSTS header present | ✅ | Check in DevTools Network headers |

**🎯 DEMO:**
- **SHOW BROWSER:** URL is `https://localhost:8443`
- **SHOW DEVTOOLS:** `Strict-Transport-Security` header
- **OPEN CODE:** `application.properties` lines 31-37 → **SHOW SSL config**

### GitHub Actions CI (+3 pts)

| Requirement | Status | Demo Steps |
|------------|--------|------------|
| CI pipeline runs tests | ✅ | `.github/workflows/maven.yml` exists |

**🎯 DEMO:**
- **OPEN CODE:** `.github/workflows/maven.yml`
- **SAY:** "We have GitHub Actions that run tests on every push"

### OWASP Dependency Check (+4 pts)

| Requirement | Status | Demo Steps |
|------------|--------|------------|
| OWASP check configured | ✅ | Plugin in `pom.xml` lines 104-112 |

**🎯 DEMO:**
- **OPEN CODE:** `pom.xml` lines 104-112
- **SAY:** "We have OWASP Dependency Check configured"
- **OPTIONAL:** Run `./mvnw.cmd dependency-check:check` (takes time)

---

## 🎬 FINAL PRESENTATION FLOW (10 MINUTES)

### Minute 0-1: Introduction
"This is a secure Spring Boot application with session-based authentication for the web interface and JWT for the REST API. It demonstrates all required security features."

### Minute 1-3: Authentication
1. Show registration validation (invalid → errors)
2. Register Alice
3. Show failed login (safe error)
4. Show successful login
5. **SHOW COOKIE IN DEVTOOLS**
6. Show password hashing in code

### Minute 3-6: Authorization & Data Isolation ⭐ MOST IMPORTANT
1. Logout → Try `/dashboard` → Denied
2. Login as Alice → Create "Secret" note
3. Logout
4. Register/Login as Bob → **SHOW EMPTY DASHBOARD**
5. Bob creates his note
6. Logout → Login as Alice → **SHOW ONLY HER NOTE**
7. **SHOW CODE:** `NoteService.findByUserId()`

### Minute 6-7: Security Headers
1. **F12 → Network → Refresh**
2. **SHOW ALL HEADERS** (X-Frame-Options, CSP, etc.)
3. **SHOW COOKIES** (HttpOnly, Secure, SameSite)

### Minute 7-8: Validation & Logging
1. Show `UserDTO` validation annotations
2. Show `PasswordValidator` custom validation
3. Show terminal logs (failed login, no passwords)

### Minute 8-9: Testing
1. Run `./mvnw.cmd test`
2. Show BUILD SUCCESS

### Minute 9-10: Bonus Features
1. Mention HTTPS (show URL)
2. Show HSTS header
3. Mention rate limiting (show code)
4. Mention CI pipeline
5. Mention OWASP check

### Closing
"The application meets all core security requirements with proper authentication, authorization, data isolation, secure headers, and automated testing. Thank you."

---

## ⚠️ CRITICAL REMINDERS

### AUTOMATIC FAIL CONDITIONS
- ❌ App doesn't start
- ❌ Passwords stored in plain text
- ❌ User B can access User A's data

### ZERO POINTS FOR SECTION
- ❌ Plain-text passwords → 0 for Authentication (15 pts)
- ❌ User B sees User A's data → 0 for Authorization (20 pts)
- ❌ Passwords/tokens in logs → 0 for Logging (5 pts)
- ❌ Headers not shown live → 0 for Headers (8 pts)

### MUST BE LIVE
- ✅ No screenshots
- ✅ No recordings
- ✅ Everything must be demonstrated in real-time

---

## 📋 FINAL PRE-FLIGHT CHECK

Before presentation, verify:

- [ ] App starts without errors
- [ ] Browser is in incognito mode
- [ ] DevTools is open to Network tab
- [ ] Code editor has all files open
- [ ] Terminal is ready
- [ ] You can create Alice user
- [ ] You can create Bob user
- [ ] Alice's notes are NOT visible to Bob
- [ ] Security headers appear in DevTools
- [ ] Cookies have HttpOnly/Secure/SameSite
- [ ] Tests pass (`./mvnw.cmd test`)
- [ ] You've practiced the flow (under 10 minutes)

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
- Testing: (Core requirement)

**Bonus Points:** 15/15
- Rate Limiting: 3
- HTTPS + HSTS: 5
- GitHub Actions: 3
- OWASP Check: 4

**TOTAL: 90/90** ✅
