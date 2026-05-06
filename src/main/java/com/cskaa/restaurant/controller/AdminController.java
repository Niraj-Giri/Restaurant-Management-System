package com.cskaa.restaurant.controller;
import com.cskaa.restaurant.data.Role;
import com.cskaa.restaurant.exception.ResourceNotFoundException;
import com.cskaa.restaurant.model.Coupon;
import com.cskaa.restaurant.model.User;
import com.cskaa.restaurant.repository.CouponRepository;
import com.cskaa.restaurant.repository.UserRepository;
import com.cskaa.restaurant.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserService userService;
    @Autowired
    private CouponRepository couponRepository;


    @GetMapping("/restaurant/owners")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<User>> getOnlyOwners() {

        return ResponseEntity.ok(userRepository.findByRole(Role.RESTAURANT_OWNER));
    }
    @GetMapping("/users/all")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<User>> getAllCustomersForAdmin() {
        // We only want users who have the role 'CUSTOMER'
        List<User> customers = userService.findUsersByRole(Role.CUSTOMER);
        return ResponseEntity.ok(customers);
    }
    @PostMapping("/coupons/add")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> addCoupon(@RequestBody Coupon coupon) {
        try {
            // Ensure the code is uppercase for consistency
            coupon.setCouponCode(coupon.getCouponCode().toUpperCase());
            coupon.setCouponType(coupon.getCouponType());
            coupon.setCouponValue(coupon.getCouponValue());
            coupon.setMinimumOrderAmount(coupon.getMinimumOrderAmount());
            coupon.setDeleted(false);

            couponRepository.save(coupon);
            return ResponseEntity.ok(Map.of("message", "Coupon created successfully!"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Error: Coupon code might already exist.");
        }
    }
    // 1. Get List of Staff/Owners
    @GetMapping("/internal-users")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<User>> getInternalUsers() {
        return ResponseEntity.ok(userService.findInternalUsers());
    }

    // 2. Get Single User
    @GetMapping("/user/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        return userRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // 3. Update User Details
    @PutMapping("/user/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> updateInternalUser(@PathVariable Long id, @RequestBody User updatedUser) {
        return userRepository.findById(id).map(user -> {
            user.setFirstName(updatedUser.getFirstName());
            user.setLastName(updatedUser.getLastName());
            user.setRole(updatedUser.getRole());

            if (updatedUser.getPassword() != null && !updatedUser.getPassword().isEmpty()) {

                user.setPassword(updatedUser.getPassword());
            }

            userRepository.save(user);
            return ResponseEntity.ok(Map.of("message", "User updated successfully"));
        }).orElse(ResponseEntity.notFound().build());
    }
    @DeleteMapping("/user/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        try {
            // 1. Fetch the TARGET user (the one to be deleted)
            User targetUser = userRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));

            // 2. Security Check: Prevent Admin from deleting themselves
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String currentUsername = auth.getName();

            if (targetUser.getEmail().equals(currentUsername)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Map.of("message", "Security Violation: You cannot delete your own account"));
            }

            // 3. Perform Soft Delete on the TARGET user
            targetUser.setDeleted(true);
            userRepository.save(targetUser);

            return ResponseEntity.ok(Map.of("message", "User " + targetUser.getEmail() + " has been deactivated successfully"));

        } catch (ResourceNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "An error occurred while deactivating the user."));
        }
    }

    @GetMapping("/coupons/all")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<Coupon>> getAllCoupons() {
        return ResponseEntity.ok(couponRepository.findAll());
    }

    // 2. Get single coupon
    @GetMapping("/coupons/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Coupon> getCouponById(@PathVariable Long id) {
        return couponRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // 3. Update existing coupon
    @PutMapping("/coupons/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> updateCoupon(@PathVariable Long id, @RequestBody Coupon updatedCoupon) {
        return couponRepository.findById(id).map(coupon -> {
            coupon.setCouponCode(updatedCoupon.getCouponCode().toUpperCase());
            coupon.setCouponType(updatedCoupon.getCouponType());
            coupon.setCouponValue(updatedCoupon.getCouponValue());
            coupon.setMinimumOrderAmount(updatedCoupon.getMinimumOrderAmount());
            couponRepository.save(coupon);
            return ResponseEntity.ok(Map.of("message", "Coupon updated successfully!"));
        }).orElse(ResponseEntity.notFound().build());
    }

    // 4. Delete coupon
    @DeleteMapping("/coupons/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteCoupon(@PathVariable Long id) {
        couponRepository.deleteById(id);
        return ResponseEntity.ok().build();
    }
}

