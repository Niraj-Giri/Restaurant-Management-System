<style>
    .order-details-wrapper { max-width: 800px; margin: 0 auto; }
    .receipt-card {
        background: #ffffff; border-radius: 28px;
        box-shadow: 0 15px 35px rgba(0,0,0,0.05);
        border: 1px solid rgba(0,0,0,0.05); overflow: hidden;
        position: relative;
    }
    .receipt-card::after {
        content: ""; position: absolute; bottom: 0; left: 0; right: 0;
        height: 10px; background-size: 20px 20px; background-repeat: repeat-x;
        background-image: linear-gradient(-45deg, transparent 10px, #f8fafc 10px),
        linear-gradient(45deg, transparent 10px, #f8fafc 10px);
    }
    .status-badge {
        padding: 6px 16px; border-radius: 50px; font-weight: 800; font-size: 0.75rem;
        text-transform: uppercase; letter-spacing: 1px;
    }
    .status-placed { background: #e0f2fe; color: #0369a1; }
    .status-processing { background: #fef9c3; color: #854d0e; }
    .status-in_route { background: #fae8ff; color: #86198f; }
    .status-delivered { background: #dcfce7; color: #15803d; }
    .status-canceled { background: #fee2e2; color: #b91c1c; }

    .status-msg-box {
        background: #f8fafc; border-left: 4px solid #0d6efd;
        padding: 15px; border-radius: 8px; margin-bottom: 20px;
    }
    .item-list-row { padding: 1.25rem 0; border-bottom: 1px solid #f1f5f9; }
    .letter-spacing-2 {
        letter-spacing: 0.5rem;
        padding-left: 0.5rem; /* Ensures the text remains centered despite the trailing letter spacing */
    }
</style>

<div class="container py-5 order-details-wrapper">
    <div class="d-flex justify-content-between align-items-center mb-4 px-2">
        <div>
            <a href="/orders" class="text-decoration-none small fw-bold text-primary">
                <i class="fa-solid fa-chevron-left me-1"></i> My Orders
            </a>
            <h2 class="fw-black text-dark mt-2">Order #<span id="order-id-num">...</span></h2>
        </div>
        <div class="d-flex align-items-center gap-3">
            <div id="order-status" class="status-badge">...</div>
            <button id="cancel-btn" class="btn btn-outline-danger btn-sm rounded-pill px-3 fw-bold"
                    style="display: none;" onclick="checkStatusBeforeCancel()">
                Cancel Order
            </button>
        </div>
    </div>

    <div class="status-msg-box" id="status-msg-container">
        <i class="fa-solid fa-info-circle me-2 text-primary"></i>
        <span id="status-description" class="fw-bold text-dark">Updating order status...</span>
    </div>

    <div class="receipt-card mb-5">
        <div class="p-4 p-md-5 border-bottom">
            <h6 class="text-uppercase opacity-50 small fw-bold mb-3">Delivery To</h6>
            <div class="d-flex align-items-start">
                <i class="fa-solid fa-location-dot mt-1 text-danger me-3 fs-5"></i>
                <div>
                    <h5 class="fw-bold mb-1" id="delivery-name">---</h5>
                    <p class="text-muted mb-1" id="delivery-phone">---</p>
                    <p class="text-dark fw-medium mb-0" id="delivery-address">---</p>
                </div>
            </div>
        </div>

        <div class="p-4 p-md-5 border-bottom bg-light">
            <h6 class="text-uppercase opacity-50 small fw-bold mb-3">Restaurant Details</h6>
            <h4 class="fw-bold text-dark mb-1" id="res-name">Loading...</h4>
            <p class="text-muted small mb-0"><i class="fa-regular fa-clock me-2"></i>Placed on: <span id="order-time">...</span></p>
        </div>
        <div id="otp-display-container" class="p-4 p-md-5 border-bottom text-center" style="display: none; background: #f0f7ff;">
            <h6 class="text-uppercase opacity-50 small fw-bold mb-3">Delivery Verification OTP</h6>
            <div class="d-inline-block p-3 rounded-4 bg-white shadow-sm border border-primary border-2">
                <span id="order-otp-val" class="fs-1 fw-black text-primary letter-spacing-2" style="letter-spacing: 0.5rem;">0000</span>
            </div>
            <p class="text-muted small mt-3 mb-0">Share this code with the delivery partner to receive your order.</p>
        </div>

        <div class="p-4 p-md-5">
            <h6 class="text-uppercase opacity-50 small fw-bold mb-3">Your Items</h6>
            <div id="order-items-list"></div>
        </div>

        <div class="p-4 p-md-5 bg-light border-top" style="padding-bottom: 60px !important;">
            <h6 class="text-uppercase opacity-50 small fw-bold mb-3">Bill Details</h6>
            <div class="d-flex justify-content-between mb-2">
                <span class="text-secondary">Subtotal</span>
                <span class="fw-bold" id="bill-subtotal">Rs 0.00</span>
            </div>
            <div class="d-flex justify-content-between mb-2 text-success fw-bold" id="bill-discount-row" style="display: none;">
                <span>Discount</span>
                <span id="bill-discount-val">-Rs 0.00</span>
            </div>
            <div class="d-flex justify-content-between mb-2">
                <span class="text-secondary">Taxes & Fees (<span id="tax-rate-val">0</span>%)</span>
                <span class="fw-bold" id="bill-tax">Rs 0.00</span>
            </div>
            <div class="d-flex justify-content-between mb-4">
                <span class="text-secondary">Delivery Tip</span>
                <span class="fw-bold text-primary" id="bill-tip">Rs 0.00</span>
            </div>
            <div class="d-flex justify-content-between align-items-center pt-4 border-top">
                <span class="fs-4 fw-black text-dark">Amount Paid</span>
                <span class="fs-2 fw-black text-primary" id="bill-total">Rs 0.00</span>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="cancelConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow rounded-4">
            <div id="modal-view-checking" class="modal-body text-center p-5">
                <div class="spinner-border text-primary mb-3" role="status"></div>
                <h4 class="fw-bold">Checking Order Status...</h4>
            </div>

            <div id="modal-view-confirmation" class="modal-body text-center p-5" style="display: none;">
                <div class="text-danger mb-4"><i class="fa-solid fa-circle-exclamation display-4"></i></div>
                <h4 class="fw-bold mb-3">Cancel this order?</h4>
                <p class="text-muted mb-4">Are you sure? This action cannot be reversed.</p>
                <div class="d-grid gap-2">
                    <button type="button" class="btn btn-danger btn-lg rounded-pill fw-bold" id="confirm-cancel-btn" onclick="executeCancellation()">Yes, Cancel Order</button>
                    <button type="button" class="btn btn-light btn-lg rounded-pill fw-bold" data-bs-dismiss="modal">No, Keep it</button>
                </div>
            </div>

            <div id="modal-view-error" class="modal-body text-center p-5" style="display: none;">
                <div class="text-warning mb-4"><i class="fa-solid fa-clock-rotate-left display-4"></i></div>
                <h4 class="fw-bold mb-3">Cannot Cancel Order</h4>
                <p id="cancel-error-msg" class="text-muted mb-4"></p>
                <button type="button" class="btn btn-primary btn-lg w-100 rounded-pill fw-bold" onclick="location.reload()">OK</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        const urlParams = new URLSearchParams(window.location.search);
        const orderId = urlParams.get('id');
        if (orderId) loadOrderDetails(orderId);
    });

    function loadOrderDetails(id) {
        const token = localStorage.getItem('token');

        if (!token) {
            console.error("No token found, redirecting to login...");
            window.location.href = '/login';
            return;
        }

        $('#res-name').text("Loading your meal...");

        $.ajax({
            // Use string concatenation to avoid JSP Expression Language conflicts
            url: "/api/orders/" + id,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(order) {
                console.log("Order data received:", order);
                if (order && order.id) {
                    fetchDeliveryAddress(token, order);
                } else {
                    console.warn("Order object is empty, redirecting...");
                    window.location.href = '/orders';
                }
            },
            error: function(xhr) {
                console.error("Order API Error:", xhr.status, xhr.responseText);
                // Temporary: Comment out the next line to debug without being redirected
                // window.location.href = '/orders';
            }
        });
    }
    function fetchDeliveryAddress(token, order) {
        $.ajax({
            url: '/api/user/address/get-latest', // Your address API
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(addressData) {
                // Now we have BOTH: 'order' and 'addressData'
                renderDetails(order, addressData);
            },
            error: function() {
                // Fallback if address API fails
                renderDetails(order, null);
            }
        });
    }

    function renderDetails(order, addressData) {
        // 1. Basic Order Info
        $('#order-id-num').text(order.id);
        $('#res-name').text(order.restaurant.name);
        $('#order-time').text(new Date(order.createdAt).toLocaleString('en-GB', {
            day: '2-digit', month: 'short', year: 'numeric',
            hour: '2-digit', minute: '2-digit', hour12: true
        }));

        // 2. OTP Display Logic
        // We show the OTP once it is generated (ASSIGNED) until it is completed
        const showOtpStatuses = ["PROCESSING", "ASSIGNED", "IN_ROUTE"];
        if (order.otp && showOtpStatuses.includes(order.status)) {
            $('#order-otp-val').text(order.otp);
            $('#otp-display-container').show();
        } else {
            $('#otp-display-container').hide();
        }

        // 3. Mapping Address Data
        if (addressData) {
            $('#delivery-name').text(addressData.receiverName || "Customer");
            $('#delivery-phone').text(addressData.mobile || "N/A");

            // Clean multiline address and add landmark if available
            let fullAddress = addressData.address ? addressData.address.replace(/\r\n|\r|\n/g, ', ') : '';
            if (addressData.landmark) fullAddress += ` (Landmark: ${addressData.landmark})`;
            if (addressData.city) fullAddress += `, ${addressData.city}`;
            if (addressData.zip) fullAddress += ` - ${addressData.zip}`;

            $('#delivery-address').text(fullAddress);
        } else {
            $('#delivery-address').text("Address details unavailable");
        }

        // 4. Status & Messaging Logic
        const status = order.status;
        const badge = $('#order-status');
        const msg = $('#status-description');

        badge.text(status).removeClass().addClass('status-badge status-' + status.toLowerCase());

        if (status === "PLACED") {
            $('#cancel-btn').show();
            msg.text("Your order has been received and is waiting for the restaurant to confirm.");
        } else {
            $('#cancel-btn').hide();
            switch(status) {
                case "PROCESSING":
                    msg.text("Great news! The restaurant is currently preparing your meal.");
                    break;
                case "ASSIGNED":
                    msg.text("A delivery partner has been assigned to your order.");
                    break;
                case "IN_ROUTE":
                    msg.text("Your food is on the way! Please share your OTP with the rider upon arrival.");
                    break;
                case "DELIVERED":
                case "RECEIVED":
                    msg.text("Order delivered. Enjoy your meal!");
                    break;
                case "CANCELED":
                    msg.text("This order was cancelled.");
                    break;
                default:
                    msg.text("Order is currently " + status);
            }
        }

        // 5. Bill Rendering (Rounded to nearest whole number as requested)
        const subtotal = order.totalAmount || 0;
        const discount = order.appliedCouponValue || 0;
        const taxRate = order.taxRate || 9;
        const tax = order.taxAmount || ((subtotal - discount) * (taxRate / 100));
        const tip = order.tipAmount || 0;
        const grandTotal = order.totalAmountAfterTax || (subtotal - discount + tax + tip);

        $('#bill-subtotal').text("Rs " + Math.round(subtotal));
        $('#bill-tax').text("Rs " + Math.round(tax));
        $('#tax-rate-val').text(taxRate);
        $('#bill-tip').text("Rs " + Math.round(tip));
        $('#bill-total').text("Rs " + Math.round(grandTotal));

        if (discount > 0) {
            $('#bill-discount-row').show();
            $('#bill-discount-val').text("-Rs " + Math.round(discount));
        }


        // 6. Items List
        const itemsList = $('#order-items-list').empty();
        order.items.forEach(item => {
            itemsList.append(`
            <div class="item-list-row d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="fw-bold mb-0 text-dark">\${item.product.name}</h6>
                    <span class="text-muted small">Qty: \${item.quantity}</span>
                </div>
                <span class="fw-bold text-dark">Rs \${Math.round(item.priceAtPurchase * item.quantity)}</span>
            </div>`);
        });
    }

    function checkStatusBeforeCancel() {
        const orderId = $('#order-id-num').text();
        const token = localStorage.getItem('token');

        // Show the modal and reset to "Checking" view
        const cancelModal = new bootstrap.Modal(document.getElementById('cancelConfirmModal'));
        $('#modal-view-checking').show();
        $('#modal-view-confirmation, #modal-view-error').hide();
        cancelModal.show();

        $.ajax({
            url: `/api/orders/\${orderId}/status`,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(status) {
                $('#modal-view-checking').hide();

                if (status === "PLACED") {
                    // If still placed, show confirmation buttons
                    $('#modal-view-confirmation').show();
                } else {
                    // If status changed (e.g., PROCESSING), show the error view
                    let reason = "Order is already " + status.toLowerCase() + ".";
                    if (status === "PROCESSING") reason = "The kitchen has already started preparing your food.";
                    if (status === "IN_ROUTE") reason = "Your order is already with the delivery partner.";

                    $('#cancel-error-msg').text(reason);
                    $('#modal-view-error').show();
                }
            },
            error: function() {
                $('#modal-view-checking').hide();
                $('#cancel-error-msg').text("Could not verify order status. Please try again.");
                $('#modal-view-error').show();
            }
        });
    }

    function executeCancellation() {
        const orderId = $('#order-id-num').text();
        const token = localStorage.getItem('token');
        const btn = $('#confirm-cancel-btn');

        btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm"></span> Cancelling...');

        $.ajax({
            url: `/api/orders/\${orderId}/cancel`,
            type: 'PUT',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function() {
                location.reload();
            },
            error: function(xhr) {
                // Final safety catch in case status changed in the split second before clicking 'Yes'
                $('#modal-view-confirmation').hide();
                $('#cancel-error-msg').text(xhr.responseText || "Cancellation failed.");
                $('#modal-view-error').show();
            }
        });
    }
</script>