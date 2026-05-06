package com.cskaa.restaurant.repository;


import com.cskaa.restaurant.model.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    @Query("SELECT p FROM Product p WHERE p.restaurant.id = :resId AND p.isDeleted = false")
    Page<Product> findActiveByRestaurantId(@Param("resId") Long resId, Pageable pageable);


}