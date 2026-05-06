package com.cskaa.restaurant.data;


import lombok.Data;

@Data
public class OrderItemRequest {
    private Long productId;
    private Integer quantity;
}