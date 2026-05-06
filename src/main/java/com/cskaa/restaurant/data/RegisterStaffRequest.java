package com.cskaa.restaurant.data;

import lombok.Data;

@Data
public class RegisterStaffRequest {
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String mobileNumber;
    private Long restaurantId;
}