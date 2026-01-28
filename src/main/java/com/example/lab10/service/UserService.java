package com.example.lab10.service;

import com.example.lab10.model.User;
import com.example.lab10.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public void createUser(User user) {
        // Hash the password
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        
        // Add default metadata if missing
        if (user.getDetails() == null) {
            user.setDetails("{\"city\":\"Baku\", \"registration_date\":\"" + LocalDate.now() + "\"}");
        }
        
        userRepository.save(user); // JPA handles persistence
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }
}
