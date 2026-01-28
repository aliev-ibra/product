package com.example.lab10;

import com.example.lab10.dto.UserDTO;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class UserValidationTest {

    private Validator validator;

    @BeforeEach
    void setUp() {
        ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
        validator = factory.getValidator();
    }

    @Test
    void whenPasswordIsWeak_ShouldFailValidation() {
        UserDTO user = new UserDTO();
        user.setEmail("test@test.com");
        user.setPassword("123"); // Too short
        
        Set<ConstraintViolation<UserDTO>> violations = validator.validate(user);
        assertFalse(violations.isEmpty(), "Weak password should cause validation errors");
    }

    @Test
    void whenEmailIsInvalid_ShouldFailValidation() {
        UserDTO user = new UserDTO();
        user.setEmail("not-an-email");
        user.setPassword("StrongPass1!");
        
        Set<ConstraintViolation<UserDTO>> violations = validator.validate(user);
        assertFalse(violations.isEmpty(), "Invalid email should cause validation errors");
    }
}
