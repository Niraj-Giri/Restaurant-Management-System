package com.cskaa.restaurant.service;

import com.cskaa.restaurant.exception.BadRequestException;
import com.cskaa.restaurant.model.*;
import com.cskaa.restaurant.data.CartResponseDTO;
import com.cskaa.restaurant.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CartService {

    @Autowired private CartRepository cartRepository;
    @Autowired private CartItemRepository cartItemRepository;
    @Autowired private ProductRepository productRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private RestaurantRepository restaurantRepository;
    @Autowired private RestaurantBlockedUserRepository restaurantBlockedUserRepository;

    public void validateAndClearIfBlocked(User user) {
        // 1. Fetch as a List to handle potential duplicates from race conditions
        List<Cart> activeCarts = cartRepository.findByUserAndIsOrderPlacedFalseAndIsDeletedFalse(user);

        // 2. Loop through active carts (handles the "result size 2" scenario safely)
        for (Cart cart : activeCarts) {
            Long restaurantId = null;

            // Try to get from Cart Entity
            if (cart.getRestaurant() != null) {
                restaurantId = cart.getRestaurant().getId();
            }
            // Fallback: Get from the first item in the cart
            else {
                List<CartItem> items = cartItemRepository.findByCartAndIsDeletedFalse(cart);
                if (!items.isEmpty() && items.get(0).getProduct() != null) {
                    restaurantId = items.get(0).getProduct().getRestaurant().getId();

                    // Self-healing: Update the cart with the missing restaurant ID
                    cart.setRestaurant(items.get(0).getProduct().getRestaurant());
                    cartRepository.save(cart);
                }
            }

            System.out.println("Checking block status for User: " + user.getId() + " at Restaurant: " +
                    (restaurantId != null ? restaurantId : "NONE"));

            if (restaurantId != null) {
                boolean isBlocked = restaurantBlockedUserRepository.existsByRestaurantIdAndUserIdAndActiveTrue(restaurantId, user.getId());

                if (isBlocked) {
                    // Clear items and soft-delete the cart if blocked
                    List<CartItem> items = cartItemRepository.findByCartAndIsDeletedFalse(cart);
                    items.forEach(item -> item.setIsDeleted(true));
                    cartItemRepository.saveAll(items);

                    cart.setIsDeleted(true);
                    cartRepository.save(cart);

                    throw new BadRequestException("Access Restricted: This restaurant has restricted your account.");
                }
            }
        }
    }

    // --- CART RETRIEVAL ---
    public CartResponseDTO getCartDTO(String email, String guestId) {
        Cart cart = getCartEntity(email, guestId);
        return mapToDTO(cart);
    }

    private Cart getCartEntity(String email, String guestId) {
        if (email != null) {
            User user = userRepository.findByEmail(email)
                    .orElseThrow(() -> new RuntimeException("User not found"));

            validateAndClearIfBlocked(user);

            // Fetch as a List to avoid the "NonUniqueResultException" crash
            List<Cart> userCarts = cartRepository.findByUserAndIsOrderPlacedFalseAndIsDeletedFalse(user);

            if (userCarts.isEmpty()) {
                return createNewEmptyCart(user, null);
            } else {
                // Self-healing: If more than 1 cart exists, take the first and delete others
                if (userCarts.size() > 1) {
                    for (int i = 1; i < userCarts.size(); i++) {
                        Cart extra = userCarts.get(i);
                        extra.setIsDeleted(true);
                        cartRepository.save(extra);
                    }
                }
                return userCarts.get(0);
            }
        }

       else{
        return cartRepository.findByGuestSessionIdAndIsOrderPlacedFalseAndIsDeletedFalse(guestId)
                .orElseGet(() -> createNewEmptyCart(null, guestId));
    }
    }
    // --- ITEM MANAGEMENT ---
    @Transactional
    public CartResponseDTO addItemToCart(String email, String guestId, Long productId, Integer quantity) {
        Cart cart = getCartEntity(email, guestId);
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        // 1. Enforce single restaurant policy
        validateSingleRestaurant(cart, product);

        // 2. SET THE RESTAURANT ID IF IT'S MISSING
        if (cart.getRestaurant() == null) {
            cart.setRestaurant(product.getRestaurant());
            cartRepository.save(cart); // Save immediately
        }

        // 3. BLOCK CHECK for adding new items
        if (cart.getUser() != null) {
            boolean isBlocked = restaurantBlockedUserRepository.existsByRestaurantIdAndUserIdAndActiveTrue         (
                    product.getRestaurant().getId(), cart.getUser().getId());
            if (isBlocked) {
                throw new BadRequestException("Access Restricted: This restaurant has restricted your account.");
            }
        }

        updateOrAddCartItem(cart, product, quantity);

        return mapToDTO(cart);
    }

    @Transactional
    public CartResponseDTO updateItemQuantity(String email, String guestId, Long itemId, int change) {
        CartItem item = cartItemRepository.findById(itemId).orElseThrow(() -> new RuntimeException("Item not found"));
        Cart cart = item.getCart();

        int newQuantity = item.getQuantity() + change;
        if (newQuantity <= 0) {
            item.setIsDeleted(true);
        } else {
            item.setQuantity(newQuantity);
        }
        item.setUpdatedDate(new Date());
        cartItemRepository.save(item);

        return mapToDTO(cart);
    }

    @Transactional
    public CartResponseDTO clearCart(String email, String guestId) {
        Cart cart = getCartEntity(email, guestId);
        List<CartItem> items = cartItemRepository.findByCartAndIsDeletedFalse(cart);
        items.forEach(item -> item.setIsDeleted(true));
        cartItemRepository.saveAll(items);
        cart.setRestaurant(null);
        cart.setTotalPrice(0.0);

        cartRepository.save(cart);
        return mapToDTO(cart);
    }

    @Transactional
    public void mergeGuestCartToUser(String guestSessionId, String userEmail) {

        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));


            Optional<Cart> guestCartOpt = cartRepository.findByGuestSessionIdAndIsOrderPlacedFalseAndIsDeletedFalse(guestSessionId);

            if (guestCartOpt.isPresent()) {
                Cart guestCart = guestCartOpt.get();
            // SECURITY CHECK: Is this guest now identified as a blocked user for this restaurant?
            if (guestCart.getRestaurant() != null) {
                boolean isBlocked = restaurantBlockedUserRepository.existsByRestaurantIdAndUserIdAndActiveTrue(
                        guestCart.getRestaurant().getId(), user.getId());

                if (isBlocked) {
                    // 1. Delete the items inside the guest cart first to keep DB clean
                    List<CartItem> guestItems = cartItemRepository.findByCartAndIsDeletedFalse(guestCart);
                    guestItems.forEach(item -> item.setIsDeleted(true));
                    cartItemRepository.saveAll(guestItems);

                    // 2. DISCARD the guest cart instead of merging
                    guestCart.setIsDeleted(true);
                    cartRepository.save(guestCart);

                    // 3. THROW EXCEPTION to trigger the 403 error on the frontend!
                    throw new BadRequestException("Access Restricted: This restaurant has restricted your account.");
                }
            }

            // Proceed with normal merge if not blocked
            List<Cart> userCarts = cartRepository.findByUserAndIsOrderPlacedFalseAndIsDeletedFalse(user);

        // 2. Check if the list has any active carts
            if (!userCarts.isEmpty()) {
                // Pick the most recent/relevant cart
                Cart userCart = userCarts.get(0);
//                 --- RESTAURANT CONFLICT CHECK ---
                Long userResId = userCart.getRestaurant() != null ? userCart.getRestaurant().getId() : null;
                Long guestResId = guestCart.getRestaurant() != null ? guestCart.getRestaurant().getId() : null;
                if (userResId != null && guestResId != null && !userResId.equals(guestResId)) {
                    // If restaurants are different, SOFT DELETE the old user cart
                    userCart.setIsDeleted(true);
                    cartRepository.save(userCart);

                    // Now simply convert the guest cart into the new primary user cart
                    guestCart.setUser(user);
                    guestCart.setGuestSessionId(null);
                    cartRepository.save(guestCart);
                    return; // Merge finished by replacement
                }


                List<CartItem> guestItems = cartItemRepository.findByCartAndIsDeletedFalse(guestCart);

                for (CartItem gItem : guestItems) {
                    // Find if this product already exists in the User's cart
                    Optional<CartItem> existing = cartItemRepository.findByCartAndIsDeletedFalse(userCart).stream()
                            .filter(i -> i.getProduct().getId().equals(gItem.getProduct().getId()))
                            .findFirst();

                    if (existing.isPresent()) {
                        // Update quantity and soft-delete the guest item
                        existing.get().setQuantity(existing.get().getQuantity() + gItem.getQuantity());
                        gItem.setIsDeleted(true);
                        cartItemRepository.save(existing.get()); // Ensure the update is persisted
                    } else {
                        // Move the item to the user's cart
                        gItem.setCart(userCart);
                    }
                }

                // Mark the guest cart as deleted after successful migration
                guestCart.setIsDeleted(true);
                cartRepository.save(guestCart);
                cartItemRepository.saveAll(guestItems);

            } else {
                // No user cart exists, simply convert the guest cart to a user cart
                guestCart.setUser(user);
                guestCart.setGuestSessionId(null);
                cartRepository.save(guestCart);
            }
        }
    }

    // --- MAPPING & HELPERS ---
    private CartResponseDTO mapToDTO(Cart cart) {
        CartResponseDTO dto = new CartResponseDTO();
        dto.setCartId(cart.getId());

        List<CartItem> activeItems = cartItemRepository.findByCartAndIsDeletedFalse(cart);

        // Efficiency: Use the restaurant field directly if mapped
        if (cart.getRestaurant() != null) {
            dto.setRestaurantId(cart.getRestaurant().getId());
            dto.setRestaurantName(cart.getRestaurant().getName());
        }

        dto.setItems(activeItems.stream().map(i -> {
            CartResponseDTO.CartItemDTO itemDto = new CartResponseDTO.CartItemDTO();
            itemDto.setId(i.getId());
            itemDto.setProductId(i.getProduct().getId());
            itemDto.setName(i.getProduct().getName());
            itemDto.setPrice(i.getPrice());
            itemDto.setQuantity(i.getQuantity());
            return itemDto;
        }).collect(Collectors.toList()));

        double total = activeItems.stream().mapToDouble(i -> i.getPrice() * i.getQuantity()).sum();
        dto.setGrandTotal(total);

        cart.setTotalPrice(total);
        cartRepository.save(cart);

        return dto;
    }

    private void validateSingleRestaurant(Cart cart, Product product) {
        List<CartItem> items = cartItemRepository.findByCartAndIsDeletedFalse(cart);
        if (!items.isEmpty()) {
            Long currentResId = items.get(0).getProduct().getRestaurant().getId();
            Long newResId = product.getRestaurant().getId();
            if (!currentResId.equals(newResId)) {
                throw new RuntimeException("Only one restaurant allowed per order. Please clear cart first.");
            }
        }
    }

    private void updateOrAddCartItem(Cart cart, Product product, Integer quantity) {
        Optional<CartItem> existing = cartItemRepository.findByCartAndIsDeletedFalse(cart).stream()
                .filter(i -> i.getProduct().getId().equals(product.getId())).findFirst();
        if (existing.isPresent()) {
            existing.get().setQuantity(existing.get().getQuantity() + quantity);
            cartItemRepository.save(existing.get());
        } else {
            CartItem newItem = new CartItem();
            newItem.setCart(cart);
            newItem.setProduct(product);
            newItem.setQuantity(quantity);
            newItem.setPrice(product.getPrice());
            newItem.setIsDeleted(false);
            newItem.setCreatedDate(new Date());
            cartItemRepository.save(newItem);
        }
    }

    private Cart createNewEmptyCart(User user, String guestId) {
        Cart cart = new Cart();
        cart.setUser(user);
        cart.setGuestSessionId(guestId);
        cart.setIsOrderPlaced(false);
        cart.setIsDeleted(false);
        cart.setTotalPrice(0.0);
        cart.setCreatedDate(new Date());
        return cartRepository.save(cart);
    }
}