package com.cskaa.restaurant.controller;

import com.cskaa.restaurant.data.OrderRequest;
import com.cskaa.restaurant.data.OrderStatus;
import com.cskaa.restaurant.exception.ResourceNotFoundException;
import com.cskaa.restaurant.model.Order;
import com.cskaa.restaurant.model.OrderTracking;
import com.cskaa.restaurant.model.Restaurant;
import com.cskaa.restaurant.model.User;
import com.cskaa.restaurant.repository.OrderTrackingRepository;
import com.cskaa.restaurant.repository.RestaurantRepository;
import com.cskaa.restaurant.repository.RestaurantStaffRepository;
import com.cskaa.restaurant.repository.UserRepository;
import com.cskaa.restaurant.service.OrderService;
import com.cskaa.restaurant.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private RestaurantRepository restaurantRepository;
    @Autowired
    private OrderTrackingRepository orderTrackingRepository;
    @Autowired
    private RestaurantStaffRepository restaurantStaffRepository;
    @Autowired
    private UserService userService;

    @PostMapping("/place")
    public ResponseEntity<Order> placeOrder(@RequestBody OrderRequest request, Principal principal) {
        // 1. No try-catch needed here!
        // 2. Use your custom ResourceNotFoundException
        User user = userRepository.findByEmail(principal.getName())
                .orElseThrow(() -> new ResourceNotFoundException("User not found with email: " + principal.getName()));

        // 3. Let the service handle business logic.
        // If orderService.placeOrder throws an exception, GlobalExceptionHandler handles it.
        Order order = orderService.placeOrder(user, request);

        return ResponseEntity.ok(order);
    }
    @GetMapping("/{id}")
    public ResponseEntity<?> getOrderById(@PathVariable Long id, Principal principal) {
        // 1. Find the order first
        Order order = orderService.getOrderByOrderId(id);
        String loggedInEmail = principal.getName();

        // 2. Safely check if the logged-in user is the CUSTOMER
        boolean isCustomer = order.getCustomer() != null &&
                order.getCustomer().getEmail().equals(loggedInEmail);
         User user=userRepository.findByEmail(loggedInEmail)
                 .orElseThrow(() -> new ResourceNotFoundException("User not found with email: " + loggedInEmail));
        boolean isStaff = restaurantStaffRepository.existsByStaffAndRestaurant(user,order.getRestaurant());

        // 3. Safely check if the logged-in user is the RESTAURANT OWNER
        boolean isOwner = order.getRestaurant() != null &&
                order.getRestaurant().getOwner() != null &&
                order.getRestaurant().getOwner().getEmail().equals(loggedInEmail);

        // 4. SECURITY CHECK: If they are neither, block them!
        if (!isCustomer && !isOwner && !isStaff) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body("Access Denied: You are not authorized to view this order.");
        }

        // 5. Success! Return the order.
        return ResponseEntity.ok(order);
    }

    @GetMapping("/{orderId}/status")
    public ResponseEntity<OrderStatus> getOrderStatus(
            @PathVariable Long orderId,
            Principal principal) {

        String email = principal.getName();
        OrderStatus status = orderService.getOrderStatus(orderId,email);
        return ResponseEntity.ok(status);
    }

    @PutMapping("/{id}/cancel")
    public ResponseEntity<?> cancelOrder(@PathVariable Long id, Principal principal) {
        Order order = orderService.getOrderByOrderId(id);

        if (!order.getCustomer().getEmail().equals(principal.getName())) {
            return ResponseEntity.status(403).body("You do not have permission to cancel this order.");
        }

        // Updated Logic: Provide specific feedback based on status
        if (order.getStatus() != OrderStatus.PLACED) {
            String message = "Order cannot be cancelled. ";
            switch (order.getStatus()) {
                case PROCESSING: message += "The kitchen has already started preparing your food."; break;
                case IN_ROUTE: message += "Your order is already with the delivery partner."; break;
                case DELIVERED: case RECEIVED: message += "This order has already been completed."; break;
                case CANCELED: message += "This order is already cancelled."; break;
                default: message += "Status: " + order.getStatus();
            }
            return ResponseEntity.badRequest().body(message);
        }

        orderService.cancelOrder(order);
        return ResponseEntity.ok().body("Order # " + id + " has been successfully cancelled.");
    }
    @PutMapping("/{id}/status")
    public ResponseEntity<Order> updateOrderStatus(
            @PathVariable Long id,
            @RequestParam OrderStatus status,
            Principal principal) {

        // 1. Fetch the order
        Order order = orderService.getOrderByOrderId(id);

        // 2. Security Check: Does this order belong to a restaurant owned by this user?
        // This prevents one owner from changing another owner's order status.
        if (!order.getRestaurant().getOwner().getEmail().equals(principal.getName())) {
            return ResponseEntity.status(403).build();
        }

        // 3. Update the status via the service
        Order updatedOrder = orderService.updateOrderStatus(id, status);

        return ResponseEntity.ok(updatedOrder);
    }

    // --- Get orders for the logged-in user ---
    @GetMapping("/my-orders")
    public ResponseEntity<List<Order>> getMyOrders(
            @RequestParam(required = false) String date,
            Principal principal) {

        User user = userService.findByUsername(principal.getName());


        if (date != null && !date.isEmpty()) {
            try {
                LocalDate localDate = LocalDate.parse(date);
                return ResponseEntity.ok(orderService.getOrdersByUserAndDate(user, localDate));
            } catch (DateTimeParseException e) {
                return ResponseEntity.badRequest().build();
            }
        }

        return ResponseEntity.ok(orderService.getOrdersByUser(user));
    }
    @GetMapping("/today/{resId}")
    public ResponseEntity<List<Order>> getTodayOrders(@PathVariable Long resId) {
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = LocalDate.now().atTime(LocalTime.MAX);
        return ResponseEntity.ok(orderService.getTodayOrders(resId, startOfDay, endOfDay));
    }
    @GetMapping("/history/{resId}")
    public ResponseEntity<?> getRestaurantOrderHistory(@PathVariable Long resId, Principal principal) {

        // 1. Fetch the restaurant from the database
        Restaurant restaurant = restaurantRepository.findById(resId)
                .orElseThrow(() -> new ResourceNotFoundException("Restaurant not found"));

        // 2. SECURITY GUARD: Does the logged-in email match the restaurant owner's email?
        if (!restaurant.getOwner().getEmail().equals(principal.getName())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body("Access Denied: You do not have permission to view these orders.");
        }

        // 3. If the check passes, fetch and return the history
        List<Order> history = orderService.getAllOrdersForRestaurant(resId);
        return ResponseEntity.ok(history);
    }


    @PostMapping("/{id}/assign-delivery")
    public ResponseEntity<?> assignDeliveryAgent(@PathVariable Long id, @RequestParam Long staffId, Principal principal) {
        Order order = orderService.getOrderByOrderId(id);

        if (!order.getRestaurant().getOwner().getEmail().equals(principal.getName())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Access Denied");
        }

        User deliveryAgent = userRepository.findById(staffId)
                .orElseThrow(() -> new ResourceNotFoundException("Staff not found"));

        // 1. Generate 4-digit OTP
        int randomPin = 1000 + new java.util.Random().nextInt(9000);
        order.setOtp(String.valueOf(randomPin));

        // 2. Create the Tracking Record
        OrderTracking tracking = new OrderTracking();
        tracking.setOrder(order);
        tracking.setStaff(deliveryAgent);
        tracking.setTripStarted(false); // Rider hasn't moved yet
        tracking.setDelivered(false);
        orderTrackingRepository.save(tracking);

        // 3. FIX: Update status to ASSIGNED, not IN_ROUTE
        // This ensures the Owner sees "Awaiting Pickup" first.
        orderService.updateOrderStatus(id, OrderStatus.ASSIGNED);

        return ResponseEntity.ok("Order assigned to staff successfully!");
    }

    // Quick endpoint to get tracking details for the frontend
    @GetMapping("/{id}/tracking")
    public ResponseEntity<OrderTracking> getOrderTracking(@PathVariable Long id) {
        OrderTracking tracking = orderTrackingRepository.findByOrderId(id).orElse(null);
        return ResponseEntity.ok(tracking);
    }


}