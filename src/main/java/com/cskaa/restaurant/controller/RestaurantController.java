package com.cskaa.restaurant.controller;

import com.cskaa.restaurant.data.*;
import com.cskaa.restaurant.exception.BadRequestException;
import com.cskaa.restaurant.exception.ResourceNotFoundException;
import com.cskaa.restaurant.model.*;
import com.cskaa.restaurant.repository.ProductRepository;
import com.cskaa.restaurant.repository.RestaurantRepository;
import com.cskaa.restaurant.repository.RestaurantStaffRepository;
import com.cskaa.restaurant.repository.UserRepository;
import com.cskaa.restaurant.service.RestaurantService;
import com.cskaa.restaurant.service.UserService;

import lombok.extern.slf4j.Slf4j;

import org.springframework.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.security.Principal;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/restaurants")
public class RestaurantController {

    @Autowired
    private RestaurantService restaurantService;

    @Autowired
    private UserService userService;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private RestaurantRepository restaurantRepository;
    @Autowired
    private ProductRepository productRepository;
    @Autowired
    private RestaurantStaffRepository restaurantStaffRepository;
    // Update this line in your RestaurantController
    @GetMapping("/{id:[0-9]+}")
    public ResponseEntity<?> getRestaurantById(@PathVariable Long id, Principal principal) {
        // SECURITY CHECK: If logged in, check if blocked
        if (principal != null) {
            User user = userService.findByUsername(principal.getName());
            if (restaurantService.isUserBlocked(id, user.getId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(Map.of("error", "Access Restricted: You are blocked by this restaurant."));
            }
        }
        return ResponseEntity.ok(restaurantService.getRestaurantById(id));
    }

    // --- GET all restaurants (paginated) ---
    @GetMapping("/all")
    public ResponseEntity<Page<Restaurant>> getAllRestaurants(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "6") int size,
            Principal principal) { // Add Principal here

        String email = principal != null ? principal.getName() : null;
        return ResponseEntity.ok(restaurantService.getAllAvailableRestaurants(page, size, email));
    }

