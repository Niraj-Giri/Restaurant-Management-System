package com.cskaa.restaurant.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.cskaa.restaurant.config.CustomUserDetails;
import com.cskaa.restaurant.model.User;
import com.cskaa.restaurant.repository.UserRepository;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
    	 System.out.println("LOAD USER: " + username);
        User user = userRepository.findByUsername(username);
            if(user==null)throw    new UsernameNotFoundException("User not found");

        return new CustomUserDetails(user);
    }
}
