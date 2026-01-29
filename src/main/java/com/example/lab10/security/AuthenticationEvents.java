package com.example.lab10.security;

import com.example.lab10.util.LoggingUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.event.EventListener;
import org.springframework.security.authentication.event.AbstractAuthenticationFailureEvent;
import org.springframework.security.authentication.event.AuthenticationSuccessEvent;
import org.springframework.security.authorization.event.AuthorizationDeniedEvent;
import org.springframework.stereotype.Component;

@Component
public class AuthenticationEvents {

    private static final Logger logger = LoggerFactory.getLogger(AuthenticationEvents.class);

    @EventListener
    public void onSuccess(AuthenticationSuccessEvent event) {
        logger.info("Login successful for user: {}", LoggingUtils.maskEmail(event.getAuthentication().getName()));
    }

    @EventListener
    public void onFailure(AbstractAuthenticationFailureEvent event) {
        logger.warn("WARN: Failed login attempt for user: {}", 
                LoggingUtils.maskEmail(event.getAuthentication().getName()));
    }

    // For Authorization failures (403) - Spring Security 6+
    @EventListener
    public void onAuthorizationDenied(AuthorizationDeniedEvent<?> event) {
        String source = event.getSource() != null ? event.getSource().toString() : "Unknown";
        String user = event.getAuthentication() != null && event.getAuthentication().get().getName() != null 
            ? LoggingUtils.maskEmail(event.getAuthentication().get().getName()) 
            : "Anonymous";
        
        logger.warn("WARN: Unauthorized access attempt to [{}] by user: {}", source, user);
    }
}
