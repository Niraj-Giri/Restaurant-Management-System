package com.cskaa.restaurant.data;


import lombok.Data;

@Data
public class CouponDTO {
    private String couponCode;
    private Double couponValue;
    private String couponType; // PERCENTAGE or FIXED
    private Double minimumOrderAmount;
}