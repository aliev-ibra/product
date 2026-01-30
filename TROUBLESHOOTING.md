# 🆘 TROUBLESHOOTING GUIDE

## Common Issues and Solutions

### 🔴 CRITICAL ISSUES (Will cause automatic fail)

#### 1. Application Won't Start

**Symptoms:**
- Error messages when running `./mvnw.cmd spring-boot:run`
- Port already in use
- Database connection errors

**Solutions:**

```powershell
# Solution 1: Clean and rebuild
./mvnw.cmd clean install
./mvnw.cmd spring-boot:run

# Solution 2: Kill process on port 8443
netstat -ano | findstr :8443
taskkill /PID <PID_NUMBER> /F
./mvnw.cmd spring-boot:run

# Solution 3: Check Java version
java -version
# Should be Java 21

# Solution 4: Delete target folder
Remove-Item -Recurse -Force target
./mvnw.cmd clean install
./mvnw.cmd spring-boot:run
```

#### 2. Tests Failing

**Symptoms:**
- `./mvnw.cmd test` shows failures
- BUILD FAILURE

**Solutions:**

```powershell
# Solution 1: Clean and test
./mvnw.cmd clean test

# Solution 2: Check specific test
./mvnw.cmd test -Dtest=SecurityTest

# Solution 3: View detailed error
./mvnw.cmd test -X

# Solution 4: Skip tests temporarily (ONLY for demo)
./mvnw.cmd spring-boot:run -DskipTests
```

**⚠️ WARNING:** If tests fail during presentation, you lose points!

---

### ⚠️ HIGH PRIORITY ISSUES

#### 3. Data Isolation Not Working (User B sees User A's data)

**This will result in 0 points for Authorization (20 pts)!**

**Check:**
1. `NoteService.java` line 46: Must use `findByUserId(user.getId())`
2. `NoteRepository.java` line 31: SQL must have `WHERE user_id = ?`
3. Make sure you're logged in as different users

**Test:**
```powershell
# In browser:
# 1. Login as alice@demo.com
# 2. Create note "Alice Secret"
# 3. Logout
# 4. Login as bob@demo.com
# 5. Dashboard should be EMPTY
```

#### 4. Passwords Not Hashed

**This will result in 0 points for Authentication (15 pts)!**

**Check:**
1. `SecurityConfig.java` line 114: Must have `BCryptPasswordEncoder`
2. Check database (H2 console): Passwords should look like `$2a$10$...`

**Verify:**
```powershell
# Go to https://localhost:8443/h2-console
# JDBC URL: jdbc:h2:mem:testdb
# Username: sa
# Password: (leave empty)
# Run: SELECT * FROM users;
# Password column should show hashed values starting with $2a$
```

#### 5. Security Headers Missing

**This will result in 0 points for Headers section (8 pts)!**

**Check in Browser:**
1. F12 → Network tab
2. Refresh page
3. Click first request
4. Look at Response Headers

**Required Headers:**
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: SAMEORIGIN`
- `Content-Security-Policy: ...`
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Strict-Transport-Security: max-age=31536000` (bonus)

**If missing, check:**
- `SecurityConfig.java` lines 76-87
- Make sure you're looking at Response Headers, not Request Headers
- Make sure you're on the web interface, not API endpoints

---

### 🟡 MEDIUM PRIORITY ISSUES

#### 6. Can't See Cookies in DevTools

**Symptoms:**
- No JSESSIONID cookie visible
- Can't verify HttpOnly/Secure/SameSite

**Solutions:**

1. **Make sure you're on HTTPS:**
   - URL must be `https://localhost:8443`, not `http://`

2. **Clear browser cache:**
   ```
   Ctrl + Shift + Delete → Clear cookies
   ```

3. **Use incognito mode:**
   - Ctrl + Shift + N (Chrome)
   - Ctrl + Shift + P (Firefox)

4. **Check correct location:**
   - F12 → Application tab → Cookies → https://localhost:8443
   - NOT in Network tab

5. **Login first:**
   - Cookies only appear after successful login

#### 7. Certificate Warning in Browser

**This is NORMAL for self-signed certificates!**

