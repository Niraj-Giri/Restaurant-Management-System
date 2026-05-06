package com.cskaa.restaurant.repository;

import com.cskaa.restaurant.model.RestaurantBlockedUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.Optional;

@Repository
public interface RestaurantBlockedUserRepository extends JpaRepository<RestaurantBlockedUser, Long> {

    // Quick check: Is this customer banned from this specific shop?

    @Modifying
    @Transactional
    @Query("UPDATE RestaurantBlockedUser r SET r.active = false, r.unblockedAt = :now WHERE r.restaurant.id = :resId AND r.user.id = :userId")
    void softUnblock(@Param("resId") Long resId, @Param("userId") Long userId, @Param("now") LocalDateTime now);

    boolean existsByRestaurantIdAndUserIdAndActiveTrue(Long resId, Long userId);


    Optional<RestaurantBlockedUser> findByRestaurantIdAndUserId(Long restaurantId, Long userId);
}