package com.cskaa.restaurant.repository;

import com.cskaa.restaurant.model.Order;
import com.cskaa.restaurant.model.OrderTracking;
import com.cskaa.restaurant.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public interface OrderTrackingRepository extends JpaRepository<OrderTracking, Long> {

    // Finds tasks currently assigned to the rider
    List<OrderTracking> findByStaffAndDeliveredFalse(User staff);
    List<OrderTracking> findByStaffAndDeliveredFalseOrderByCreatedAtDesc(User staff);
    // Finds past completions
    List<OrderTracking> findByStaffAndDeliveredTrue(User staff);

    Optional<OrderTracking> findByOrderId(Long orderId);

}