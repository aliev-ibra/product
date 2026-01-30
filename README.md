# 🎯 Spring Boot Security Lab - Maximum Points Edition

## 📊 Project Status: READY FOR 90/90

This Spring Boot application demonstrates **comprehensive security features** designed to achieve **maximum points (90/90)** in your security presentation.

---

## 🚀 Quick Start

### Start Application
```powershell
./mvnw.cmd spring-boot:run
```

### Run Tests
```powershell
./mvnw.cmd test
```

### Verify Everything
```powershell
./verify_presentation.ps1
```

### Access Application
- **URL:** `https://localhost:8443`
- **H2 Console:** `https://localhost:8443/h2-console`
  - JDBC URL: `jdbc:h2:mem:testdb`
  - Username: `sa`
  - Password: (empty)

---

## 📚 Documentation Guide

### 🎯 For Presentation Preparation

1. **START HERE:** `FINAL_SUMMARY.md`
   - Complete project overview
   - All features explained
   - Expected score breakdown

2. **STUDY THIS:** `MAX_POINTS_CHECKLIST.md`
   - Point-by-point verification
   - Detailed demo steps
   - Critical reminders

3. **USE DURING DEMO:** `QUICK_REFERENCE.md`
   - Condensed 10-minute flow
   - Key talking points
   - Demo credentials

4. **DAY OF PRESENTATION:** `PRESENTATION_DAY_CHECKLIST.md`
   - Time-based checklist
   - Step-by-step guide
   - Emergency procedures

5. **IF ISSUES ARISE:** `TROUBLESHOOTING.md`
   - Common problems and solutions
   - Emergency procedures
   - Prepared answers for questions

### 🔧 Technical Documentation

- `PRESENTATION_SCRIPT.md` - Original detailed script
- `SECURITY_NOTES.md` - Security implementation notes
- `API_DOCS.md` - REST API documentation
- `TESTING_GUIDE.md` - Testing documentation

---

## ✅ Implemented Features

### Core Security (75 points)

#### 1. Application Readiness (5 pts) ✅
- Runs on HTTPS port 8443
- Starts without errors
- Quick restart capability

#### 2. Authentication (15 pts) ✅
- User registration with validation
- BCrypt password hashing (strength 10)
- Session-based authentication
- Secure cookies (HttpOnly, Secure, SameSite)
- Safe error messages
- Custom password validator

#### 3. Authorization & Access Control (20 pts) ✅
- Protected routes
- Role-based access control
- **User data isolation** (CRITICAL)
- Service-layer enforcement
- Repository-level filtering

#### 4. Input Validation (10 pts) ✅
- DTO validation annotations
- Custom password validator
- HTTP 400 for invalid input
- Structured error responses
- No stack traces exposed

#### 5. Security Headers (8 pts) ✅
- X-Content-Type-Options: nosniff
- X-Frame-Options: SAMEORIGIN
- Content-Security-Policy
- Referrer-Policy: strict-origin-when-cross-origin
- Cookie security attributes

#### 6. Session Management (7 pts) ✅
- Logout functionality
- Session invalidation
- Cookie deletion
- JWT token expiration (API)
- Refresh token rotation (API)

#### 7. Database Security (5 pts) ✅
- Foreign key constraints (user_id)
- Prepared statements (JdbcTemplate)
- SQL injection prevention
- Parameterized queries

#### 8. Secure Logging (5 pts) ✅
- Failed login attempts logged
- Unauthorized access logged
- Passwords NOT logged
- Tokens NOT logged
- Email masking

#### 9. Testing (Core Requirement) ✅
- SecurityTest - Protected endpoints
- UserValidationTest - DTO validation
- LoggingUtilsTest - Logging utilities
- All tests pass (~8 seconds)

---

### Bonus Features (+15 points)

#### 1. HTTPS + HSTS (+5 pts) ✅
- SSL/TLS enabled (port 8443)
- Self-signed certificate
- HSTS header (max-age=1 year)
- Include subdomains

#### 2. Rate Limiting (+3 pts) ✅
- Custom RateLimitFilter
- 50 requests per minute per IP
- HTTP 429 response

#### 3. GitHub Actions CI (+3 pts) ✅
- Automated testing on push
- Maven build pipeline
- Test execution

#### 4. OWASP Dependency Check (+4 pts) ✅
- Maven plugin configured
- Vulnerability scanning
- HTML report generation

---

## 🏗️ Architecture

