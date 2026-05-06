package com.cskaa.restaurant.data;
public enum OrderStatus {
    PLACED,     // Customer places order
    CANCELED,   // Either can cancel
    PROCESSING,
    ASSIGNED,// Owner starts cooking
    IN_ROUTE,   // Owner marks as on the way
    DELIVERED,  // Staff delivers
    RECEIVED    // Customer confirms receipt
}