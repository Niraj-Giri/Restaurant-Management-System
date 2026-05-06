package com.cskaa.restaurant.service;

import com.cskaa.restaurant.data.*;
import com.cskaa.restaurant.exception.ResourceNotFoundException;
import com.cskaa.restaurant.model.*;
import com.cskaa.restaurant.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class OrderService {
    @Autowired private OrderRepository orderRepository;
    @Autowired private ProductRepository productRepository;
    @Autowired private CouponRepository couponRepository;
    @Autowired private RestaurantRepository restaurantRepository;
    @Autowired private CartRepository cartRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private UserAddressRepository userAddressRepository;
    
    @Autowired
    private WebSocketService webSocketService;

    
    
    @Transactional
    public Order placeOrder(User user, OrderRequest request) {
        // 1. Initialize Order
        Order order = new Order();
        order.setCustomer(user);
        order.setRestaurant(restaurantRepository.findById(request.getRestaurantId())
                .orElseThrow(() -> new RuntimeException("Restaurant not found")));
        order.setTipAmount(request.getTipAmount() != null ? request.getTipAmount() : 0.0);

        // 2. Calculate Subtotal from incoming items
        double subtotal = 0.0;
        List<OrderItem> orderItems = new ArrayList<>();

        for (OrderItemRequest itemReq : request.getItems()) {
            Product product = productRepository.findById(itemReq.getProductId())
                    .orElseThrow(() -> new RuntimeException("Product not found: " + itemReq.getProductId()));

            double itemTotal = product.getPrice() * itemReq.getQuantity();
            subtotal += itemTotal;

            OrderItem oi = new OrderItem();
            oi.setOrder(order);
            oi.setProduct(product);
            oi.setQuantity(itemReq.getQuantity());
            oi.setPriceAtPurchase(product.getPrice());
            orderItems.add(oi);
        }
        order.setTotalAmount(subtotal);

        // 3. Handle Coupon Logic
        double discount = 0.0;
        if (request.getCouponCode() != null && !request.getCouponCode().isEmpty()) {
            Coupon coupon = couponRepository.findByCouponCode(request.getCouponCode()).orElse(null);
            if (coupon != null && subtotal >= coupon.getMinimumOrderAmount()) {
                order.setCoupon(coupon);
                order.setAppliedCouponCode(coupon.getCouponCode());
                order.setAppliedCouponValue(coupon.getCouponValue());
                order.setAppliedCouponType(coupon.getCouponType());

                if (coupon.getCouponType().toString().equals("PERCENTAGE")) {
                    discount = subtotal * (coupon.getCouponValue() / 100.0);
                } else {
                    discount = coupon.getCouponValue();
                }
            }
        }
        // 4. Financial Snapshot & Address Mapping
        double tax = subtotal * 0.09;
        double discountedSubtotal = Math.max(0, subtotal - discount);

        order.setTotalAmountAfterTax(discountedSubtotal + tax + order.getTipAmount());
        order.setTaxRate(9.0);
        order.setStatus(OrderStatus.PLACED);

        // FIX: Fetch the specific address selected by the user
        if (request.getAddressId() != null) {
            UserAddress address = userAddressRepository.findById(request.getAddressId())
                    .orElseThrow(() -> new ResourceNotFoundException("Selected delivery address not found"));
            order.setDeliveryAddress(address);
        } else {
            throw new ResourceNotFoundException("Delivery address is required to place an order");
        }

        // 5. Final Save
        order.setItems(orderItems);
        Order savedOrder = orderRepository.save(order);

        //Send WS msg to brand
        try {
        		webSocketService.notifyFrontendForNewOrder(order);
        }catch(Exception e) {
        	e.printStackTrace();
        }
        // 6. Clean up the user's cart now that the order is placed!
        List<Cart> userCarts = cartRepository.findByUserAndIsOrderPlacedFalseAndIsDeletedFalse(user);

// 2. Iterate through the list to update all relevant cart records
        for (Cart cart : userCarts) {
            cart.setIsOrderPlaced(true);
            cart.setUpdatedDate(new Date()); // Recommended to track when the order was finalized
            cartRepository.save(cart);
        }

        return savedOrder;
    }

    public Order getOrderByOrderId( Long orderId) {
        Order order = orderRepository
                .findOrderById(orderId)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Order not found")
                );
        return order;
    }
    @Transactional
    public void cancelOrder(Order order) {
        // Update the status
        order.setStatus(OrderStatus.CANCELED);

        // If you handle inventory, you would return items to stock here

        orderRepository.save(order);
    }
    // --- Get all orders for a user ---
    public List<Order> getUserOrders(String userEmail) {
        User customer = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new ResourceNotFoundException("User not found: " + userEmail));

        return orderRepository.findByCustomerOrderByCreatedAtDesc(customer);
    }

    public OrderStatus getOrderStatus(Long orderId, String email) {

        Order order = orderRepository
                .findOrderById(orderId)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Order not found")
                );

        return order.getStatus();
    }

    public List<Order> getTodayOrders(Long resId, LocalDateTime startOfDay, LocalDateTime endOfDay) {
       return  orderRepository.findTodayOrders(resId, startOfDay, endOfDay);
    }
    public Order updateOrderStatus(Long id, OrderStatus status) {
        // 1. Fetch the order or throw exception if missing
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Order not found with id: " + id));

        // 2. Business Logic: Prevent updates to a CANCELED order
        if (order.getStatus() == OrderStatus.CANCELED) {
            throw new IllegalStateException("Cannot update status of a canceled order.");
        }

        // 3. Update the status
        order.setStatus(status);

        // 4. Update the timestamp (optional, but good for tracking)
        order.setUpdatedAt(LocalDateTime.now());

        // 5. Save and return
        return orderRepository.save(order);
    }

    public List<Order> getAllOrdersForRestaurant(Long resId) {
        return orderRepository.findByRestaurantId(resId);
    }

    public List<Order> getOrdersByUserAndDate(User user, LocalDate date) {

        LocalDateTime startOfDay = date.atStartOfDay();
        LocalDateTime endOfDay = date.atTime(LocalTime.MAX);

        return orderRepository.findByCustomerAndCreatedAtBetweenOrderByCreatedAtDesc(
                user, startOfDay, endOfDay
        );
    }

    public List<Order> getOrdersByUser(User user) {
        return orderRepository.findByCustomerOrderByCreatedAtDesc(user);
    }
}