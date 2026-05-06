<style>
    .navbar-premium {
        background: #ffffff !important;
        border-bottom: 2px solid #f1f5f9;
        padding: 1rem 0;
    }
    .navbar-brand-custom {
        font-weight: 800;
        font-size: 1.6rem;
        color: #0d6efd !important;
    }
    /* Fixed Cart Icon Container */
    .cart-wrapper {
        position: relative;
        display: inline-flex;
        align-items: center;
        padding: 10px;
        background: #f1f5f9;
        border-radius: 12px;
        color: #334155;
        text-decoration: none;
    }
    #cart-count {
        position: absolute;
        top: -8px;
        right: -8px;
        background: #ef4444; /* Bright Red */
        color: white;
        border-radius: 50px;
        padding: 2px 8px;
        font-size: 0.75rem;
        font-weight: bold;
        border: 2px solid #ffffff;
    }
    .nav-link-custom {
        font-weight: 600;
        color: #475569 !important;
        margin-right: 20px;
    }
</style>

<nav class="navbar navbar-expand-lg sticky-top navbar-premium">
    <div class="container">
        <a class="navbar-brand navbar-brand-custom" href="/home">
            <i class="fa-solid fa-utensils me-2"></i>FoodAPP
        </a>

        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link nav-link-custom" href="/home">Home</a></li>
                <li class="nav-item user-only" style="display:none;"><a class="nav-link nav-link-custom" href="/orders">My Orders</a></li>
            </ul>

            <div class="d-flex align-items-center">
                <a href="/cart" class="cart-wrapper me-4" id="nav-cart">
                    <i class="fa-solid fa-cart-shopping fs-5"></i>
                    <span id="cart-count" style="display:none;">0</span>
                </a>

                <button class="btn btn-primary rounded-pill px-4 guest-only fw-bold" data-bs-toggle="modal" data-bs-target="#authModal">
                    Login
                </button>

                <div class="dropdown user-only" style="display:none;">
                    <button class="btn btn-light border rounded-pill px-3 dropdown-toggle fw-bold" type="button" data-bs-toggle="dropdown">
                        <i class="fa-solid fa-user-circle me-1"></i> Account
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-4 p-2">

                        <li><button class="dropdown-item py-2 text-danger fw-bold" data-bs-toggle="modal" data-bs-target="#logoutModal">Logout</button></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</nav>

<div id="order-success-capsule"></div> <div class="modal fade" id="authModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content p-4 shadow border-0 rounded-5">
            <button type="button" class="btn-close btn-close-custom" data-bs-dismiss="modal" aria-label="Close"></button>
            <div class="text-center mb-4 mt-2">
                <h3 class="fw-black text-primary"><i class="fa-solid fa-bowl-food me-2"></i>FoodAPP</h3>
            </div>
            <ul class="nav nav-tabs justify-content-center mb-4 border-bottom-0" id="authTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active fw-bold text-dark border-0" id="login-tab" data-bs-toggle="tab" data-bs-target="#login" type="button" role="tab">LOGIN</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link fw-bold text-dark border-0" id="register-tab" data-bs-toggle="tab" data-bs-target="#register" type="button" role="tab">REGISTER</button>
                </li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane fade show active" id="login" role="tabpanel"><jsp:include page="/WEB-INF/views/login.jsp" /></div>
                <div class="tab-pane fade" id="register" role="tabpanel"><jsp:include page="/WEB-INF/views/register.jsp" /></div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="logoutModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content p-3 shadow border-0 rounded-4">
            <button type="button" class="btn-close ms-auto" data-bs-dismiss="modal" aria-label="Close"></button>
            <jsp:include page="/WEB-INF/views/user-logout.jsp" />
        </div>
    </div>
</div>

