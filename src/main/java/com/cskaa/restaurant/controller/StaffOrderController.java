package com.cskaa.restaurant.controller;

import com.cskaa.restaurant.data.OrderStatus;
import com.cskaa.restaurant.exception.ResourceNotFoundException;
import com.cskaa.restaurant.model.*;
import com.cskaa.restaurant.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/staff")
public class StaffOrderController {

    @Autowired
    private OrderTrackingRepository trackingRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private RestaurantStaffRepository restaurantStaffRepository;
    // 1. Get Active Assignments (Assigned or In Route)
    // Inside StaffOrderController.java

    @GetMapping("/my-assigned-orders")
    public ResponseEntity<?> getMyAssignedOrders(Principal principal) {
        // 1. Find the User
        User staff = userRepository.findByEmail(principal.getName())
                .orElseThrow(() -> new ResourceNotFoundException("user not found with email: " + principal.getName()));

        // 2. verify which restaurant they belong to (using your restaurant_staff table)
        RestaurantStaff employment = restaurantStaffRepository.findByStaff(staff)
                .orElseThrow(() -> new ResourceNotFoundException("Staff not linked to a restaurant"));

        Long myRestaurantId = employment.getRestaurant().getId();

        // 3. Only fetch tracking for their specific assignments
        List<OrderTracking> activeTasks = trackingRepository.findByStaffAndDeliveredFalseOrderByCreatedAtDesc(staff);

        return ResponseEntity.ok(activeTasks);
    }

    // 2. Get Past Deliveries
    @GetMapping("/my-delivered-orders")
    public ResponseEntity<?> getMyDeliveredOrders(Principal principal) {
        User staff = userRepository.findByEmail(principal.getName())
                .orElseThrow(() -> new ResourceNotFoundException("user not found with email: " + principal.getName()));
        List<OrderTracking> history = trackingRepository.findByStaffAndDeliveredTrue(staff);
        return ResponseEntity.ok(history);
    }

    // 3. Start Trip (Update tripStarted = true)
    @PutMapping("/orders/{orderId}/start-trip")
    public ResponseEntity<?> startTrip(@PathVariable Long orderId, Principal principal) {
        OrderTracking tracking = trackingRepository.findByOrderId(orderId)
                .orElseThrow(() -> new RuntimeException("Tracking record not found"));

        // Security check: Is this the assigned staff?
        if (!tracking.getStaff().getEmail().equals(principal.getName())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Not assigned to you");
        }

        tracking.setTripStarted(true);
        trackingRepository.save(tracking);

        // Update main order status
        Order order = tracking.getOrder();
        order.setStatus(OrderStatus.IN_ROUTE);
        orderRepository.save(order);

        return ResponseEntity.ok("Trip started successfully");
    }

    // 4. Deliver Order (OTP Verification)
    @PostMapping("/orders/{orderId}/complete-delivery")
    public ResponseEntity<?> completeDelivery(@PathVariable Long orderId, @RequestBody Map<String, String> payload, Principal principal) {
        String inputOtp = payload.get("otp");

        OrderTracking tracking = trackingRepository.findByOrderId(orderId)
                .orElseThrow(() -> new RuntimeException("Tracking record not found"));

        if (!tracking.getStaff().getEmail().equals(principal.getName())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Not assigned to you");
        }

        Order order = tracking.getOrder();

        // OTP Match Check
        if (order.getOtp() != null && order.getOtp().equals(inputOtp)) {
            // Update Tracking
            tracking.setDelivered(true);
            trackingRepository.save(tracking);

            // Update Order
            order.setStatus(OrderStatus.DELIVERED);
            order.setStatus(OrderStatus.RECEIVED);
            orderRepository.save(order);

            return ResponseEntity.ok("Order delivered successfully");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid OTP. Delivery not confirmed.");
        }
    }
    @GetMapping("/my-restaurant")
    public ResponseEntity<Restaurant> getMyRestaurant(Principal principal) {
        // 1. Identify the logged-in staff user
        User staff = userRepository.findByEmail(principal.getName())
                .orElseThrow(() -> new ResourceNotFoundException("user not found with email: " + principal.getName()));
        // 2. Find their restaurant link
        return ResponseEntity.ok(restaurantStaffRepository.findRestaurantByStaff(staff)
                .orElseThrow(() -> new ResourceNotFoundException("Restaurant not found" )));
    }

}