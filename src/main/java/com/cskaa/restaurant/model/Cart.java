package com.cskaa.restaurant.model;


import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import java.util.Date;

@Entity
@Data
@Table(name = "cart")
public class Cart {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "guest_session_id", length = 100)
    private String guestSessionId;
    @Column(name = "is_order_placed")
    private Boolean isOrderPlaced;

    @Column(name = "order_id")
    private Long orderId;

    @Column(name = "is_deleted")
    private Boolean isDeleted;

    @Column(name = "total_price")
    private Double totalPrice;

    @ManyToOne()
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "restaurant_id")
    private Restaurant restaurant;

    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(pattern = "yyyy-MM-dd hh:mm:ss")
    @Column(name = "created_date")
    private Date createdDate;

    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(pattern = "yyyy-MM-dd hh:mm:ss")
    @Column(name = "updated_date")
    private Date updatedDate;



}
