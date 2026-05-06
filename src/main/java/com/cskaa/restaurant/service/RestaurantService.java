package com.cskaa.restaurant.service;
import com.cskaa.restaurant.exception.ResourceNotFoundException;
import com.cskaa.restaurant.model.*;
import com.cskaa.restaurant.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;


@Service
public class RestaurantService {

    @Autowired private RestaurantRepository restaurantRepository;
    @Autowired private ProductRepository productRepository;
    @Autowired private RestaurantStaffRepository restaurantStaffRepository;
    @Autowired private RestaurantBlockedUserRepository restaurantBlockedUserRepository;
    @Autowired private UserService userService;
    @Autowired
    private UserRepository userRepository;

    // --- Add Product directly to Restaurant (no category) ---
  
    public Product addProduct(Long restaurantId, Product product) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new ResourceNotFoundException("Restaurant not found with ID: " + restaurantId));

        product.setRestaurant(restaurant);
        return productRepository.save(product);
    }

    // --- Get all restaurants (paginated) ---
    public Page<Restaurant> getAllRestaurants(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return restaurantRepository.findAll(pageable);
    }

    // --- Get products by restaurant (paginated) ---
    public Page<Product> getProductsByRestaurantId(Long resId, Pageable pageable) {

        return productRepository.findActiveByRestaurantId(resId, pageable);
    }

    // --- Get single restaurant by ID ---
    public Restaurant getRestaurantById(Long id) {
        return restaurantRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Restaurant not found with ID: " + id));
    }
    
    
    public Restaurant saveRestaurant(Restaurant restaurant) {
		return restaurantRepository.save(restaurant);
	}
	

    public Restaurant update(Long id, Restaurant updated) {
    	Restaurant existing = restaurantRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Restaurant", id));

        existing.setName(updated.getName());
        existing.setDescription(updated.getDescription());

        return restaurantRepository.save(existing);
    }

    public void delete(Long id) {
    	restaurantRepository.deleteById(id);
    }




    public Restaurant findRestaurantByOwnerId(Long ownerId, Long restaurantId) {
        // Fix: Match the parameters to the correct repository fields
        Restaurant restaurant = restaurantRepository.findByIdAndOwnerIdAndIsDeletedFalse(restaurantId, ownerId)
                .orElseThrow(() -> new ResourceNotFoundException("Restaurant not found for this user with ID: " + ownerId));
        return restaurant;
    }

    public List<RestaurantStaff> getStaffByRestaurantId(Long resId, String ownerEmail) {
        // 1. Fetch the restaurant
        Restaurant restaurant = restaurantRepository.findById(resId)
                .orElseThrow(() -> new ResourceNotFoundException("Restaurant not found"));

        // 2. SECURITY CHECK: Ensure the requester actually owns this restaurant
        if (!restaurant.getOwner().getEmail().equals(ownerEmail)) {
            throw new RuntimeException("Access Denied: You do not own this restaurant.");
        }

        // 3. Return the staff list
        return restaurantStaffRepository.findByRestaurantId(resId);
    }

    @Transactional
    public void blockUser(Long resId, Long userId, String reason) {
        // Check if a record already exists (active or inactive)
        Optional<RestaurantBlockedUser> existing = restaurantBlockedUserRepository.findByRestaurantIdAndUserId(resId, userId);

        if (existing.isPresent()) {
            RestaurantBlockedUser block = existing.get();
            block.setActive(true); // Reactivate it
            block.setReason(reason);
            restaurantBlockedUserRepository.save(block);
        }else {
            // 3. Only create a new record if one doesn't exist at all
            Restaurant restaurant = restaurantRepository.getById(resId);
            User user = userRepository.getById(userId);

            RestaurantBlockedUser newBlock = RestaurantBlockedUser.builder()
                    .restaurant(restaurant)
                    .user(user)
                    .reason(reason)
                    .active(true)
                    .blockedAt(LocalDateTime.now())
                    .build();
            restaurantBlockedUserRepository.save(newBlock);
        }
    }




    public Page<Restaurant> getAllAvailableRestaurants(int page, int size, String email) {
        Pageable pageable = PageRequest.of(page, size);

        if (email != null) {
            User user = userRepository.findByEmail(email).orElse(null);
            if (user != null) {
                System.out.println("DEBUG: Fetching UNBLOCKED restaurants for user ID: " + user.getId());
                return restaurantRepository.findAllUnblockedForUser(user.getId(), pageable);
            }
        }

        System.out.println("DEBUG: Fetching ALL restaurants (Guest Mode)");
        return restaurantRepository.findAll(pageable);
    }

    public List<User> getUniqueCustomersByRestaurant(Long resId) {
//        log.info("Fetching unique customers for restaurant ID: {}", resId);

        // 1. Verify restaurant exists (optional but recommended)
        if (!restaurantRepository.existsById(resId)) {
            throw new ResourceNotFoundException("Restaurant not found with id: " + resId);
        }

        // 2. Fetch unique customers who have placed orders here
        return userRepository.findUniqueCustomersByRestaurantId(resId);
    }

    @Transactional
    public void unblockUser(Long resId, Long userId) {
        restaurantBlockedUserRepository.softUnblock(resId, userId, LocalDateTime.now());
    }

    public boolean isUserBlocked(Long resId, Long userId) {
        // Uses your repository method to check for ACTIVE blocks only
        return restaurantBlockedUserRepository.existsByRestaurantIdAndUserIdAndActiveTrue(resId, userId);
    }
}