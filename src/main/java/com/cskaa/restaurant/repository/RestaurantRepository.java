
package com.cskaa.restaurant.repository;

import com.cskaa.restaurant.model.Restaurant;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface RestaurantRepository extends JpaRepository<Restaurant, Long> {

	@Query("SELECT r FROM Restaurant r WHERE r.owner.id= :ownerId and  r.isDeleted = false")
    List<Restaurant> findByOwnerId(Long ownerId);

    @Transactional
    @Modifying
    @Query("update Restaurant c set c.isDeleted=true where c.id =:id and c.isDeleted=false")
    void deleteById(@Param("id") Long id);

    Optional<Restaurant> findByIdAndOwnerIdAndIsDeletedFalse(Long id, Long ownerId);
    @Query("SELECT r FROM Restaurant r WHERE r.isDeleted = false AND NOT EXISTS " +
            "(SELECT 1 FROM RestaurantBlockedUser b " +
            " WHERE b.restaurant.id = r.id " +
            " AND b.user.id = :userId " +
            " AND b.active = true)")
    Page<Restaurant> findAllUnblockedForUser(@Param("userId") Long userId, Pageable pageable);

    @Query("SELECT r FROM Restaurant r WHERE r.id = :id and r.isDeleted = false")
    Optional<Restaurant> findById(Long id);

}