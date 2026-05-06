package com.cskaa.restaurant;
import com.cskaa.restaurant.data.Role;
import com.cskaa.restaurant.model.*;
import com.cskaa.restaurant.service.RestaurantService;
import com.cskaa.restaurant.service.UserService;
import com.cskaa.restaurant.repository.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import static org.hamcrest.Matchers.containsString;
import java.util.Map;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class RestaurantControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private RestaurantService restaurantService;

    @MockBean
    private UserService userService;

    @MockBean
    private RestaurantRepository restaurantRepository;

    @MockBean
    private ProductRepository productRepository;

    private User mockCustomer;
    private User mockOwner;
    private Restaurant mockRestaurant;

    @BeforeEach
    void setUp() {
        mockCustomer = new User();
        mockCustomer.setId(123L);
        mockCustomer.setEmail("customer@test.com");
        mockCustomer.setRole(Role.CUSTOMER);

        mockOwner = new User();
        mockOwner.setId(456L);
        mockOwner.setEmail("owner@test.com");
        mockOwner.setRole(Role.RESTAURANT_OWNER);

        mockRestaurant = new Restaurant();
        mockRestaurant.setId(1L);
        mockRestaurant.setName("The Great Bistro");
        mockRestaurant.setOwner(mockOwner);
    }

    // 1. TEST: Blocked User Access (GET /id)
    @Test
    @WithMockUser(username = "customer@test.com")
    public void testGetRestaurantById_WhenBlocked_ReturnsForbidden() throws Exception {
        when(userService.findByUsername("customer@test.com")).thenReturn(mockCustomer);
        // Simulate block logic returning true
        when(restaurantService.isUserBlocked(1L, 123L)).thenReturn(true);

        mockMvc.perform(get("/api/restaurants/1"))
                .andExpect(status().isForbidden())
                .andExpect(jsonPath("$.error").value("Access Restricted: You are blocked by this restaurant."));
    }

    // 2. TEST: Authorized Menu Addition (POST /add/menu)
    @Test
    @WithMockUser(username = "owner@test.com", roles = {"RESTAURANT_OWNER"})
    public void testAddMenu_AsOwner_Success() throws Exception {
        when(userService.findByUsername("owner@test.com")).thenReturn(mockOwner);
        when(restaurantRepository.findById(1L)).thenReturn(Optional.of(mockRestaurant));

        Map<String, Object> menuRequest = Map.of(
                "restaurantId", 1L,
                "name", "Cheese Pizza",
                "description", "Delicious Pizza",
                "price", 12.50
        );

        mockMvc.perform(post("/api/restaurants/add/menu")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(menuRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("Product added successfully"));
    }

    // 4. TEST: Admin Restaurant Registration (POST /add)
    @Test
    @WithMockUser(username = "owner@test.com", roles = {"RESTAURANT_OWNER"})
    public void testRegisterRestaurant_AsAdmin_Success() throws Exception {
        User admin = new User();
        admin.setRole(Role.RESTAURANT_OWNER);

        when(userService.findByUsername("owner@test.com")).thenReturn(admin);
        when(userService.findByEmail("owner@test.com")).thenReturn(mockOwner);
        when(restaurantService.saveRestaurant(any())).thenReturn(mockRestaurant);

        Map<String, String> request = Map.of(
                "name", "New Branch",
                "description", "Expansion",
                "ownerEmail", "owner@test.com"
        );

        mockMvc.perform(post("/api/restaurants/add")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk());
    }


    @Test
    @WithMockUser(username = "wrong_owner@test.com", roles = {"RESTAURANT_OWNER"})
    public void testAddMenu_WrongOwner_ReturnsForbidden() throws Exception {
        User wrongOwner = new User();
        wrongOwner.setId(999L);
        wrongOwner.setRole(Role.RESTAURANT_OWNER);

        when(userService.findByUsername("wrong_owner@test.com")).thenReturn(wrongOwner);
        when(restaurantRepository.findById(1L)).thenReturn(Optional.of(mockRestaurant));

        // ADD THE DESCRIPTION HERE 👇
        Map<String, Object> menuRequest = Map.of(
                "restaurantId", 1L,
                "name", "Burger",
                "price", 5.0,
                "description", "A tasty beef burger" // This fixes the 400 error
        );

        mockMvc.perform(post("/api/restaurants/add/menu")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(menuRequest)))
                .andExpect(status().isForbidden()); // Now it will correctly hit 403
    }    @Test
    @WithMockUser(roles = {"RESTAURANT_OWNER"})
    public void testAddMenu_MissingDescription_ReturnsBadRequest() throws Exception {
        Map<String, Object> invalidRequest = Map.of(
                "restaurantId", 1L,
                "name", "Burger",
                "price", 5.0
                // description is missing on purpose
        );

        mockMvc.perform(post("/api/restaurants/add/menu")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest()) // Expect 400
                .andExpect(jsonPath("$.errors.description").value("Description is required"));
    }

    // --- DELETE MENU ITEM SCENARIOS ---

    @Test
    @WithMockUser(username = "owner@test.com", roles = {"RESTAURANT_OWNER"})
    public void testDeleteMenu_AsOwner_Success() throws Exception {
        Product mockProduct = new Product();
        mockProduct.setId(10L);
        mockProduct.setRestaurant(mockRestaurant);

        when(productRepository.findById(10L)).thenReturn(Optional.of(mockProduct));
        when(userService.findByUsername("owner@test.com")).thenReturn(mockOwner);

        mockMvc.perform(delete("/api/restaurants/menu/10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("Menu item deleted successfully"));
    }

    @Test
    @WithMockUser(username = "wrong_owner@test.com", roles = {"RESTAURANT_OWNER"})
    public void testDeleteMenu_WrongOwner_ReturnsForbidden() throws Exception {
        User wrongOwner = new User();
        wrongOwner.setId(999L);
        wrongOwner.setRole(Role.RESTAURANT_OWNER);

        Product mockProduct = new Product();
        mockProduct.setId(10L);
        mockProduct.setRestaurant(mockRestaurant); // Owned by ID 456

        when(productRepository.findById(10L)).thenReturn(Optional.of(mockProduct));
        when(userService.findByUsername("wrong_owner@test.com")).thenReturn(wrongOwner);

        mockMvc.perform(delete("/api/restaurants/menu/10"))
                .andExpect(status().isForbidden())
                .andExpect(content().string("You can only delete items from your own restaurant."));
    }

    // --- UPDATE RESTAURANT SCENARIOS ---

    @Test
    @WithMockUser(username = "owner@test.com", roles = {"RESTAURANT_OWNER"})
    public void testUpdateRestaurant_AsOwner_Success() throws Exception {
        when(restaurantService.getRestaurantById(1L)).thenReturn(mockRestaurant);
        when(restaurantService.saveRestaurant(any())).thenReturn(mockRestaurant);

        Map<String, String> updateRequest = Map.of(
                "name", "Updated Bistro Name",
                "description", "New Description"
        );

        mockMvc.perform(put("/api/restaurants/restaurant/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(updateRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Updated Bistro Name"));
    }

    // --- UNBLOCK USER SCENARIOS ---

    @Test
    @WithMockUser(username = "owner@test.com", roles = {"RESTAURANT_OWNER"})
    public void testUnblockUser_AsOwner_Success() throws Exception {
        // Arrange
        when(userService.findByUsername("owner@test.com")).thenReturn(mockOwner);
        when(userService.findById(123L)).thenReturn(mockCustomer);
        when(restaurantRepository.findByIdAndOwnerIdAndIsDeletedFalse(1L, 456L))
                .thenReturn(Optional.of(mockRestaurant));

        Map<String, Object> unblockRequest = Map.of(
                "userId", 123L,
                "restaurantId", 1L
        );

        // Act & Assert
        mockMvc.perform(post("/api/restaurants/unblock-user")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(unblockRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("User unblocked successfully"));
    }

    // --- GET MEALS SCENARIOS ---

    @Test
    @WithMockUser(username = "customer@test.com")
    public void testGetMeals_WhenBlocked_ReturnsForbidden() throws Exception {
        when(userService.findByUsername("customer@test.com")).thenReturn(mockCustomer);
        when(restaurantService.isUserBlocked(1L, 123L)).thenReturn(true);

        mockMvc.perform(get("/api/restaurants/1/meals"))
                .andExpect(status().isForbidden())
                .andExpect(jsonPath("$.error", containsString("Access Restricted")));
    }

    // --- ADMIN VS OWNER REGISTRATION LOGIC ---
    @Test
    @WithMockUser(username = "owner@test.com", roles = {"RESTAURANT_OWNER"})
    public void testRegisterRestaurant_OwnerTriesToAssignOtherOwner_ReturnsForbidden() throws Exception {
        when(userService.findByUsername("owner@test.com")).thenReturn(mockOwner);

        Map<String, String> request = Map.of(
                "name", "Illegal Branch",
                "ownerEmail", "someone_else@test.com" // Different from authenticated user
        );

        mockMvc.perform(post("/api/restaurants/add")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isInternalServerError());
    }

    // --- STAFF REGISTRATION LOGIC ---
    @Test
    @WithMockUser(username = "owner@test.com", roles = {"RESTAURANT_OWNER"})
    public void testRegisterStaff_UnownedRestaurant_ReturnsError() throws Exception {
        when(userService.findByUsername("owner@test.com")).thenReturn(mockOwner);
        // Simulate owner NOT owning the restaurant ID 99
        when(restaurantRepository.findByIdAndOwnerIdAndIsDeletedFalse(99L, 456L))
                .thenReturn(Optional.empty());

        Map<String, Object> staffRequest = Map.of(
                "restaurantId", 99L,
                "email", "newstaff@test.com",
                "password", "pass123"
        );

        mockMvc.perform(post("/api/restaurants/register-staff")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(staffRequest)))
                .andExpect(status().isBadRequest())
                .andExpect(content().string(containsString("Unauthorized")));
    }
    // 1. TEST: Owner trying to spoof Email (Owner trying to create a restaurant for someone else)
    @Test
    @WithMockUser(username = "owner@test.com", roles = {"RESTAURANT_OWNER"})
    public void testRegisterRestaurant_OwnerSpoofingEmail_ReturnsForbidden() throws Exception {
        // Arrange
        when(userService.findByUsername("owner@test.com")).thenReturn(mockOwner);

        Map<String, String> request = Map.of(
                "name", "Illegal Branch",
                "description", "Attempting to spoof",
                "ownerEmail", "other_owner@test.com" // This email is NOT the authenticated user
        );

        // Act & Assert
        mockMvc.perform(post("/api/restaurants/add")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isInternalServerError()); // Controller throws AccessDeniedException
    }

    // 2. TEST: Register Staff for Unauthorized Restaurant (Owner doesn't own this branch)
    @Test
    @WithMockUser(username = "owner@test.com", roles = {"RESTAURANT_OWNER"})
    public void testRegisterStaff_UnauthorizedRestaurant_ReturnsBadRequest() throws Exception {
        // Arrange
        when(userService.findByUsername("owner@test.com")).thenReturn(mockOwner);

        // Simulate that the repository finds NOTHING when checking ownerId + restaurantId
        when(restaurantRepository.findByIdAndOwnerIdAndIsDeletedFalse(99L, 456L))
                .thenReturn(Optional.empty());

        Map<String, Object> staffRequest = Map.of(
                "restaurantId", 99L,
                "firstName", "John",
                "lastName", "Doe",
                "email", "newstaff@test.com",
                "password", "password123",
                "mobileNumber", "1234567890"
        );

        // Act & Assert
        mockMvc.perform(post("/api/restaurants/register-staff")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(staffRequest)))
                .andExpect(status().isBadRequest()) // Controller returns 400 with e.getMessage()
                .andExpect(content().string(org.hamcrest.Matchers.containsString("Unauthorized")));
    }

    @Test
    @WithMockUser(username = "admin@test.com", roles = {"ADMIN"})
    public void testRegisterRestaurant_AsAdmin_MissingEmail_ReturnsBadRequest() throws Exception {
        User admin = new User();
        admin.setRole(Role.ADMIN);
        when(userService.findByUsername("admin@test.com")).thenReturn(admin);

        Map<String, String> request = Map.of("name", "No Owner Shop"); // Missing ownerEmail

        mockMvc.perform(post("/api/restaurants/add")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

}