**How to proceed:**
1. Click "Advanced"
2. Click "Proceed to localhost (unsafe)"
3. This is expected and won't affect your grade

**For Chrome:**
- Type `thisisunsafe` when on the warning page

#### 8. Registration/Login Not Working

**Symptoms:**
- Form submission does nothing
- CSRF errors
- 403 Forbidden

**Solutions:**

1. **Check CSRF configuration:**
   - `SecurityConfig.java` line 72: Should ignore `/register`

2. **Clear cookies:**
   - F12 → Application → Cookies → Clear all

3. **Check form has CSRF token:**
   - View page source
   - Look for `<input type="hidden" name="_csrf"`

4. **Use incognito mode:**
   - Avoids cookie conflicts

#### 9. H2 Console Not Accessible

**Symptoms:**
- `/h2-console` returns 404 or 403
- "No Javascript" error message
- H2 console shows blank page

**Solutions:**

1. **Check application.properties:**
   ```properties
   spring.h2.console.enabled=true
   spring.h2.console.path=/h2-console
   ```

2. **Check SecurityConfig:**
   - Lines 34-44: H2 console security filter chain
   - Must have CSP configured to allow H2's inline scripts

3. **Access correctly:**
   - URL: `https://localhost:8443/h2-console`
   - JDBC URL: `jdbc:h2:mem:testdb`
   - Username: `sa`
   - Password: (empty)

4. **If "No Javascript" error:**
   - **Fixed:** We now use `PathRequest.toH2Console()` which guarantees matching the H2 console path.
   - We explicitly enable `unsafe-inline` and `unsafe-eval` only for H2.
   - We utilize a dedicated security chain with `@Order(0)` precedence.
   - **Verification:**
     - Main App: Strict CSP (Secure)
     - H2 Console: Relaxed CSP (Functional)

---

### 🟢 LOW PRIORITY ISSUES

#### 10. Logs Not Showing Security Events

**Check:**
1. Look in correct terminal (where app is running)
2. Scroll up to find events
3. Make sure you triggered events (failed login, unauthorized access)

**Trigger events:**
```powershell
# Failed login:
# Go to /login, enter wrong password

# Unauthorized access:
# Logout, try to access /dashboard
```

#### 11. Tests Take Too Long

**Normal test time: 8-15 seconds**

**If taking longer:**
```powershell
# Run tests in parallel
./mvnw.cmd test -T 1C

# Run specific test
./mvnw.cmd test -Dtest=SecurityTest
```

#### 12. Port 8443 Already in Use

**Solutions:**

```powershell
# Find process using port 8443
netstat -ano | findstr :8443

# Kill the process
taskkill /PID <PID> /F

# Or change port in application.properties
# server.port=8444
```

---

## 🎯 PRE-PRESENTATION CHECKLIST

Run this checklist 5 minutes before presentation:

### ✅ Application
- [ ] App starts without errors
- [ ] Accessible at `https://localhost:8443`
- [ ] Login page loads

### ✅ Browser
- [ ] Incognito mode
- [ ] DevTools open (F12)
- [ ] Network tab selected
- [ ] Certificate accepted

### ✅ Users
- [ ] Can register new user
- [ ] Can login
- [ ] Can create note
- [ ] Can logout

### ✅ Data Isolation
- [ ] Alice can create note
- [ ] Bob cannot see Alice's note
- [ ] Each user sees only their own data

### ✅ Security Headers
- [ ] All 5 headers visible in DevTools
- [ ] JSESSIONID cookie has HttpOnly
- [ ] JSESSIONID cookie has Secure
- [ ] JSESSIONID cookie has SameSite

### ✅ Code
- [ ] SecurityConfig.java open
- [ ] NoteService.java open
- [ ] UserDTO.java open
- [ ] PasswordValidator.java open
- [ ] AuthenticationEvents.java open

### ✅ Tests
- [ ] `./mvnw.cmd test` passes
- [ ] Takes less than 15 seconds
- [ ] Shows BUILD SUCCESS

---

## 🚨 EMERGENCY PROCEDURES

### If App Crashes During Demo

