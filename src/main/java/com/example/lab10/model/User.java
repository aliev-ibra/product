package com.example.lab10.model;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@jakarta.persistence.Entity
@jakarta.persistence.Table(name = "users")
public class User {
    @jakarta.persistence.Id
    @jakarta.persistence.GeneratedValue(strategy = jakarta.persistence.GenerationType.IDENTITY)
    private Long id;
    
    private String username;
    
    @jakarta.persistence.Column(unique = true)
    private String email;
    
    private String password;
    
    private String role = "ROLE_USER";
    
    // JSON data - stored as String effectively
    private String details; 
}
