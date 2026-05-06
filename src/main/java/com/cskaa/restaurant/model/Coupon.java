package com.cskaa.restaurant.model;

import javax.persistence.*;

import com.cskaa.restaurant.data.CouponType;
import lombok.Data;

@Entity
@Data
public class Coupon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(unique = true)
    private String couponCode;

    private Double couponValue;

    @Enumerated(EnumType.STRING)
    private CouponType couponType;

    private Double minimumOrderAmount;
    private boolean isDeleted;
}