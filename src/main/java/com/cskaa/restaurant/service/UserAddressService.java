package com.cskaa.restaurant.service;

import com.cskaa.restaurant.exception.ResourceNotFoundException;
import com.cskaa.restaurant.model.User;
import com.cskaa.restaurant.model.UserAddress;
import com.cskaa.restaurant.repository.UserAddressRepository;
import com.cskaa.restaurant.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Date;
import java.util.List;

@Service
public class UserAddressService {

    @Autowired
    private UserAddressRepository addressRepository;
    @Autowired private UserRepository userRepository;

    public boolean userHasAddress(String email) {
        // Checks if a non-deleted address exists for this email
        return addressRepository.existsByUserEmailAndIsDeletedFalse(email);
    }

    @Transactional
    public UserAddress saveForUser(String email, UserAddress address) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        // Set the relationship and metadata automatically
        address.setUser(user);
        address.setIsDeleted(false);
        address.setCreatedDate(new Date());
        address.setUpdatedDate(new Date());

        // Save and return the instance that contains the generated ID
        return addressRepository.save(address);
    }

    public UserAddress getLatestAddressForUser(String email) {
        return addressRepository.findTopByUserEmailAndIsDeletedFalseOrderByCreatedDateDesc(email)
                .orElseThrow(() -> new ResourceNotFoundException("No address found for user: " + email));
    }

	public List<UserAddress> getAllAddressForUser(String email) {
		return addressRepository.findAllByUserEmailAndIsDeletedFalseOrderByCreatedDateDesc(email);
		
	}


}