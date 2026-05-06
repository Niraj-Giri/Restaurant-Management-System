package com.cskaa.restaurant.repository;

import com.cskaa.restaurant.model.Cart;
import com.cskaa.restaurant.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartRepository extends JpaRepository<Cart, Long> {
    // For logged-in users
    // Change from Optional<Cart> to List<Cart>
    List<Cart> findByUserAndIsOrderPlacedFalseAndIsDeletedFalse(User user);

    // For guests
    Optional<Cart> findByGuestSessionIdAndIsOrderPlacedFalseAndIsDeletedFalse(String sessionId);


    Cart findByUserId(Long userId);

    Cart findByUserAndIsOrderPlacedFalse(User user);
}