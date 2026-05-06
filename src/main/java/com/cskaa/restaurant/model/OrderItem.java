package com.cskaa.restaurant.model;

import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

// OrderItem.java
@Entity
@Data
public class OrderItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "order_id")
    private Order order;

    @ManyToOne
    @JsonIgnoreProperties({"restaurant", "category", "hibernateLazyInitializer", "handler"})
    private Product product;

    private Integer quantity;
    private Double priceAtPurchase;
}