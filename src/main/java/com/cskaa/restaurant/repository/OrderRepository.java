package com.cskaa.restaurant.repository;

import com.cskaa.restaurant.model.Order;
import com.cskaa.restaurant.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByCustomerId(Long customerId);
    @Query("SELECT o FROM Order o JOIN FETCH o.customer WHERE o.restaurant.id = :restaurantId")
    List<Order> findByRestaurantId(@Param("restaurantId") Long restaurantId);

    List<Order> findByCustomerOrderByCreatedAtDesc(User customer);

    // For pagination and date filtering
    Page<Order> findByCustomerId(Long customerId, Pageable pageable);

    Optional<Order> findOrderById(Long orderId);
    @Query("SELECT o FROM Order o WHERE o.restaurant.id = :resId " +
            "AND o.createdAt >= :startOfToday AND o.createdAt <= :endOfToday " +
            "ORDER BY o.createdAt DESC")
    List<Order> findTodayOrders(
            @Param("resId") Long resId,
            @Param("startOfToday") LocalDateTime startOfToday,
            @Param("endOfToday") LocalDateTime endOfToday
    );
    List<Order> findByCustomerAndCreatedAtBetweenOrderByCreatedAtDesc(
            User customer,
            LocalDateTime start,
            LocalDateTime end
    );
}
