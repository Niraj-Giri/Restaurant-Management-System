package com.cskaa.restaurant.repository;

import com.cskaa.restaurant.model.Restaurant;
import com.cskaa.restaurant.model.RestaurantStaff;
import com.cskaa.restaurant.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RestaurantStaffRepository extends JpaRepository<RestaurantStaff, Long> {
    List<RestaurantStaff> findByRestaurantId(Long restaurantId);

    Optional<RestaurantStaff> findByStaff(User staff);

    @Query("SELECT rs.restaurant FROM RestaurantStaff rs WHERE rs.staff = :staff")
    Optional<Restaurant> findRestaurantByStaff(@Param("staff") User staff);

    boolean existsByStaffAndRestaurant(User user, Restaurant restaurant);
}