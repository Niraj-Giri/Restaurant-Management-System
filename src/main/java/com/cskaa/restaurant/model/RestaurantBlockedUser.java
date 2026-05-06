package com.cskaa.restaurant.model;

import lombok.*;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.repository.query.Param;

import javax.persistence.*;
import javax.transaction.Transactional;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "restaurant_blocked_users",
        uniqueConstraints = @UniqueConstraint(columnNames = {"restaurant_id", "user_id"}))
public class RestaurantBlockedUser {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "restaurant_id", nullable = false)
    private Restaurant restaurant;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(length = 500)
    private String reason;
    @Builder.Default
    private boolean active = true;
    @Builder.Default
    private LocalDateTime blockedAt = LocalDateTime.now();
    private LocalDateTime unblockedAt;


}