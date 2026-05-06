package com.cskaa.restaurant.controller;

import com.cskaa.restaurant.exception.ResourceNotFoundException;
import com.cskaa.restaurant.model.Order;
import com.cskaa.restaurant.model.UserAddress;
import com.cskaa.restaurant.repository.OrderRepository;
import com.cskaa.restaurant.service.OrderService;
import com.cskaa.restaurant.service.UserAddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/user/address")
public class UserAddressController {

    @Autowired
    private UserAddressService addressService;
    @Autowired
    private OrderRepository orderRepository;
    @GetMapping("/exists")
    public ResponseEntity<Boolean> checkAddress(Principal principal) {
        // Returns true if user has an address record
        return ResponseEntity.ok(addressService.userHasAddress(principal.getName()));
    }

    @PostMapping("/save")
    public ResponseEntity<UserAddress> saveAddress(@RequestBody UserAddress address, Principal principal) {
        // This will now return the full UserAddress object including the ID
        UserAddress savedAddress = addressService.saveForUser(principal.getName(), address);
        return ResponseEntity.ok(savedAddress);
    }
    @GetMapping("/get-latest")
    public ResponseEntity<UserAddress> getLatestAddress(Principal principal) {
        // Service should find the most recent non-deleted address for this user
        return ResponseEntity.ok(addressService.getLatestAddressForUser(principal.getName()));
    }

    @GetMapping("/{orderId}/delivery-address")
    public ResponseEntity<UserAddress> getOrderDeliveryAddress(@PathVariable Long orderId) {
        // 1. Fetch the order from the database
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order not found with id: " + orderId));

        // 2. Return the mapped delivery address
        UserAddress address = order.getDeliveryAddress();

        if (address == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        return ResponseEntity.ok(address);
    }
    @GetMapping("/all")
    public ResponseEntity<List<UserAddress>> getAllAddress(Principal principal) {
        // Service should find the most recent non-deleted address for this user
        return ResponseEntity.ok(addressService.getAllAddressForUser(principal.getName()));
    }
}