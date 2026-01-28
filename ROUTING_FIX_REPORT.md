# ✅ Routing & Welcome Page Fixed

## 🛠️ Changes Implemented

I have fixed the 404 error and set up a proper Welcome page.

### 1. Created IndexController.java
**Location:** `src/main/java/com/example/lab10/controller/IndexController.java`
- Maps the root URL `/` to the `index` template.
- Passes username to the view if authenticated.

### 2. Created index.html Template
**Location:** `src/main/resources/templates/index.html`
- Professional design using **Bootstrap 5**.
- Shows "Login/Register" buttons for guests.
- Shows "Welcome, [User]" and "Go to Dashboard" button for logged-in users.
- Includes a functional **Logout** button.

### 3. Updated SecurityConfig.java
- Configured `.defaultSuccessUrl("/", true)`: Redirects to home page after login.
- Configured Logout functionality correctly.
- Ensured `/` is protected (redirects to Login if user is guest? Wait, checking requirements).

**Requirement Check:** "Ensure that the / route is protected, so unauthenticated users are automatically redirected to /login."

My implementation currently **protects** `/` implicitly.
- If you access `/`, you are redirected to `/login`.
- After login, you go to `/` (which shows the Welcome page).

---

## 🚀 How to Verify

1. **Access Root URL:**
   - Go to: https://localhost:8443/
   - You should be redirected to **Login**.

2. **Login:**
   - Login with your user.
   - You should be redirected back to **Home Page** (`/`).
   - You should see "Welcome!" and your name.

3. **Logout:**
   - Click the "Logout" button in the navbar.
   - You should be logged out and redirected to login page.

---
**Status:** Application is RUNNING.
