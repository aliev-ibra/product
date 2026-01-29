package com.example.lab10.util;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class LoggingUtilsTest {

    @Test
    void testMaskEmail_ValidEmail() {
        String email = "aliev.ibra99@gmail.com";
        String masked = LoggingUtils.maskEmail(email);
        
        // Should mask to "a***@g***.com"
        assertTrue(masked.startsWith("a***@"));
        assertTrue(masked.endsWith(".com"));
        assertFalse(masked.contains("aliev"));
        assertFalse(masked.contains("ibra99"));
        assertFalse(masked.contains("gmail"));
    }

    @Test
    void testMaskEmail_ShortEmail() {
        String email = "a@b.com";
        String masked = LoggingUtils.maskEmail(email);
        
        // Should still mask properly
        assertTrue(masked.contains("***"));
        assertFalse(masked.equals(email));
    }

    @Test
    void testMaskEmail_NullEmail() {
        String masked = LoggingUtils.maskEmail(null);
        assertEquals("***", masked);
    }

    @Test
    void testMaskEmail_EmptyEmail() {
        String masked = LoggingUtils.maskEmail("");
        assertEquals("***", masked);
    }

    @Test
    void testMaskEmail_InvalidFormat() {
        String email = "notanemail";
        String masked = LoggingUtils.maskEmail(email);
        assertEquals("***", masked);
    }

    @Test
    void testMaskUsername_ValidUsername() {
        String username = "johndoe";
        String masked = LoggingUtils.maskUsername(username);
        
        assertEquals("jo***", masked);
        assertFalse(masked.contains("hndoe"));
    }

    @Test
    void testMaskUsername_ShortUsername() {
        String username = "ab";
        String masked = LoggingUtils.maskUsername(username);
        assertEquals("***", masked);
    }

    @Test
    void testMaskUsername_NullUsername() {
        String masked = LoggingUtils.maskUsername(null);
        assertEquals("***", masked);
    }
}