    // --- GET meals by restaurant (paginated) ---
    // --- UPDATE THIS METHOD IN RestaurantController.java ---
    @GetMapping("/{resId}/meals")
    public ResponseEntity<?> getMealsByRestaurant(
            @PathVariable Long resId,
            @org.springframework.data.web.PageableDefault(size = 6) org.springframework.data.domain.Pageable pageable,
            Principal principal) {

        // SECURITY CHECK: Prevent fetching meals if blocked
        if (principal != null) {
            User user = userService.findByUsername(principal.getName());
            if (restaurantService.isUserBlocked(resId, user.getId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(Map.of("error", "Access Restricted: You are blocked by this restaurant."));
            }
        }

        // Pass the entire pageable object (which contains the sort) to the service
        return ResponseEntity.ok(restaurantService.getProductsByRestaurantId(resId, pageable));
    }

    @GetMapping("/my-restaurant")
    public ResponseEntity<?> getMyRestaurant(Principal principal, @RequestParam(required = false) Long restaurantId) {
        User user = userService.findByUsername(principal.getName());

        // If no ID is passed, you might want to fetch the first one or return an error
        if (restaurantId == null) {
            return ResponseEntity.badRequest().body("Restaurant ID is required");
        }

        // Fetch specific restaurant ensuring it belongs to this owner
        return restaurantRepository.findByIdAndOwnerIdAndIsDeletedFalse(restaurantId, user.getId())
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND).build());
    }

    @GetMapping("/my-all-restaurants")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    public ResponseEntity<List<Restaurant>> getMyAllRestaurants(Principal principal) {
        log.info("Fetching all restaurants for owner: {}", principal.getName());

        // 1. Get user from principal
        User owner = userService.findByUsername(principal.getName());

        // 2. Fetch list of restaurants belonging to this owner
        // Make sure your RestaurantRepository has: List<Restaurant> findByOwnerId(Long ownerId);
        List<Restaurant> restaurants = restaurantRepository.findByOwnerId(owner.getId());

        return ResponseEntity.ok(restaurants);
    }

    @GetMapping("/{resId}/staff")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    public ResponseEntity<?> getRestaurantStaff(@PathVariable Long resId, Principal principal) {
        try {
            List<RestaurantStaff> staffList = restaurantService.getStaffByRestaurantId(resId, principal.getName());
            return ResponseEntity.ok(staffList);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        }
    }

    @PostMapping("/block-user")
	@PreAuthorize("hasAnyRole('ADMIN','RESTAURANT_OWNER')")
    public ResponseEntity<?> blockUser(
            @RequestBody BlockUserRequest request,
            Principal principal) { 

        User owner = userService.findByUsername(principal.getName());
       
        User customer = userService.findById( request.getUserId());
        if(customer==null) throw new ResourceNotFoundException("User",request.getUserId());
        if(customer.getRole()!= Role.CUSTOMER) throw new ResourceNotFoundException("Customer",request.getUserId());
        
       
    	Restaurant restaurant=null;
        if (owner.getRole()==Role.ADMIN) {
        // Verification check using the DTO fields
        	restaurant = restaurantRepository.findById(request.getRestaurantId())
        			.orElseThrow(() -> new ResourceNotFoundException("Restaurant",request.getRestaurantId()));
        }
        else {
        	restaurant = restaurantRepository.findByIdAndOwnerIdAndIsDeletedFalse(
                    request.getRestaurantId(), owner.getId())
            .orElseThrow(() -> new ResourceNotFoundException("Restaurant",request.getRestaurantId()));
        	
        }
        // CRITICAL: Pass restaurant.getId(), NOT owner.getId()
        restaurantService.blockUser(
                restaurant.getId(),
                request.getUserId(),
                request.getReason()
        );

        return ResponseEntity.ok().build();
    }

    @GetMapping("/is-user-blocked")
	@PreAuthorize("hasAnyRole('ADMIN','RESTAURANT_OWNER')")
    public ResponseEntity<Boolean> isUserBlocked(
            @RequestParam Long userId,
            @RequestParam Long restaurantId,
            Principal principal) {

        User owner = userService.findByUsername(principal.getName());
        Restaurant restaurant=null;
        if (owner.getRole()==Role.ADMIN) {
        	restaurant = restaurantRepository.findById(restaurantId)
        			.orElseThrow(() -> new ResourceNotFoundException("Restaurant",restaurantId));
        }
        else {
        	restaurant = restaurantService.findRestaurantByOwnerId(owner.getId(), restaurantId);
        }
        // Check the customer (userId) against the branch
        boolean blocked = restaurantService.isUserBlocked(restaurant.getId(), userId);

        return ResponseEntity.ok(blocked);
    }
    @PostMapping("/unblock-user")
	@PreAuthorize("hasAnyRole('ADMIN','RESTAURANT_OWNER')")
    public ResponseEntity<?> unblockUser(
            @RequestBody UnblockUserRequest request, // Use the DTO instead of a Map
            Principal principal) {

        try {
            User owner = userService.findByUsername(principal.getName());
            User customer = userService.findById( request.getUserId());
            if(customer==null) throw new ResourceNotFoundException("User",request.getUserId());
            if(customer.getRole()!= Role.CUSTOMER) throw new ResourceNotFoundException("Customer",request.getUserId());
          
                       
            Restaurant restaurant=null;
            if (owner.getRole()==Role.ADMIN) {
            // Verification check using the DTO fields
            	restaurant = restaurantRepository.findById(request.getRestaurantId())
            			.orElseThrow(() -> new ResourceNotFoundException("Restaurant",request.getRestaurantId()));
            }
            else {
            	restaurant = restaurantRepository.findByIdAndOwnerIdAndIsDeletedFalse(
                        request.getRestaurantId(), owner.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Restaurant",request.getRestaurantId()));
            	
            }
            
            // Change status from '1' to '0'
            restaurantService.unblockUser(restaurant.getId(), request.getUserId());

            return ResponseEntity.ok(Map.of("message", "User unblocked successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
   
    /*@PostMapping("/add")
    public ResponseEntity<?> addNewRestaurant(Principal principal, @RequestBody RestaurantRegistrationRequest request) {
        try {
            // 1. Get the current logged-in user
            User owner = userService.findByUsername(principal.getName());

            // 2. Create and populate the Restaurant entity
            Restaurant restaurant = new Restaurant();
            restaurant.setName(request.getRestaurantName());
            restaurant.setDescription(request.getRestaurantDescription());
            restaurant.setOwner(owner);

            // 3. Save to database
            restaurantRepository.save(restaurant);

            log.info("New restaurant '{}' created by owner: {}", request.getRestaurantName(), principal.getName());

            return ResponseEntity.ok(Map.of("message", "Restaurant created successfully!"));
        } catch (Exception e) {
            log.error("Error creating restaurant: ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "Could not create restaurant: " + e.getMessage()));
        }
    }*/
    
    @PostMapping("/add")
	@PreAuthorize("hasAnyRole('ADMIN','RESTAURANT_OWNER')")
	public Restaurant registerRestaurant(@RequestBody RestaurantRequest request, Authentication authentication) {
	    
	    String currentUserEmail = authentication.getName();
	    User currentUser = userService.findByUsername(currentUserEmail);
	    if (currentUser == null) throw new ResourceNotFoundException("User", currentUserEmail);

	    // Create restaurant from request DTO (NEVER trust client-sent owner)
	    Restaurant restaurant = new Restaurant();
	    restaurant.setName(request.getName());
	    restaurant.setDescription(request.getDescription());
	    
	    // CRITICAL FIX: Proper owner assignment logic
	    if (currentUser.getRole()==Role.ADMIN) {
	        // Admin can assign ANY restaurant owner (must specify in request)
	        if (request.getOwnerEmail() == null || request.getOwnerEmail().isBlank()) {
	            throw new BadRequestException("Admin must specify ownerEmail when creating restaurant");
	        }
	        
	        User designatedOwner = userService.findByEmail(request.getOwnerEmail());
	        if (designatedOwner == null) {
	            throw new ResourceNotFoundException("Owner user", request.getOwnerEmail());
	        }
	        if (!(designatedOwner.getRole()==Role.RESTAURANT_OWNER)) {
	            throw new BadRequestException("Specified user is not a restaurant owner");
	        }
	        restaurant.setOwner(designatedOwner);
	        
	    } else {
	        // Restaurant owners can ONLY create restaurants for themselves
	        if ( StringUtils.hasText(request.getOwnerEmail()) && !request.getOwnerEmail().equals(currentUserEmail)) {
	            throw new AccessDeniedException("Restaurant owners can only create restaurants for themselves");
	        }
	        restaurant.setOwner(currentUser);
	    }

	    log.info("Creating restaurant: {} for owner: {}", restaurant.getName(), restaurant.getOwner().getEmail());
	    return restaurantService.saveRestaurant(restaurant);
	}

    @PostMapping("/add/menu")
    @PreAuthorize("hasAnyRole('ADMIN','RESTAURANT_OWNER')")
    public ResponseEntity<?> addMenu(@Valid @RequestBody MenuRequest request, Principal principal) {
        try {
            Restaurant restaurant = restaurantRepository.findById(request.getRestaurantId())
                    .orElseThrow(() -> new ResourceNotFoundException("Restaurant", request.getRestaurantId()));

            User user = userService.findByUsername(principal.getName());
            if (user.getRole() == Role.RESTAURANT_OWNER && !restaurant.getOwner().getId().equals(user.getId())) {
                // This is the specific security exception
                throw new AccessDeniedException("You can only add items to your own restaurant.");
            }

            Product product = new Product();
            product.setName(request.getName());
            product.setDescription(request.getDescription());
            product.setPrice(request.getPrice());
            product.setRestaurant(restaurant);
            product.setDeleted(false);

            productRepository.save(product);
            return ResponseEntity.ok(Map.of("message", "Product added successfully"));

        } catch (AccessDeniedException e) {
            // Return 403 Forbidden for security issues
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Error: " + e.getMessage());
        } catch (Exception e) {
            // Return 400 Bad Request for everything else (like "Restaurant not found")
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }
    @DeleteMapping("/menu/{productId}")
    @PreAuthorize("hasAnyRole('ADMIN','RESTAURANT_OWNER')")
    public ResponseEntity<?> deleteMenu(@PathVariable Long productId, Principal principal) {
        try {
            // 1. Fetch the product/menu item
            Product product = productRepository.findById(productId)
                    .orElseThrow(() -> new ResourceNotFoundException("Product", productId));

            // 2. Security Check
            User user = userService.findByUsername(principal.getName());
            log.info("Logged In User ID: {}-{}-{}", user.getId(),user.getEmail());
            // If user is an Owner, check if they actually own the restaurant this product belongs to
            if (user.getRole() == Role.RESTAURANT_OWNER) {
                Restaurant restaurant = product.getRestaurant();
                log.info("Restaurant User ID: {}-{}",restaurant.getOwner().getId(),restaurant.getOwner().getId().equals(user.getId()));
                if (restaurant == null || !restaurant.getOwner().getId().equals(user.getId())) {
                    throw new AccessDeniedException("You can only delete items from your own restaurant.");
                }
            }

            product.setDeleted(true);
            productRepository.save(product);
            
            log.info("Product ID: {} deleted by {}", productId, principal.getName());
            return ResponseEntity.ok(Map.of("message", "Menu item deleted successfully"));

        } catch (ResourceNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (AccessDeniedException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error deleting product: " + e.getMessage());
        }
    }
    // 1. Fetch a single menu item by its ID (for populating the Edit form)
    @GetMapping("/menu/{productId}")
    @PreAuthorize("hasAnyRole('ADMIN','RESTAURANT_OWNER')")
    public ResponseEntity<Product> getMenuItemById(@PathVariable Long productId) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("Product", productId));
        return ResponseEntity.ok(product);
    }

    // 2. Update an existing menu item
    @PutMapping("/menu/{productId}")
    @PreAuthorize("hasAnyRole('ADMIN','RESTAURANT_OWNER')")
    public ResponseEntity<?> updateMenu(@PathVariable Long productId, @Valid @RequestBody MenuRequest request, Principal principal) {

        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("Product", productId));

        // Security Check: Ensure owner isn't editing someone else's menu
        User user = userService.findByUsername(principal.getName());
        if (user.getRole() == Role.RESTAURANT_OWNER && !product.getRestaurant().getOwner().getId().equals(user.getId())) {
            throw new AccessDeniedException("Unauthorized update.");
        }

        product.setName(request.getName());
        product.setDescription(request.getDescription());
        product.setPrice(request.getPrice());

        // Update the restaurant link if changed in the dropdown
        Restaurant restaurant = restaurantRepository.findById(request.getRestaurantId())
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        product.setRestaurant(restaurant);

        productRepository.save(product);
        return ResponseEntity.ok(Map.of("message", "Product updated successfully"));
    }

    @PostMapping("/register-staff")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    public ResponseEntity<?> registerAndAddStaff(
            Principal principal,
            @RequestBody RegisterStaffRequest request) {

        try {
            // 1. Get Owner & Verify Restaurant Ownership
            User owner = userService.findByUsername(principal.getName());
            Restaurant restaurant = restaurantRepository.findByIdAndOwnerIdAndIsDeletedFalse(
                            request.getRestaurantId(), owner.getId())
                    .orElseThrow(() -> new RuntimeException("Unauthorized: You don't own this branch."));

            // 2. Check if Email is already taken
            if (userRepository.existsByEmail(request.getEmail())) {
                return ResponseEntity.badRequest().body("Error: Email is already registered in the system.");
            }

            // 3. Create the New User (Staff Member)
            User newStaff = new User();
            newStaff.setFirstName(request.getFirstName());
            newStaff.setLastName(request.getLastName());
            newStaff.setEmail(request.getEmail());
            newStaff.setPassword(request.getPassword()); // Consider encoding this!
            newStaff.setMobileNumber(request.getMobileNumber());
            newStaff.setRole(Role.RESTAURANT_STAFF); // Explicitly set role

            userRepository.save(newStaff);

            // 4. Map the New User to the Restaurant
            RestaurantStaff mapping = new RestaurantStaff();
            mapping.setRestaurant(restaurant);
            mapping.setStaff(newStaff);

            restaurantStaffRepository.save(mapping);

            return ResponseEntity.ok(Map.of("message", "Staff account created and assigned successfully!"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
    @GetMapping("/{resId}/customers")
    @PreAuthorize("hasAnyRole('ADMIN','RESTAURANT_OWNER')")
    public ResponseEntity<List<User>> getRestaurantCustomers(@PathVariable Long resId) {
        List<User> customers = restaurantService.getUniqueCustomersByRestaurant(resId);
        return ResponseEntity.ok(customers);
    }
    
 // UPDATE
 @PutMapping("/restaurant/{id}")
 @PreAuthorize("hasAnyRole('ADMIN','RESTAURANT_OWNER')")
 public ResponseEntity<?> update(@PathVariable Long id, @RequestBody RestaurantRequest request) {

     Authentication auth = SecurityContextHolder.getContext().getAuthentication();
     String username = auth.getName();

     // 1. Fetch the EXISTING record from the DB (Managed Entity)
     Restaurant existing = restaurantService.getRestaurantById(id);

     // 2. Perform Security Checks
     boolean isAdmin = auth.getAuthorities().stream()
             .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

     boolean isOwner = existing.getOwner() != null &&
             existing.getOwner().getEmail().equals(username);

     if (!isAdmin && !isOwner) {
         throw new AccessDeniedException("You can update only your own restaurant");
     }

     // 3. Map values from DTO to the Managed Entity
     existing.setName(request.getName());
     existing.setDescription(request.getDescription());

     // 4. Handle Owner Change (Only if Admin)
     if (isAdmin && request.getOwnerEmail() != null) {
         User newOwner = userService.findByEmail(request.getOwnerEmail());
         if (newOwner == null) {
             return ResponseEntity.status(HttpStatus.NOT_FOUND)
                     .body("Owner not found with email: " + request.getOwnerEmail());
         }
         existing.setOwner(newOwner);
     }

     // 5. Save the updated managed entity
     Restaurant updated = restaurantService.saveRestaurant(existing);
     return ResponseEntity.ok(updated);
 }

 	// DELETE
 	@DeleteMapping("/restaurant/{id}")
 	@PreAuthorize("hasAnyRole('ADMIN','RESTAURANT_OWNER')")
 	public ResponseEntity<Void> delete(@PathVariable Long id) {
 		
 		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
 	    String username = auth.getName();

 	    Restaurant existing = restaurantService.getRestaurantById(id);

 	    boolean isAdmin = auth.getAuthorities().stream()
 	            .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

 	    boolean isOwner = existing.getOwner() != null &&
 	            existing.getOwner().getEmail().equals(username);

 	    if (!isAdmin && !isOwner) {
 	        throw new AccessDeniedException("You can delete only your own restaurant");
 	    }

 		//TODO: for production : chk for child items before deletion
 		restaurantService.delete(id);
 		return ResponseEntity.noContent().build();
 	}
    // 1. Delete mapping (Remove staff from branch)
    @DeleteMapping("/staff/{mappingId}")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    public ResponseEntity<?> removeStaff(@PathVariable Long mappingId) {
        restaurantStaffRepository.deleteById(mappingId);
        return ResponseEntity.ok(Map.of("message", "Staff removed from branch"));
    }

    // 2. Update existing staff user details
    @PutMapping("/staff-user/{id}")
    @PreAuthorize("hasRole('RESTAURANT_OWNER')")
    public ResponseEntity<?> updateStaffDetails(@PathVariable Long id, @RequestBody User updatedStaff) {
        return userRepository.findById(id).map(user -> {
            user.setFirstName(updatedStaff.getFirstName());
            user.setLastName(updatedStaff.getLastName());
            user.setMobileNumber(updatedStaff.getMobileNumber());
            user.setEmail(updatedStaff.getEmail());
            if(updatedStaff.getPassword() != null && !updatedStaff.getPassword().isEmpty()){
                user.setPassword(updatedStaff.getPassword());
            }
            userRepository.save(user);
            return ResponseEntity.ok(Map.of("message", "Staff details updated"));
        }).orElse(ResponseEntity.notFound().build());
    }
    @GetMapping("/staff-user/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','RESTAURANT_OWNER')")
    public ResponseEntity<User> getStaffUserById(@PathVariable Long id, Principal principal) {
        // Optional: Add security check to ensure this user is actually staff at the owner's restaurant
        return userRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


}