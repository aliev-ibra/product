package com.example.lab10;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class SecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void accessPublicEndpoint_ShouldBeAllowed() throws Exception {
        mockMvc.perform(get("/login"))
                .andExpect(status().isOk());
    }

    @Test
    void accessProtectedEndpoint_WithoutAuth_ShouldBeUnauthorized() throws Exception {
        mockMvc.perform(get("/api/notes"))
                .andExpect(status().isForbidden()); // Spring Security returns 403 for anonymous access to protected resources by default
    }
}
