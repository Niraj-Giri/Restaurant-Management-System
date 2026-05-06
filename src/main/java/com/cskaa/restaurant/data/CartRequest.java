package com.cskaa.restaurant.data;


import lombok.Data;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

@Data
public class CartRequest {

    @NotNull
    private Long productId;

    @Min(value = 1)
    private Integer quantity = 1;

    private String guestId;
}