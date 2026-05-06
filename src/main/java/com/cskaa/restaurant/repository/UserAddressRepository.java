package com.cskaa.restaurant.repository;


import com.cskaa.restaurant.model.User;
import com.cskaa.restaurant.model.UserAddress;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserAddressRepository  extends JpaRepository<UserAddress, Long> {
    boolean existsByUserEmailAndIsDeletedFalse(String email);
UserAddress findByUserAndIsDeletedFalse(User user);
    Optional<UserAddress> findTopByUserEmailAndIsDeletedFalseOrderByCreatedDateDesc(String email);
    List<UserAddress> findAllByUserEmailAndIsDeletedFalseOrderByCreatedDateDesc(String email);

}
