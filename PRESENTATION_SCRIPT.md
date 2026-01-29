# 🎤 LIVE Presentation Script (Cheat Sheet)

> **Time Limit:** 10 Minutes Total.
> **Key Rule:** Don't explain it, **SHOW IT**.

---

## 🚀 1. Setup (Before Presentation Starts)
- Open **Terminal** (PowerShell/CMD).
- Run the app: `.\mvnw.cmd spring-boot:run`
- Open **Browser (Incognito mode recommended)**.
- Open **Developer Tools** (F12) -> Select **Network Tab**.
- Have code editor open to `SecurityConfig.java` and `NoteService.java`.

---

## ⏱️ 2. Application Overview (max 1 min)
**Say:** "This is a secure Spring Boot application using MVC architecture with session-based authentication. It allows users to manage private notes efficiently."
**Show:** 
- `User` entity (Owner of data).
- `Note` entity (Has `user_id`).
- `SecurityConfig` (Briefly scroll to show standard setup).

---

## 🔐 3. Authentication (MANDATORY)

### 3.1 Registration Live Demo
**Action:** Go to `https://localhost:8443/register`
1. **Show Validation:**
   - Enter invalid email (e.g., `bad-email`).
   - Enter short password (e.g., `123`).
   - click **Register**.
   - **Show:** Error messages on screen ("Invalid email", "Password too short").
2. **Success:**
   - Register **User A**:
     - Email: `alice@demo.com`
     - Password: `Password123!`
   - **Show:** Redirect to Login page.
   - **Say:** "Registration uses BCrypt hashing and server-side validation."

### 3.2 Login Live Demo
**Action:** Go to `https://localhost:8443/login`
1. **Failure:**
   - Email: `alice@demo.com`
   - Password: `WrongPassword!`
   - **Show:** "Invalid username or password" (Safe error message).
2. **Success:**
   - Password: `Password123!`
   - **Show:** Redirect to Dashboard (Welcome Alice).
3. **Cookie Proof:**
   - Open DevTools -> Application/Storage -> Cookies.
   - **Show:** `JSESSIONID` cookie (HttpOnly, Secure).

---

## 🛡️ 4. Authorization & Data Isolation (CRITICAL)

### 4.1 Protected Routes
**Action:**
1. Copy the URL of your dashboard (`/dashboard`).
2. Click **Logout**.
3. Paste the URL (`/dashboard`) into the address bar.
4. **Show:** Redirected back to Login (Access Denied).
5. **Say:** "Unauthenticated users cannot access protected resources."

### 4.2 User Data Isolation (The Big One)
**Action:**
1. Login as **User A (Alice)**.
2. Create Note: `Title: Confidential Strategy`, `Content: Top Secret`.
3. Verify note appears in list.
4. **Logout**.
5. Login as **User B (Bob)** (Create Bob quickly if needed).
   - *If you haven't created Bob, use this flow:* Register `bob@demo.com` / `Password123!`.
6. Login as **Bob**.
7. **Show:** Dashboard is **EMPTY**. Alice's note is NOT visible.
8. **Say:** "The service layer filters queries by User ID from the valid security context. Bob creates his own note..."
9. Create Note: `Bob's Diary`.
10. Logout and check Alice again (She sees `Confidential Strategy`, not `Bob's Diary`).

---

## 🧱 5. Input Validation
**Action:** Go to Dashboard (as Alice).
1. Try to create a note with empty Title.
2. **Show:** Logic rejects it (or if UI validation blocks it, mention DTO annotations).
3. **Show Code:** Open `NoteDTO.java` to show `@NotBlank`, `@Size`.

---

## 🌐 6. HTTP Security Headers (DevTools)
**Action:**
1. In Browser (logged in), press **F12** (DevTools).
2. Go to **Network** tab.
3. Refresh the page (`F5`).
4. Click the first request (e.g., `dashboard`).
5. **Show Request Headers:**
   - `X-Content-Type-Options: nosniff`
   - `X-Frame-Options: SAMEORIGIN`
   - `Content-Security-Policy: default-src 'self' ...`
   - `Referrer-Policy: strict-origin-when-cross-origin`
   - `Strict-Transport-Security: max-age=...` (Bonus!)

---

## 💾 7. Database Security & Logging
**Action:**
1. **Show Code:** Open `NoteService.java`.
   - Point to `noteRepository.findByUserId(user.getId())`.
   - **Say:** "We enforce user_id at the database query level using Spring Data JPA (Prepared Statements)."
2. **Show Logs:** Open your Terminal/IDE console.
   - Scroll to where you failed the login earlier.
   - **Show:** Log entry: `AuthenticationEvents : Unauthorized access attempt`.
   - **Say:** "Security events are logged, but no passwords or tokens are visible."

---

## 🧪 8. Testing (MANDATORY)
**Action:**
1. Go to Terminal.
2. Run: `.\mvnw.cmd test`
3. Wait ~10 seconds.
4. **Show:** `BUILD SUCCESS` with:
   - `Tests run: 4` (or similar).
   - Mention `SecurityTest` and `UserValidationTest`.

---

## 🌟 9. Bonus Features (Extra 15 Pts)
**Mention briefly:**
1. **HTTPS:** "We are running on port 8443 with SSL/TLS enabled and HSTS."
2. **OWASP Check:** 
   - Run: `.\mvnw.cmd dependency-check:check` (If time permits, or show pre-generated report in `target/`).
3. **CI Pipeline:** Show `.github/workflows/maven.yml` file.

---

## ✅ Closing
**Say:** "The application meets all core security requirements including data isolation, secure transport, and automated vulnerability scanning. Thank you."
