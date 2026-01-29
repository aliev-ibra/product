package com.example.lab10.util;

/**
 * Utility class for secure logging practices.
 * Masks sensitive information like emails and usernames to prevent credential leakage.
 */
public class LoggingUtils {

    /**
     * Masks an email address for logging purposes.
     * Example: "user@example.com" becomes "u***@e***.com"
     * 
     * @param email the email to mask
     * @return masked email or "***" if null/empty
     */
    public static String maskEmail(String email) {
        if (email == null || email.isEmpty()) {
            return "***";
        }
        
        int atIndex = email.indexOf('@');
        if (atIndex <= 0) {
            // Invalid email format, mask completely
            return "***";
        }
        
        String localPart = email.substring(0, atIndex);
        String domain = email.substring(atIndex + 1);
        
        // Mask local part: show first char + ***
        String maskedLocal = localPart.length() > 0 
            ? localPart.charAt(0) + "***" 
            : "***";
        
        // Mask domain: show first char + *** + last part after last dot
        int lastDot = domain.lastIndexOf('.');
        String maskedDomain;
        if (lastDot > 0) {
            maskedDomain = domain.charAt(0) + "***" + domain.substring(lastDot);
        } else {
            maskedDomain = domain.charAt(0) + "***";
        }
        
        return maskedLocal + "@" + maskedDomain;
    }

    /**
     * Masks a username for logging purposes.
     * Shows first 2 characters and masks the rest.
     * 
     * @param username the username to mask
     * @return masked username
     */
    public static String maskUsername(String username) {
        if (username == null || username.isEmpty()) {
            return "***";
        }
        
        if (username.length() <= 2) {
            return "***";
        }
        
        return username.substring(0, 2) + "***";
    }
}