### Technology Stack
- **Framework:** Spring Boot 3.4.2
- **Security:** Spring Security 6
- **Database:** H2 (in-memory)
- **Migration:** Flyway
- **Authentication:** Session-based (MVC) + JWT (REST API)
- **Password Hashing:** BCrypt
- **Build Tool:** Maven
- **Java Version:** 21

### Project Structure
```
src/
├── main/
│   ├── java/com/example/lab10/
│   │   ├── config/
│   │   │   └── SecurityConfig.java          # Security configuration
│   │   ├── controller/
│   │   │   ├── AuthController.java          # Web authentication
│   │   │   ├── AuthRestController.java      # REST API auth
│   │   │   ├── NoteController.java          # Note management
│   │   │   └── RegistrationController.java  # User registration
│   │   ├── dto/
│   │   │   ├── UserDTO.java                 # User validation
│   │   │   └── NoteDTO.java                 # Note validation
│   │   ├── exception/
│   │   │   └── GlobalExceptionHandler.java  # Error handling
│   │   ├── filter/
│   │   │   └── RateLimitFilter.java         # Rate limiting
│   │   ├── model/
│   │   │   ├── User.java                    # User entity
│   │   │   ├── Note.java                    # Note entity
│   │   │   └── RefreshToken.java            # JWT refresh token
│   │   ├── repository/
│   │   │   ├── UserRepository.java          # User data access
│   │   │   ├── NoteRepository.java          # Note data access (prepared statements)
│   │   │   └── RefreshTokenRepository.java  # Token management
│   │   ├── security/
│   │   │   ├── AuthenticationEvents.java    # Security event logging
│   │   │   ├── CustomUserDetailsService.java
│   │   │   ├── JwtAuthenticationFilter.java
│   │   │   └── JwtUtils.java
│   │   ├── service/
│   │   │   ├── UserService.java
│   │   │   ├── NoteService.java             # Data isolation enforcement
│   │   │   └── RefreshTokenService.java
│   │   ├── util/
│   │   │   └── LoggingUtils.java            # Secure logging utilities
│   │   └── validation/
│   │       ├── PasswordConstraint.java      # Custom annotation
│   │       └── PasswordValidator.java       # Custom validator
│   └── resources/
│       ├── application.properties           # App configuration
│       ├── keystore.p12                     # SSL certificate
│       └── db/migration/                    # Flyway migrations
└── test/
    └── java/com/example/lab10/
        ├── SecurityTest.java                # Security integration tests
        ├── UserValidationTest.java          # Validation tests
        └── util/LoggingUtilsTest.java       # Logging tests
```

---

## 🎯 Critical Features Explained

### 1. Password Hashing
**Location:** `SecurityConfig.java` line 114
```java
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder(10);
}
```
**Explanation:** Passwords are hashed using BCrypt with strength 10 before storage.

### 2. Data Isolation
**Location:** `NoteService.java` line 46
```java
public List<Note> getMyNotes() {
    User user = getCurrentUser();
    return noteRepository.findByUserId(user.getId());
}
```
**Explanation:** Service layer retrieves current user from security context and filters all queries by user ID.

### 3. Prepared Statements
**Location:** `NoteRepository.java` line 31
```java
public List<Note> findByUserId(Long userId) {
    String sql = "SELECT * FROM notes WHERE user_id = ?";
    return jdbcTemplate.query(sql, noteRowMapper, userId);
}
```
**Explanation:** JdbcTemplate uses prepared statements with parameterized queries to prevent SQL injection.

### 4. Security Headers
**Location:** `SecurityConfig.java` lines 76-87
```java
.headers(headers -> headers
    .frameOptions(frame -> frame.sameOrigin())
    .contentSecurityPolicy(csp -> csp.policyDirectives("..."))
    .referrerPolicy(referrer -> referrer.policy(...))
    .xssProtection(xss -> xss.headerValue(...))
    .httpStrictTransportSecurity(hsts -> hsts
        .maxAgeInSeconds(31536000)
        .includeSubDomains(true)))
```
**Explanation:** All security headers configured in Spring Security filter chain.

### 5. Secure Logging
**Location:** `AuthenticationEvents.java` line 19
```java
logger.info("Login successful for user: {}", 
    LoggingUtils.maskEmail(event.getAuthentication().getName()));
```
**Explanation:** Sensitive data is masked before logging using custom utility.

---

## 🎬 Demo Credentials

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

## 🧪 Testing

### Run All Tests
```powershell
./mvnw.cmd test
```

### Run Specific Test
```powershell
./mvnw.cmd test -Dtest=SecurityTest
```

