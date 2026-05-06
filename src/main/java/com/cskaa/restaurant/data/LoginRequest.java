package com.cskaa.restaurant.data;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
public class LoginRequest {
	
	@NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    @JsonProperty("email")
    private String username;
	
	@NotBlank(message = "Password is required")
    private String password;

    // getters/setters
}
