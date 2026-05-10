package com.cskaa.restaurant.controller;

import com.cskaa.restaurant.config.CustomUserDetails;
import com.cskaa.restaurant.data.LoginRequest;
import com.cskaa.restaurant.data.LoginResponse;
import com.cskaa.restaurant.data.Role;
import com.cskaa.restaurant.exception.UserAlreadyExistsException;
import com.cskaa.restaurant.model.User;
import com.cskaa.restaurant.repository.UserRepository;
import com.cskaa.restaurant.service.JwtService;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;

import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

import javax.validation.Valid;

@Slf4j
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;

    public AuthController(AuthenticationManager authenticationManager,
                          JwtService jwtService) {
        this.authenticationManager = authenticationManager;
        this.jwtService = jwtService;
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody User user, Authentication authentication) {
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new UserAlreadyExistsException("An account with this email already exists!");
        }

        // Only ADMINs can register roles other than CUSTOMER
        if (user.getRole() != Role.CUSTOMER) {
            boolean isRequestorAdmin = authentication != null && authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

            if (!isRequestorAdmin) {
                return ResponseEntity.status(403)
                        .body(java.util.Map.of("message", "Access Denied: Only Admins can register these roles."));
            }
        }

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        userRepository.save(user);

        return ResponseEntity.ok(Collections.singletonMap("message", "Registration successful!"));
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request) {

        log.info("inside login");

        // Delegate authentication fully to Spring Security (handles bad credentials automatically)
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(),
                        request.getPassword()
                )
        );

        log.info("Authorities in auth: " + authentication.getAuthorities());
        log.info("Principal class: " + authentication.getPrincipal().getClass());

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        log.info("CustomUserDetails - {}", userDetails.getUsername());

        String token = jwtService.generateToken(userDetails);

        log.info("Token - {}", token);

        List<String> roles = userDetails.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .toList();

        return ResponseEntity.ok(new LoginResponse(token, userDetails.getUsername(), roles));
    }
}