<style>
    /* Premium Single-Card Vertical Flow */
    .checkout-wrapper { max-width: 800px; margin: 0 auto; }
    .checkout-card {
        background: #ffffff; border-radius: 28px;
        box-shadow: 0 15px 35px rgba(0,0,0,0.05);
        border: 1px solid rgba(0,0,0,0.05); overflow: hidden;
    }
    .section-header {
        font-size: 0.85rem; font-weight: 800; text-transform: uppercase;
        letter-spacing: 1.2px; color: #94a3b8; margin-bottom: 1.5rem;
    }
    .item-row { padding: 1.25rem 0; border-bottom: 1px solid #f8fafc; }
    .item-row:last-child { border-bottom: none; }
    .product-img {
        width: 60px; height: 60px; object-fit: cover;
        border-radius: 12px; background-color: #f1f5f9;
    }
    .qty-capsule { background: #f1f5f9; border-radius: 50px; padding: 4px; display: flex; align-items: center; }
    .btn-circle {
        width: 30px; height: 30px; border-radius: 50%; border: none;
        background: white; box-shadow: 0 2px 6px rgba(0,0,0,0.08);
        color: #0d6efd; display: flex; align-items: center; justify-content: center;
        font-weight: bold; transition: 0.2s;
    }
    .btn-circle:hover { background: #0d6efd; color: white; }

    /* Tip & Coupon UI */
    .tip-chips-container { display: flex; gap: 10px; }
    .tip-chip-input { display: none; }
    .tip-chip-label {
        flex: 1; text-align: center; padding: 12px;
        background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 15px;
        cursor: pointer; font-weight: 600; color: #64748b; transition: 0.2s;
    }
    .tip-chip-input:checked + .tip-chip-label { background: #0d6efd; color: white; border-color: #0d6efd; }

    .delivery-profile-box {
        background: #f8fafc; border: 2px dashed #e2e8f0; border-radius: 20px; padding: 20px;
    }
    .profile-icon {
        width: 45px; height: 45px; background: #0d6efd; color: white;
        border-radius: 12px; display: flex; align-items: center; justify-content: center;
    }
    .fw-black { font-weight: 900; }
</style>

<div class="container py-5 checkout-wrapper">
    <div class="d-flex justify-content-between align-items-center mb-4 px-2">
        <h2 class="fw-bold mb-0 text-dark">Review Order</h2>
    </div>

    <div id="empty-cart-message" class="text-center py-5 bg-white rounded-4 shadow-sm" style="display: none;">
        <i class="fa-solid fa-basket-shopping display-1 text-light mb-4"></i>
        <h3 class="fw-bold">Your cart is empty</h3>
        <a href="/home" class="btn btn-primary rounded-pill px-5 mt-3">Go to Menu</a>
    </div>

    <div id="cart-content-area" style="display: none;">
        <div class="checkout-card">
            <div class="p-4 p-md-5">
                <h6 class="section-header">Ordering from <span id="res-name-display" class="text-primary fw-black">...</span></h6>
                <div id="cart-items-container"></div>
            </div>

            <div class="p-4 p-md-5 bg-light border-top border-bottom">
                <div class="row g-4">
                    <div class="col-md-6">
                        <h6 class="section-header">Add a Driver Tip</h6>
                        <div class="tip-chips-container">
                            <input type="radio" class="tip-chip-input" name="tipChoice" id="tip50" value="50" onchange="handleTipChange()">
                            <label class="tip-chip-label" for="tip50">Rs 50</label>
                            <input type="radio" class="tip-chip-input" name="tipChoice" id="tip100" value="100" onchange="handleTipChange()">
                            <label class="tip-chip-label" for="tip100">Rs 100</label>
                            <input type="radio" class="tip-chip-input" name="tipChoice" id="tip150" value="150" onchange="handleTipChange()">
                            <label class="tip-chip-label" for="tip150">Rs 150</label>
                            <input type="radio" class="tip-chip-input" name="tipChoice" id="tipCustom" value="custom" onchange="handleTipChange()">
                            <label class="tip-chip-label" for="tipCustom">Custom</label>
                        </div>
                        <div id="custom-tip-input-container" class="mt-3" style="display: none;">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-0 ps-3">Rs</span>
                                <input type="number" id="custom-tip-amount" class="form-control rounded-4 border-0 shadow-sm" placeholder="Enter amount" oninput="updateSummaryDisplay()">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <h6 class="section-header">Apply Coupon</h6>
                        <select id="coupon-selector" class="form-select rounded-4 border-0 shadow-sm p-3 fw-bold" onchange="updateSummaryDisplay()">
                            <option value="">Available Coupons</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="p-4 p-md-5 border-bottom" id="delivery-info-section" style="display: none;">
                <h6 class="section-header">Delivery Profile</h6>
                <div class="delivery-profile-box">
                    <div id="address-loading" class="text-center py-2"><div class="spinner-border spinner-border-sm text-primary"></div></div>
                    <div id="address-display-area" style="display: none;">
                        <div class="d-flex align-items-start">
                            <div class="profile-icon me-3"><i class="fa-solid fa-user-check"></i></div>
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between">
                                    <h6 class="fw-bold mb-1" id="display-name">---</h6>
                                    <button class="btn btn-link btn-sm p-0 text-decoration-none fw-bold" onclick="showAddressModal()">Change</button>
                                </div>
                                <p class="text-dark small mb-1"><i class="fa-solid fa-phone me-2 text-muted"></i><span id="display-mobile">---</span></p>
                                <p class="text-muted small mb-0"><i class="fa-solid fa-map-pin me-2 text-muted"></i><span id="display-address">---</span></p>
                            </div>
                        </div>
                    </div>
                    <div id="no-address-area" class="text-center py-2" style="display: none;">
                        <p class="text-muted small mb-3">No delivery address found on your profile.</p>
                        <button class="btn btn-outline-primary btn-sm rounded-pill px-4 fw-bold" onclick="showAddressModal()">+ Add Address</button>
                    </div>
                </div>
            </div>

            <div class="p-4 p-md-5">
                <h6 class="section-header">Payment Summary</h6>
                <div class="d-flex justify-content-between mb-3 text-secondary">
                    <span>Subtotal</span><span id="summary-subtotal" class="fw-bold">Rs 0.00</span>
                </div>
                <div class="d-flex justify-content-between mb-3 text-success fw-bold" id="discount-row" style="display:none !important;">
                    <span><i class="fa-solid fa-tag me-2"></i>Coupon Discount <button id="remove-coupon-btn" class="btn btn-link btn-sm text-danger p-0 ms-2 fw-bold text-decoration-none" style="display:none;" onclick="removeCoupon()">(Remove)</button></span>
                    <span id="summary-discount">-Rs 0.00</span>
                </div>
                <div class="d-flex justify-content-between mb-3 text-secondary">
                    <span>GST & Service Fees (9%)</span><span id="summary-tax" class="fw-bold">Rs 0.00</span>
                </div>
                <div class="d-flex justify-content-between mb-4 text-primary fw-bold">
                    <span>Driver Tip</span><span id="summary-tip">+Rs 0.00</span>
                </div>
                <div class="d-flex justify-content-between align-items-center pt-4 border-top">
                    <span class="fs-4 fw-black text-dark">Total Payable</span>
                    <span id="summary-total" class="fs-2 fw-black text-primary">Rs 0.00</span>
                </div>
                <button class="btn btn-primary btn-lg w-100 py-3 mt-5 rounded-pill fw-black shadow-lg" id="place-order-btn" onclick="placeOrder()">
                    Place Your Order <i class="fa-solid fa-chevron-right ms-2"></i>
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="orderSuccessModal" data-bs-backdrop="static" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-body text-center p-5">
                <div class="bg-success bg-opacity-10 text-success rounded-circle d-inline-flex align-items-center justify-content-center mb-4" style="width: 80px; height: 80px;">
                    <i class="fa-solid fa-check-double display-4"></i>
                </div>
                <h3 class="fw-bold text-dark">Order Placed!</h3>
                <p class="text-muted">Your delicious meal is now being processed by the restaurant.</p>
                <button type="button" class="btn btn-primary btn-lg w-100 rounded-pill fw-bold mt-3 shadow-sm" id="btn-redirect-order">OK, Got it!</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="addressModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header border-0 pb-0">
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-5 pt-0">
                <div class="text-center mb-4">
                    <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px;">
                        <i class="fa-solid fa-location-dot fs-3"></i>
                    </div>
                    <h4 class="fw-bold">Delivery Details</h4>
                    <p class="text-muted small">Where should we deliver your delicious meal?</p>
                </div>
                <form id="address-form">
                    <div class="mb-3">
                        <label class="small fw-bold text-muted mb-1">Receiver Name</label>
                        <input type="text" name="receiverName" class="form-control rounded-3 bg-light border-0" placeholder="e.g. John Doe" required>
                    </div>
                    <div class="mb-3">
                        <label class="small fw-bold text-muted mb-1">Mobile Number</label>
                        <input type="text" name="mobile" class="form-control rounded-3 bg-light border-0" placeholder="10-digit mobile number" required>
                    </div>
                    <div class="mb-3">
                        <label class="small fw-bold text-muted mb-1">Full Address</label>
                        <textarea name="address" class="form-control rounded-3 bg-light border-0" rows="2" placeholder="House No, Street, Area" required></textarea>
                    </div>
                    <div class="row g-2 mb-4">
                        <div class="col-6"><label class="small fw-bold text-muted mb-1">City</label><input type="text" name="city" class="form-control rounded-3 bg-light border-0" required></div>
                        <div class="col-6"><label class="small fw-bold text-muted mb-1">Zip Code</label><input type="text" name="zip" class="form-control rounded-3 bg-light border-0" required></div>
                    </div>
                    <button type="button" class="btn btn-primary btn-lg w-100 rounded-pill fw-bold shadow-sm" onclick="saveAddressAndOrder()">Save & Confirm Order</button>
                </form>
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
                <p class="text-muted" id="blocked-message">This restaurant has restricted your account from placing orders. Your cart has been cleared.</p>
                <button type="button" class="btn btn-danger btn-lg w-100 rounded-pill fw-bold mt-3 shadow-sm" onclick="window.location.href='/home'">
                    Back to Home
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    let globalCartData = null;
    let availableCoupons = [];
    let lastPlacedOrderId = null;
    let currentAddressId = null;

    $(document).ready(function() {
        fetchCart();
        loadCoupons();
        checkLoginState();

        $('#btn-redirect-order').click(function() {
            window.location.href = lastPlacedOrderId ? '/orderDetails?id=' + lastPlacedOrderId : '/orders';
        });
    });

    function getAuthHeaders() {
        const token = localStorage.getItem('token');
        let headers = {};
        if (token && token !== "null" && token !== "undefined") {
            headers['Authorization'] = 'Bearer ' + token;
        }
        return headers;
    }

    function completeLoginFlow() {
        const authModalEl = document.getElementById('authModal');
        if (authModalEl) {
            let modalInstance = bootstrap.Modal.getInstance(authModalEl) || new bootstrap.Modal(authModalEl);
            modalInstance.hide();
        }

        const guestId = localStorage.getItem('guestSessionId');
        const token = localStorage.getItem('token');

        if (guestId && token && token !== "null" && token !== "undefined") {
            $.ajax({
                url: '/api/cart/merge?guestId=' + guestId,
                type: 'POST',
                headers: getAuthHeaders(),
                success: function() {
                    localStorage.removeItem('guestSessionId');
                    checkLoginState();
                    fetchCart();
                },
                error: function(xhr) {
                    localStorage.removeItem('guestSessionId');

                    if (xhr.status === 403) {
                        // STOP everything else and show the modal
                        const response = xhr.responseJSON || {};
                        const errorMsg = response.error || "Access Restricted: You are blocked.";

                        $('#cart-content-area, #delivery-info-section').hide();
                        $('#blocked-message').text(errorMsg);

                        const blockedModal = new bootstrap.Modal(document.getElementById('blockedUserModal'));
                        blockedModal.show();
                    } else {
                        // Only proceed if it wasn't a security block
                        checkLoginState();
                        fetchCart();
                    }
                }
            });
        } else {
            checkLoginState();
            fetchCart();
        }
    }

    function checkLoginState() {
        const token = localStorage.getItem('token');
        if (token && token !== "null" && token !== "undefined") {
            $('#delivery-info-section').show();
            fetchUserAddress();
        } else {
            $('#delivery-info-section').hide();
        }
    }

    function fetchUserAddress() {
        const token = localStorage.getItem('token');
        if (!token) return;

        $('#address-loading').show();
        $('#address-display-area, #no-address-area').hide();

        $.ajax({
            url: '/api/user/address/get-latest',
            type: 'GET',
            headers: getAuthHeaders(),
            success: function(data) {
                $('#address-loading').hide();
                if (data && data.address && data.id) {
                    currentAddressId = data.id;
                    $('#display-name').text(data.receiverName || "Customer");
                    $('#display-mobile').text(data.mobile || "N/A");
                    $('#display-address').text(data.address + ", " + (data.city || "") + " (" + (data.zip || "") + ")");
                    $('#address-display-area').show();
                    $('#no-address-area').hide();
                } else {
                    currentAddressId = null;
                    $('#no-address-area').show();
                }
            },
            error: function() {
                $('#address-loading').hide();
                $('#no-address-area').show();
            }
        });
    }

    function fetchCart() {
        const guestId = localStorage.getItem('guestSessionId');
        let url = '/api/cart';
        const token = localStorage.getItem('token');

        if (!token || token === "null" || token === "undefined") {
            if (guestId) {
                url += '?guestId=' + guestId;
            }
        }

        $.ajax({
            url: url,
            type: 'GET',
            headers: getAuthHeaders(),
            success: function(cart) {
                globalCartData = cart;
                renderCartUI(cart);
                refreshCouponDropdown();
            },
            error: function(xhr) {
                if (xhr.status === 403) {
                    let errorMsg = xhr.responseJSON?.error || "Access Restricted: You are blocked by this restaurant.";

                    $('#cart-content-area').hide();
                    $('#empty-cart-message').hide();
                    $('#delivery-info-section').hide();

                    $('#blocked-message').text(errorMsg);
                    const blockedModalEl = document.getElementById('blockedUserModal');
                    const blockedModal = bootstrap.Modal.getInstance(blockedModalEl) || new bootstrap.Modal(blockedModalEl);
                    blockedModal.show();
                } else {
                    $('#cart-content-area').hide();
                    $('#empty-cart-message').show();
                }
            }
        });
    }

    function renderCartUI(cart) {
        const container = $('#cart-items-container');
        container.empty();
        if (typeof updateCartUI === "function") {
            updateCartUI(cart);
        }
        if (!cart || !cart.items || cart.items.length === 0) {
            $('#cart-content-area').hide();
            $('#empty-cart-message').show();
            return;
        }
        $('#cart-content-area').show();
        $('#empty-cart-message').hide();
        $('#res-name-display').text(cart.restaurantName || "Our Local Kitchen");

        cart.items.forEach(item => {
            const demoImg = item.imageUrl || "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=150";
            // NOTICE THE BACKSLASHES BELOW
            container.append(`
                <div class="item-row d-flex align-items-center">
                    <img src="\${demoImg}" class="product-img me-3 shadow-sm">
                    <div class="flex-grow-1">
                        <h6 class="fw-bold mb-1 text-dark">\${item.name}</h6>
                        <p class="text-muted small mb-0">Rs \${item.price.toFixed(2)}</p>
                    </div>
                    <div class="d-flex align-items-center">
                        <div class="qty-capsule me-4">
                            <button class="btn-circle" onclick="updateItem(\${item.id}, -1)">-</button>
                            <span class="px-3 fw-bold">\${item.quantity}</span>
                            <button class="btn-circle" onclick="updateItem(\${item.id}, 1)">+</button>
                        </div>
                        <span class="fw-bold text-dark text-end" style="min-width: 90px;">
                            Rs \${(item.price * item.quantity).toFixed(2)}
                        </span>
                    </div>
                </div>`);
        });
        updateSummaryDisplay();
    }

    function updateItem(itemId, change) {
        const guestId = localStorage.getItem('guestSessionId');
        // NOTICE THE BACKSLASHES BELOW
        let url = `/api/cart/update/\${itemId}?change=\${change}`;
        const token = localStorage.getItem('token');

        if (!token || token === "null" || token === "undefined") {
            if (guestId) url += '&guestId=' + guestId;
        }

        $.ajax({
            url: url,
            type: 'PUT',
            headers: getAuthHeaders(),
            success: cart => {
                globalCartData = cart;
                renderCartUI(cart);
                refreshCouponDropdown();
            },
            error: function(xhr) {
                if (xhr.status === 403) {
                    let errorMsg = xhr.responseJSON?.error || "Access Restricted.";

                    $('#cart-content-area').hide();
                    $('#empty-cart-message').hide();
                    $('#blocked-message').text(errorMsg);

                    const blockedModalEl = document.getElementById('blockedUserModal');
                    const blockedModal = bootstrap.Modal.getInstance(blockedModalEl) || new bootstrap.Modal(blockedModalEl);
                    blockedModal.show();
                }
            }
        });
    }

    function handleTipChange() {
        const val = $('input[name="tipChoice"]:checked').val();
        $('#custom-tip-input-container').toggle(val === 'custom');
        if (val !== 'custom') $('#custom-tip-amount').val('');
        updateSummaryDisplay();
    }

    function updateSummaryDisplay() {
        if (!globalCartData) return;
        const sub = globalCartData.grandTotal || 0;
        const tax = sub * 0.09;
        let tip = 0;
        const choice = $('input[name="tipChoice"]:checked').val();
        tip = choice === 'custom' ? (parseFloat($('#custom-tip-amount').val()) || 0) : (parseFloat(choice) || 0);

        const sel = $('#coupon-selector option:selected');
        let disc = 0;
        if (sel.val()) {
            disc = (sel.data('type') === "PERCENTAGE") ? (sub * (parseFloat(sel.data('value')) / 100)) : parseFloat(sel.data('value'));
            disc = Math.min(disc, sub);
            $('#discount-row').attr('style', 'display: flex !important');
            $('#remove-coupon-btn').show();
        } else {
            $('#discount-row').hide();
        }

        $('#summary-subtotal').text('Rs ' + sub.toFixed(2));
        $('#summary-tax').text('Rs ' + tax.toFixed(2));
        $('#summary-discount').text('-Rs ' + disc.toFixed(2));
        $('#summary-tip').text('+Rs ' + tip.toFixed(2));
        $('#summary-total').text('Rs ' + Math.max(0, sub + tax + tip - disc).toFixed(2));
    }

    function placeOrder() {
        const token = localStorage.getItem('token');
        if (!token || token === "null" || token === "undefined") {
            const m = document.getElementById('authModal');
            if (m) {
                const modal = bootstrap.Modal.getInstance(m) || new bootstrap.Modal(m);
                modal.show();
            } else {
                alert("Please login to place your order.");
            }
            return;
        }
        if ($('#no-address-area').is(':visible') || !currentAddressId) {
            showAddressModal();
            return;
        }
        executeOrderSubmission();
    }

    function saveAddressAndOrder() {
        const formData = {};
        $('#address-form').serializeArray().forEach(item => { formData[item.name] = item.value; });

        if (!formData.address || !formData.mobile || !formData.receiverName) {
            alert("All address details are required.");
            return;
        }

        const btn = $('#address-form button');
        const originalText = btn.text();
        btn.prop('disabled', true).text("Saving...");

        $.ajax({
            url: '/api/user/address/save',
            type: 'POST',
            headers: getAuthHeaders(),
            contentType: 'application/json',
            data: JSON.stringify(formData),
            success: function(saved) {
                if (saved && saved.id) {
                    currentAddressId = saved.id;
                    const modalEl = document.getElementById('addressModal');
                    const modalInstance = bootstrap.Modal.getInstance(modalEl);
                    if (modalInstance) modalInstance.hide();

                    executeOrderSubmission();
                } else {
                    btn.prop('disabled', false).text(originalText);
                    alert("Error: Server did not return a valid Address ID.");
                }
            },
            error: function(xhr) {
                btn.prop('disabled', false).text(originalText);
                if (xhr.status === 403) {
                    let errorMsg = xhr.responseJSON?.error || "Access Restricted.";

                    $('#cart-content-area').hide();
                    $('#empty-cart-message').hide();
                    $('#blocked-message').text(errorMsg);

                    const modalEl = document.getElementById('addressModal');
                    const modalInstance = bootstrap.Modal.getInstance(modalEl);
                    if(modalInstance) modalInstance.hide();

                    const blockedModalEl = document.getElementById('blockedUserModal');
                    const blockedModal = bootstrap.Modal.getInstance(blockedModalEl) || new bootstrap.Modal(blockedModalEl);
                    blockedModal.show();
                } else {
                    alert("Error saving address: " + (xhr.responseJSON?.message || "Server Error"));
                }
            }
        });
    }

    function executeOrderSubmission() {
        if (!currentAddressId) {
            showAddressModal();
            return;
        }
        const tipVal = $('input[name="tipChoice"]:checked').val();
        let tip = (tipVal === 'custom') ? parseFloat($('#custom-tip-amount').val()) : parseFloat(tipVal);

        const req = {
            restaurantId: globalCartData.restaurantId,
            items: globalCartData.items.map(i => ({ productId: i.productId, quantity: i.quantity })),
            couponCode: $('#coupon-selector').val() || null,
            tipAmount: tip || 0,
            addressId: currentAddressId
        };

        $.ajax({
            url: '/api/orders/place',
            type: 'POST',
            headers: getAuthHeaders(),
            contentType: 'application/json',
            data: JSON.stringify(req),
            success: (res) => {
                localStorage.removeItem('guestSessionId');
                lastPlacedOrderId = res.id || null;
                const successModalEl = document.getElementById('orderSuccessModal');
                const successModal = bootstrap.Modal.getInstance(successModalEl) || new bootstrap.Modal(successModalEl);
                successModal.show();
            },
            error: function(xhr) {
                if (xhr.status === 403) {
                    let errorMsg = xhr.responseJSON?.error || "Access Restricted.";

                    $('#cart-content-area').hide();
                    $('#empty-cart-message').hide();
                    $('#blocked-message').text(errorMsg);

                    const blockedModalEl = document.getElementById('blockedUserModal');
                    const blockedModal = bootstrap.Modal.getInstance(blockedModalEl) || new bootstrap.Modal(blockedModalEl);
                    blockedModal.show();
                } else {
                    alert("Order failed: " + (xhr.responseJSON?.message || "Internal Error"));
                }
            }
        });
    }

    function showAddressModal() {
        const modalEl = document.getElementById('addressModal');
        const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
        modal.show();
    }

    function loadCoupons() {
        $.get('/api/cart/available', c => {
            availableCoupons = c;
            refreshCouponDropdown();
        });
    }

    function refreshCouponDropdown() {
        const selector = $('#coupon-selector');
        const sub = globalCartData ? (globalCartData.grandTotal || 0) : 0;

        selector.empty().append('<option value="">Available Coupons</option>');

        if (availableCoupons) {
            availableCoupons.forEach(c => {
                const isAvailable = sub >= c.minimumOrderAmount;
                let typeLabel = "";
                // NOTICE THE BACKSLASHES BELOW
                if (c.couponType === "FLAT") {
                    typeLabel = `(Rs \${c.couponValue})`;
                } else if (c.couponType === "PERCENTAGE") {
                    typeLabel = `(\${c.couponValue}%)`;
                }

                let displayText = `\${c.couponCode} \${typeLabel}`;

                if (!isAvailable) {
                    displayText += ` (Min. Rs \${c.minimumOrderAmount})`;
                }

                selector.append(`
                    <option value="\${c.couponCode}"
                            data-value="\${c.couponValue}"
                            data-type="\${c.couponType}"
                            \${!isAvailable ? 'disabled' : ''}>
                        \${displayText}
                    </option>
                `);
            });
        }
    }

    function removeCoupon() {
        $('#coupon-selector').val('');
        updateSummaryDisplay();
    }
</script>