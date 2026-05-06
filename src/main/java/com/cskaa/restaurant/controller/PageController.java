package com.cskaa.restaurant.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    // Loads the home page shell
    @GetMapping({"/", "/home"})
    public String homePage() {
        return "home"; // This matches <definition name="home" ...> in tiles.xml
    }

    // Loads the login page shell
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    // Loads the registration page shell
    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    // Loads the restaurant menu page shell
    @GetMapping("/menu")
    public String menuPage() {
        return "menu"; // This must match the <definition name="menu" ...> in your tiles.xml
    }
    // Loads the owner dashboard (Only for Restaurant Owners)
    @GetMapping("/owner/dashboard")
    public String ownerDashboard() {
        return "ownerDashboard";
    }

    @GetMapping("/cart")
    public String cartPage() {
        return "cart";
    }
    @GetMapping("/orders")
    public String ordersPage() {
        return "orders";
    }

    @GetMapping("/orderDetails")
    public String orderDetailsPage() {
        return "order-details";
    }

    @GetMapping("/owner/login")
    public String ownerLoginPage() {
        return "owner-login";
    }
    @GetMapping("/owner/register")
    public String ownerRegisterPage() {
        return "owner-register";
    }
    @GetMapping({"/owner/home"})
    public String ownerHomePage() {
        return "owner-home"; // This matches <definition name="home" ...> in tiles.xml
    }
    // Maps to <definition name="owner-today-orders">
    @GetMapping("/owner/today-orders")
    public String todayOrders() {
        return "owner-today-orders";
    }

    // Maps to <definition name="owner-past-orders">
    @GetMapping("/owner/past-orders")
    public String pastOrders() {
        return "owner-past-orders";
    }
    @GetMapping("/owner/order-details")
    public String ownerOrderDetailsPage() {
        return "owner-order-details";
    }

    @GetMapping("/owner/select-restaurant")
    public String showRestaurantSelection() {
        return "owner-selection";
    }
    @GetMapping("/owner/addmenu")
    public String addMenuPage() {
        return "owner-add-menu";
    }
    @GetMapping("/owner/add-restaurant")
    public String addRestaurantPage() {
        return "owner-add-restaurant";
    }
    @GetMapping("/owner/add-staff")
    public String addStaffPage() {
        return "owner-add-staff";
    }
    @GetMapping("/owner/block-user")
    public String blockListPage() {
        return "owner-block-user";
    }
    @GetMapping("/admin/add-menu")
    public String adminAddMenuPage() {
        return "admin-add-menu";
    }
    @GetMapping("/admin/add-restaurant")
    public String adminAddRestaurantPage() {
        return "admin-add-restaurant";
    }

    @GetMapping("/admin/block-user")
    public String adminBlockListPage() {
        return "admin-block-user";
    }
    @GetMapping("/admin/add-user")
    public String adminAddUserPage() {
        return "admin-add-user";
    }
    @GetMapping("/admin/add-coupon")
    public String adminAddCouponPage() {
        return "admin-add-coupon";
    }
    @GetMapping("/admin/manage-restaurant")
    public String adminManageRestaurantPage() {
        return "admin-manage-restaurant";
    }
    @GetMapping("/admin/manage-menu")
    public String adminManageMenuPage() {
        return "admin-manage-menu";
    }
    @GetMapping("/admin/manage-user")
    public String adminManageUserPage() {
        return "admin-manage-user";
    }
    @GetMapping("/admin/manage-coupon")
    public String adminManageCouponPage() {
        return "admin-manage-coupon";
    }
    @GetMapping("/staff/assigned-orders")
    public String assignedOrders() {
        return "staff-assigned-orders";
    }

    @GetMapping("/staff/order-details")
    public String OrdersPage() {
        return "staff-order-details";
    }

    @GetMapping("/owner/manage-restaurant")
    public String ownerManageRestaurantPage() {
        return "owner-manage-restaurant";
    }
    @GetMapping("/owner/manage-menu")
    public String ownerManageMenuPage() {
        return "owner-manage-menu";
    }
    @GetMapping("/owner/manage-staff")
    public String ownerManageStaffPage() {
        return "owner-manage-staff";
    }

}