<div class="toast-container position-fixed top-0 end-0 p-4" style="z-index: 9999; top: 20px !important;">
    <div id="successToast" class="toast align-items-center text-white bg-success border-0 shadow" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body fw-bold fs-6" id="toastMessage"></div>
            <button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<div class="modal fade" id="clearCartModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow rounded-4">
            <div class="modal-body text-center p-4">
                <div class="text-warning mb-3"><i class="fa-solid fa-circle-exclamation fs-1"></i></div>
                <h4 class="fw-bold">Start a new order?</h4>
                <p class="text-muted">Your cart already contains items from another restaurant. Would you like to clear it and add this item instead?</p>
                <div class="d-grid gap-2 mt-4">
                    <button type="button" class="btn btn-danger fw-bold rounded-pill" id="confirmClearAndAdd">Clear Cart & Add Item</button>
                    <button type="button" class="btn btn-light fw-bold rounded-pill" data-bs-dismiss="modal">Keep Existing Order</button>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="blockedUserModal" data-bs-backdrop="static" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-body text-center p-5">
                <div class="bg-danger bg-opacity-10 text-danger rounded-circle d-inline-flex align-items-center justify-content-center mb-4" style="width: 80px; height: 80px;">
                    <i class="fa-solid fa-user-slash display-4"></i>
                </div>
                <h3 class="fw-bold text-dark">Access Restricted</h3>
                <p class="text-muted" id="blocked-message">This restaurant has restricted your account.</p>
                <button type="button" class="btn btn-danger btn-lg w-100 rounded-pill fw-bold mt-3 shadow-sm" onclick="window.location.href='/home'">Back to Home</button>
            </div>
        </div>
    </div>
</div>


