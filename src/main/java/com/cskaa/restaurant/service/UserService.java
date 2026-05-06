package com.cskaa.restaurant.service;

import com.cskaa.restaurant.data.Role;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.cskaa.restaurant.model.User;
import com.cskaa.restaurant.repository.UserRepository;

import java.util.Arrays;
import java.util.List;

@Service
public class UserService {
	
	@Autowired
	UserRepository userRepository;
	
	public User findByUsername(String name) {
		User user = userRepository.findByEmail(name)
				.orElseThrow(() -> new UsernameNotFoundException("User not found"));
		return user;
				
	}

	public User findByEmail(String email) {
		User user = userRepository.findByEmail(email)
				.orElseThrow(() -> new UsernameNotFoundException("User not found"));
		return user;
				
	}


	public boolean existsByEmail(String email) {
		return userRepository.existsByEmail(email);
	}



	public List<User> findUsersByRole(Role role) {
		return userRepository.findByRole(role);
	}
	public List<User> findInternalUsers() {
		// 1. Define the roles that count as "Internal"
		List<Role> internalRoles = Arrays.asList(Role.ADMIN, Role.RESTAURANT_OWNER);

		// 2. Fetch from repository
		// Option A: Use a custom repository method (Recommended for performance)
		return userRepository.findByRoleIn(internalRoles);
	}
	
	public User findById(Long id) {
		return userRepository.findById(id).orElse(null);
	}
}
