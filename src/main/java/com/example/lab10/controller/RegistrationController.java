package com.example.lab10.controller;

import com.example.lab10.dto.UserDTO;
import com.example.lab10.model.User;
import com.example.lab10.service.UserService;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class RegistrationController {

    private final UserService userService;

    public RegistrationController(UserService userService) {
        this.userService = userService;
    }

    private static final org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger(RegistrationController.class);

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("user", new UserDTO());
        return "register";
    }

    @PostMapping("/register")
    public String register(@Valid @ModelAttribute("user") UserDTO userDTO, BindingResult result) {
        if (result.hasErrors()) {
            logger.warn("Validation failed during registration for user: {}", userDTO.getEmail());
            return "register";
        }

        try {
            User user = new User();
            user.setUsername(userDTO.getUsername());
            user.setEmail(userDTO.getEmail());
            user.setPassword(userDTO.getPassword());
            // Role and Details handled in Service/Entity defaults
            
            userService.createUser(user);
            logger.info("Registration successful for user: {}", user.getEmail());
            
        } catch (Exception e) {
            logger.error("Registration failed", e);
            return "redirect:/register?error";
        }

        return "redirect:/login";
    }
}
