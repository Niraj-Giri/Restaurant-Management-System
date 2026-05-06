package com.cskaa.restaurant.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.cskaa.restaurant.data.Role;
import com.cskaa.restaurant.model.User;
import com.cskaa.restaurant.repository.UserRepository;

import java.time.LocalDateTime;
import java.util.Set;

@Slf4j
@Component
public class DataInitializer implements CommandLineRunner {

	@Autowired
    private UserRepository userRepository;
   
    @Override
    @Transactional
    public void run(String... args) {
        log.info("🌱 Initializing default database data...");
        
       
        createDefaultUsers();
       
        log.info("Default data initialization completed");
    }

   

    private void createDefaultUsers() {
        if (userRepository.count() == 0) {
            User user = new User();
            user.setFirstName("Admin");
            user.setLastName("User");
            user.setEmail("admin@gmail.com");
          
            user.setCreatedAt(LocalDateTime.now());
            user.setDeleted(false);
            user.setMobileNumber("9999999999");
            user.setPassword("123456");
            user.setRole(Role.ADMIN);
            userRepository.save(user);
            
        }
            
   
    }

}