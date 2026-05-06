package com.cskaa.restaurant.data;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BlockUserRequest {
    private Long userId;
    private String reason;
    private Long restaurantId;
}