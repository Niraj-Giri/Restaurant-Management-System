package com.cskaa.restaurant.data;


import lombok.Data;
import java.util.List;

@Data
public class OrderRequest {
    private Long restaurantId;
    private List<OrderItemRequest> items;
    private String couponCode;
    private Double tipAmount = 0.0;
    private Long addressId;
}