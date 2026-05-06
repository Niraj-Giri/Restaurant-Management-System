package com.cskaa.restaurant.controller;

import com.cskaa.restaurant.data.CartRequest;
import com.cskaa.restaurant.data.CartResponseDTO;
import com.cskaa.restaurant.data.CouponDTO;
import com.cskaa.restaurant.exception.BadRequestException;
import com.cskaa.restaurant.model.Coupon;
import com.cskaa.restaurant.repository.CouponRepository;
import com.cskaa.restaurant.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.security.Principal;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @Autowired
    private CouponRepository couponRepository;
    @GetMapping
    public ResponseEntity<?> getCart(@RequestParam(required = false) String guestId, Principal principal) {
        try {
            String identity = (principal != null) ? principal.getName() : null;
            CartResponseDTO cart = cartService.getCartDTO(identity, guestId);
            return ResponseEntity.ok(cart);
        } catch (Exception e) {
            // CRITICAL: Catch the block exception and return 403
            if (e.getMessage() != null && e.getMessage().contains("Access Restricted")) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("error", e.getMessage()));
            }
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", "Server Error"));
        }
    }

    @PostMapping("/add")
    public ResponseEntity<?> addToCart(@Valid @RequestBody CartRequest request, Principal principal) {
        try {
            // Principal is null for guest users
            String email = (principal != null) ? principal.getName() : null;

            // Pass clean types directly from the DTO
            return ResponseEntity.ok(cartService.addItemToCart(
                    email,
                    request.getGuestId(),
                    request.getProductId(),
                    request.getQuantity()
            ));
        } catch (Exception e) {
            // Return structured JSON error
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @PutMapping("/update/{itemId}")
    public ResponseEntity<CartResponseDTO> updateQuantity(@PathVariable Long itemId, @RequestParam int change,
                                                          @RequestParam(required = false) String guestId, Principal principal) {
        String email = (principal != null) ? principal.getName() : null;
        return ResponseEntity.ok(cartService.updateItemQuantity(email, guestId, itemId, change));
    }

    @DeleteMapping("/clear")
    public ResponseEntity<CartResponseDTO> clearCart(@RequestParam(required = false) String guestId, Principal principal) {
        String email = (principal != null) ? principal.getName() : null;
        return ResponseEntity.ok(cartService.clearCart(email, guestId));
    }

    @PostMapping("/merge")
    public ResponseEntity<?> mergeCart(@RequestParam String guestId, Principal principal) {
        try {
            cartService.mergeGuestCartToUser(guestId, principal.getName());
            return ResponseEntity.ok().body(Map.of("message", "Cart merged successfully"));
        } catch (Exception e) {
            // If the error is our Blocked User exception, send a 403 Forbidden
            if (e.getMessage() != null && e.getMessage().contains("Access Restricted")) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("error", e.getMessage()));
            }

            // For all other actual crashes, send the 500 Server Error
            e.printStackTrace(); // Helpful for debugging other issues
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", e.getMessage()));
        }
    }


    @GetMapping("/available")
    public ResponseEntity<List<CouponDTO>> getAllAvailableCoupons() {
        return ResponseEntity.ok(couponRepository.findAll().stream().map(c -> {
            CouponDTO d = new CouponDTO();
            d.setCouponCode(c.getCouponCode());
            d.setCouponValue(c.getCouponValue());
            d.setCouponType(c.getCouponType().toString());
            d.setMinimumOrderAmount(c.getMinimumOrderAmount());
            return d;
        }).collect(Collectors.toList()));
    }
}
