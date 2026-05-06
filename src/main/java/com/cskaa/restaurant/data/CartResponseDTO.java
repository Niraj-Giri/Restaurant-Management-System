package com.cskaa.restaurant.data;

import lombok.Data;
import java.util.List;

@Data
public class CartResponseDTO {
    private Long cartId;

    // Financial Breakdown
    private Double subtotal;      // Sum of (price * quantity)
    private Double taxAmount;     // Based on your 9% tax rate
    private Double tipAmount;     // User-selected tip
    private Double discountAmount; // Value subtracted by coupon
    private Double grandTotal;    // Final amount to pay
    private Long restaurantId;
    private String restaurantName;
    // Coupon Information
    private String appliedCouponCode;
    private List<CartItemDTO> items;
    private List<CouponDTO> availableCoupons; // Coupons the user can pick from

    @Data
    public static class CartItemDTO {
        private Long id;
        private Long productId;
        private String name;
        private Double price;

        private Integer quantity;
    }

    @Data
    public static class CouponDTO {
        private String code;
        private Double value;
        private String type; // PERCENTAGE or FIXED
        private Double minAmount;
        private boolean isApplicable; // Is the subtotal high enough?
    }
}