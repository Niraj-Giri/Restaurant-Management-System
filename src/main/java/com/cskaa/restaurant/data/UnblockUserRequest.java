package com.cskaa.restaurant.data;

import lombok.Data;

@Data
public class UnblockUserRequest {
    private Long userId;
    private Long restaurantId;
    // We don't even need 'reason' here because we're just toggling status
}