<script>
    // --- 1. On Page Load ---
    $(document).ready(function() {
        if (!localStorage.getItem('token') && !localStorage.getItem('guestSessionId')) {
            const uniqueId = 'guest_' + Math.random().toString(36).substr(2, 9) + Date.now();
            localStorage.setItem('guestSessionId', uniqueId);
        }
        checkAuthState();
        updateCartUI();

        // REMOVE THIS LINE: completeLoginFlow();
        // It should only be triggered by the Login AJAX success callback.
    });

    // --- 2. Authentication UI Logic ---
    function checkAuthState() {
        const token = localStorage.getItem('token');
        if (token) {
            $('.guest-only').hide();
            $('.user-only').show();
        } else {
            $('.guest-only').show();
            $('.user-only').hide();
        }
    }

    // --- 3. Modal Tab UI Logic ---
    function showTab(tabName) {
        const tabEl = document.querySelector("#" + tabName + "-tab");
        if (tabEl) {
            const tab = new bootstrap.Tab(tabEl);
            tab.show();
        }
    }

    $(document).on("click", "#login-to-reset", function (e) {
        e.preventDefault();
        $("#login").removeClass("show active");
        $("#reset-password").addClass("show active");
    });

    $(document).on("click", "#reset-to-login", function (e) {
        e.preventDefault();
        $("#reset-password").removeClass("show active");
        $("#login").addClass("show active");
    });

    let pendingItem = null;

    function addToCart(mealId, mealName, mealPrice, currentRestaurantId) {
        const token = localStorage.getItem('token');
        const guestId = localStorage.getItem('guestSessionId');
        let payload = { productId: mealId, quantity: 1, guestId: token ? null : guestId };

        $.ajax({
            url: '/api/cart/add',
            type: 'POST',
            headers: token ? { 'Authorization': 'Bearer ' + token } : {},
            contentType: 'application/json',
            data: JSON.stringify(payload),
            success: function(response) {
                updateCartUI(response);
                showSuccessToast(mealName + " added to cart!");
            },
            error: function(xhr) {
                if (xhr.status === 400) {
                    const errorData = JSON.parse(xhr.responseText);
                    if (errorData.error && errorData.error.includes("one restaurant")) {
                        pendingItem = payload;
                        const clearModal = new bootstrap.Modal(document.getElementById('clearCartModal'));
                        clearModal.show();
                    }
                    if (errorData.error && errorData.error.includes("Access Restricted")) {
                        pendingItem = payload;
                        const clearModal = new bootstrap.Modal(document.getElementById('blockedUserModal'));
                        clearModal.show();
                    }
                }

                else {
                    alert("Could not add item to cart.");
                }
            }
        });
    }

    $('#confirmClearAndAdd').click(function() {
        const btn = $(this);
        const token = localStorage.getItem('token');
        const guestId = localStorage.getItem('guestSessionId');

        // Prevent double clicks
        btn.prop('disabled', true).text('Processing...');

        // STEP 1: Call CLEAR API first
        $.ajax({
            url: '/api/cart/clear' + (token ? '' : '?guestId=' + guestId),
            type: 'DELETE',
            headers: token ? { 'Authorization': 'Bearer ' + token } : {},
            success: function() {
                // STEP 2: ONLY after CLEAR is 100% successful, call ADD API
                if (pendingItem) {
                    $.ajax({
                        url: '/api/cart/add',
                        type: 'POST',
                        headers: token ? { 'Authorization': 'Bearer ' + token } : {},
                        contentType: 'application/json',
                        data: JSON.stringify(pendingItem),
                        success: function(res) {
                            updateCartUI(res);
                            const clearModalEl = document.getElementById('clearCartModal');
                            bootstrap.Modal.getInstance(clearModalEl).hide();
                            showSuccessToast("Cart updated successfully!");
                            pendingItem = null;
                        },
                        error: function(xhr) {
                            alert("Error adding item: " + xhr.responseText);
                        },
                        complete: function() {
                            btn.prop('disabled', false).text('Clear Cart & Add Item');
                        }
                    });
                }
            },
            error: function() {
                alert("Could not clear the cart.");
                btn.prop('disabled', false).text('Clear Cart & Add Item');
            }
        });
    });

    function updateCartUI(cartResponse = null) {
        const badge = $('#cart-count');

        if (cartResponse) {
            let totalItems = 0;
            if (cartResponse.items) {
                totalItems = cartResponse.items.reduce((sum, item) => sum + item.quantity, 0);
            }
            badge.text(totalItems);
            totalItems > 0 ? badge.show() : badge.hide();
            return;
        }

        const token = localStorage.getItem('token');
        const guestId = localStorage.getItem('guestSessionId');

        $.ajax({
            url: token ? '/api/cart' : '/api/cart?guestId=' + guestId,
            type: 'GET',
            dataType: 'json', // <--- ADD THIS LINE
            headers: token ? { 'Authorization': 'Bearer ' + token } : {},
            success: function(res) {
                console.log("Cart Data Received:", res); // CHECK YOUR BROWSER CONSOLE (F12)
                let totalItems = 0;
                if (res && res.items) {
                    totalItems = res.items.reduce((sum, item) => sum + item.quantity, 0);
                }
                badge.text(totalItems);
                totalItems > 0 ? badge.show() : badge.hide();
            },
            error: function() {
                badge.hide();
            }
        });
    }
    function completeLoginFlow() {
        const modalEl = document.getElementById('authModal');
        if (modalEl) {
            const modalInstance = bootstrap.Modal.getInstance(modalEl);
            if (modalInstance) {
                modalInstance.hide();
            }
        }

        // Reset the login form if it exists
        if ($('#loginForm').length > 0) {
            $('#loginForm')[0].reset();
        }

        // Optional: Show a quick message before the reload
        if (typeof showSuccessToast === "function") {
            showSuccessToast("Login successful! Refreshing...");
           
        }

        // --- REFRESH THE PAGE ---
        // This will re-run $(document).ready, which calls fetchCart() and checkLoginState()
        // 500ms delay allows the user to see the "Success" toast or modal closing
    }
    function showSuccessToast(message) {
        $('#toastMessage').text(message);
        const toast = new bootstrap.Toast(document.getElementById('successToast'), { delay: 3500 });
        toast.show();
    }
</script>