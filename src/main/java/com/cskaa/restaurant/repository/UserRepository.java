package com.cskaa.restaurant.repository;


import com.cskaa.restaurant.data.Role;
import com.cskaa.restaurant.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;


@Repository

public interface UserRepository extends JpaRepository<User, Long> {
    
	@Query("select c from User c where c.id=:id and c.isDeleted=false")
	Optional<User> findById(Long id);
	
	
	@Query("select c from User c where c.email=:email and c.isDeleted=false")
	Optional<User> findByEmail(String email);
	
    boolean existsByEmail(String email);
    
    @Query("select c from User c where c.email=:email and c.isDeleted=false")
	User findByUsername(String email);
	@Query("SELECT DISTINCT o.customer FROM Order o WHERE o.restaurant.id = :resId and o.customer.role='CUSTOMER' AND o.customer IS NOT NULL")
	List<User> findUniqueCustomersByRestaurantId(@Param("resId") Long resId);

	@Query("SELECT u FROM User u WHERE u.role IN :roles AND u.isDeleted = false")
	List<User> findByRoleIn(@Param("roles") List<Role> roles);

	@Query("SELECT u FROM User u WHERE u.role = :role AND u.isDeleted = false")
	List<User> findByRole(@Param("role") Role role);

}