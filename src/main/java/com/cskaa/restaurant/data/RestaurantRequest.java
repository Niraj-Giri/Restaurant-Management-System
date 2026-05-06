package com.cskaa.restaurant.data;

import javax.validation.constraints.NotBlank;

import lombok.Data;

@Data
public class RestaurantRequest {
    @NotBlank private String name;
    @NotBlank private String description;
    private String ownerEmail; // Only used by ADMIN
    
    
}