**DON'T PANIC!**

1. **Restart quickly:**
   ```powershell
   Ctrl + C  # Stop app
   ./mvnw.cmd spring-boot:run
   ```

2. **While waiting (30 seconds):**
   - Show code files
   - Explain architecture
   - Show test results (if already run)

3. **If won't restart:**
   - Show pre-run test results
   - Walk through code
   - Explain what you would demonstrate

### If Tests Fail During Demo

1. **Check if app is running:**
   - Tests might fail if app is running
   - Stop app, run tests, restart app

2. **Show previous test results:**
   - If you ran tests before, show that output

3. **Explain the tests:**
   - Open `SecurityTest.java`
   - Explain what it tests
   - Show the test code

### If Browser Issues

1. **Switch browsers:**
   - Have Chrome AND Firefox ready
   - Same features work in both

2. **Clear everything:**
   ```
   Ctrl + Shift + Delete
   Clear all cookies and cache
   Restart browser
   ```

3. **Use different incognito window:**
   - Close current incognito
   - Open new incognito

---

## 📞 QUICK FIXES

### Can't login
```powershell
# Clear cookies, restart browser
```

### Can't see headers
```
F12 → Network → Refresh → Click first request → Response Headers
```

### Can't see cookies
```
F12 → Application → Cookies → https://localhost:8443
```

### Tests won't run
```powershell
./mvnw.cmd clean test
```

### App won't start
```powershell
./mvnw.cmd clean install
./mvnw.cmd spring-boot:run
```

---

## 🎓 PROFESSOR QUESTIONS - PREPARED ANSWERS

### "Where is password hashing implemented?"
**Answer:** "In `SecurityConfig.java` line 114, we configure `BCryptPasswordEncoder` with strength 10. This bean is injected into the `AuthenticationProvider` on line 103."

### "How do you prevent User B from accessing User A's data?"
**Answer:** "In `NoteService.java` line 46, we call `findByUserId(user.getId())` where `user` comes from the security context. The repository uses a prepared statement with `WHERE user_id = ?` to filter at the database level."

### "How do you prevent SQL injection?"
**Answer:** "We use Spring's `JdbcTemplate` which automatically creates prepared statements. You can see this in `NoteRepository.java` lines 31-32 where we use `?` placeholders and pass parameters separately."

### "What happens if someone tries to access a protected page?"
**Answer:** "Spring Security intercepts the request. If unauthenticated, they're redirected to `/login`. This is configured in `SecurityConfig.java` lines 73-75."

### "How do you ensure passwords aren't logged?"
**Answer:** "In `AuthenticationEvents.java` line 19, we use `LoggingUtils.maskEmail()` to mask sensitive data. We never log password fields, only usernames, and even those are masked."

### "What security headers do you implement?"
**Answer:** "We implement 5 security headers in `SecurityConfig.java` lines 76-87:
- X-Content-Type-Options: nosniff
- X-Frame-Options: SAMEORIGIN  
- Content-Security-Policy with strict directives
- Referrer-Policy: strict-origin-when-cross-origin
- Strict-Transport-Security with 1-year max-age"

---

## ✅ FINAL CONFIDENCE CHECK

**You're ready if you can answer YES to all:**

- [ ] App starts in under 30 seconds
- [ ] Tests pass in under 15 seconds
- [ ] You can register and login
- [ ] You can demonstrate data isolation
- [ ] You can show all security headers
- [ ] You can show cookie attributes
- [ ] You can explain password hashing
- [ ] You can explain data isolation logic
- [ ] You know where each feature is in code
- [ ] You can complete demo in under 10 minutes

**If all YES → You're ready for 90/90! 🎯**

---

## 📚 ADDITIONAL RESOURCES

- `MAX_POINTS_CHECKLIST.md` - Detailed point-by-point verification
- `QUICK_REFERENCE.md` - Condensed demo flow
- `PRESENTATION_SCRIPT.md` - Original presentation script
- `verify_presentation.ps1` - Automated verification script

**Run verification script:**
```powershell
./verify_presentation.ps1
```

---

**Good luck! You've got this! 🚀**