### Test Coverage
- **SecurityTest:** Protected endpoint access control
- **UserValidationTest:** DTO validation rules
- **LoggingUtilsTest:** Email masking functionality

---

## 🔒 Security Features Checklist

### Authentication & Authorization
- [x] BCrypt password hashing
- [x] Session-based authentication
- [x] JWT token authentication (API)
- [x] Secure cookies (HttpOnly, Secure, SameSite)
- [x] Role-based access control
- [x] User data isolation

### Input Validation
- [x] DTO validation annotations
- [x] Custom password validator
- [x] Safe error messages
- [x] No stack traces exposed

### Security Headers
- [x] X-Content-Type-Options
- [x] X-Frame-Options
- [x] Content-Security-Policy
- [x] Referrer-Policy
- [x] Strict-Transport-Security (HSTS)

### Database Security
- [x] Prepared statements
- [x] Parameterized queries
- [x] Foreign key constraints
- [x] User ID filtering

### Logging
- [x] Failed login attempts logged
- [x] Unauthorized access logged
- [x] Passwords NOT logged
- [x] Tokens NOT logged
- [x] Email masking

### Additional Features
- [x] HTTPS/TLS
- [x] Rate limiting
- [x] GitHub Actions CI
- [x] OWASP Dependency Check

---

## 📊 Expected Score: 90/90

| Category | Points |
|----------|--------|
| Application Readiness | 5 |
| Authentication | 15 |
| Authorization | 20 |
| Input Validation | 10 |
| Security Headers | 8 |
| Session Management | 7 |
| Database Security | 5 |
| Secure Logging | 5 |
| **Core Total** | **75** |
| HTTPS + HSTS | 5 |
| Rate Limiting | 3 |
| GitHub Actions | 3 |
| OWASP Check | 4 |
| **Bonus Total** | **15** |
| **GRAND TOTAL** | **90** |

---

## 🆘 Troubleshooting

### Application won't start
```powershell
./mvnw.cmd clean install
./mvnw.cmd spring-boot:run
```

### Tests fail
```powershell
./mvnw.cmd clean test
```

### Port already in use
```powershell
netstat -ano | findstr :8443
taskkill /PID <PID> /F
```

### More help
See `TROUBLESHOOTING.md` for comprehensive solutions.

---

## 📞 Quick Commands Reference

```powershell
# Start application
./mvnw.cmd spring-boot:run

# Run tests
./mvnw.cmd test

# Clean build
./mvnw.cmd clean install

# Run OWASP check
./mvnw.cmd dependency-check:check

# Verify presentation readiness
./verify_presentation.ps1
```

---

## 📖 Additional Resources

- **MAX_POINTS_CHECKLIST.md** - Detailed point verification
- **QUICK_REFERENCE.md** - Demo flow and talking points
- **PRESENTATION_DAY_CHECKLIST.md** - Step-by-step presentation guide
- **TROUBLESHOOTING.md** - Problem solutions
- **FINAL_SUMMARY.md** - Complete project overview

---

## 🎓 Key Talking Points

### For Professor Questions

**Q: How do you ensure security?**
A: "We implement defense in depth with BCrypt password hashing, session-based authentication with secure cookies, role-based authorization, data isolation at the service layer, comprehensive security headers including HSTS, input validation with custom validators, and secure logging."

**Q: How do you prevent SQL injection?**
A: "We use Spring's JdbcTemplate which creates prepared statements with parameterized queries, preventing SQL injection attacks."

**Q: How do you ensure data isolation?**
A: "At the service layer, we retrieve the current user from the security context and filter all database queries by user ID using prepared statements."

---

## ✅ Pre-Presentation Checklist

- [ ] Read all documentation
- [ ] Run `./verify_presentation.ps1`
- [ ] Practice demo flow (under 10 minutes)
- [ ] Test data isolation (Alice vs Bob)
- [ ] Verify security headers in DevTools
- [ ] Verify cookies in DevTools
- [ ] Run tests successfully
- [ ] Have code editor ready
- [ ] Have browser in incognito mode

---

## 🚀 You're Ready!

This project has everything needed for **90/90 points**:
- ✅ All core features implemented
- ✅ All bonus features implemented
- ✅ Comprehensive documentation
- ✅ Verification scripts
- ✅ Demo guides

**Good luck with your presentation! 🍀**

---

**Created:** 2026-01-30  
**Author:** AI Assistant  
**Target Score:** 90/90 ⭐⭐⭐
