package com.cskaa.restaurant.model;

import javax.persistence.*;

import com.cskaa.restaurant.data.CouponType;
import com.cskaa.restaurant.data.OrderStatus;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Data
@Table(name = "orders")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler", "password", "isDeleted"})
    private User customer;

    @ManyToOne
    private Restaurant restaurant;

    private Double totalAmount;
    private Double tipAmount = 0.0;

    @ManyToOne

    private Coupon coupon;

    private Double taxRate = 9.0;

    private Double totalAmountAfterTax;
    
    private double appliedCouponValue;

    @Enumerated(EnumType.STRING)
    private CouponType appliedCouponType;

    private String appliedCouponCode;

    @Column(name = "delivery_otp", nullable = true)
    private String otp;


    @Enumerated(EnumType.STRING)
    private OrderStatus status = OrderStatus.PLACED;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @ManyToOne
    @JoinColumn(name = "delivery_address_id")
    private UserAddress deliveryAddress;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderItem> items;
}