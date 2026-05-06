package com.cskaa.restaurant.repository;

import com.cskaa.restaurant.model.Cart;
import com.cskaa.restaurant.model.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    List<CartItem> findByCartAndIsDeletedFalse(Cart cart);
}
