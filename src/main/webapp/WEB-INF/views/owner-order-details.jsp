<script>
    (function() {
        const token = localStorage.getItem('token');
        const role = localStorage.getItem('role');
        if (!token || role !== 'ROLE_RESTAURANT_OWNER') window.location.href = '/owner/login';
    })();
</script>

<style>
    .order-details-wrapper { max-width: 850px; margin: 0 auto; }

    /* Status Progress Tracker */
    .status-tracker {
        display: flex; justify-content: space-between; margin-bottom: 2rem;
        background: #fff; padding: 20px; border-radius: 15px; box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    }
    .status-step {
        flex: 1; text-align: center; position: relative; font-size: 0.7rem;
        font-weight: 800; color: #cbd5e1; text-transform: uppercase;
    }
    .status-step i { display: block; font-size: 1.2rem; margin-bottom: 5px; }
    .status-step.active { color: #0d6efd; }
    .status-step.completed { color: #10b981; }
    .status-step:not(:last-child)::after {
        content: "\f061"; font-family: "Font Awesome 6 Free"; position: absolute;
        top: 25%; right: -10%; color: #e2e8f0;
    }

    /* Owner Action Panel */
    .action-panel { background: #eff6ff; border: 2px dashed #bfdbfe; border-radius: 20px; padding: 25px; margin-bottom: 2rem; }
    .receipt-card { background: #ffffff; border-radius: 28px; box-shadow: 0 15px 35px rgba(0,0,0,0.05); overflow: hidden; }
    .item-list-row { padding: 1rem 0; border-bottom: 1px solid #f1f5f9; }

    /* --- EXACT ARROW STEPS DESIGN --- */
    .arrow-steps {
        display: flex;
        margin-bottom: 2.5rem;
        border-radius: 4px;
        overflow: hidden;
    }


    .arrow-steps .step {
        flex: 1;
        position: relative;
        text-align: center;
        padding: 14px 10px;
        background-color: #e0e7ff; /* Light Blue for future steps */
        color: #64748b;
        font-weight: 800;
        font-size: 0.8rem;
        text-transform: uppercase;
        margin-right: 5px; /* Creates the white gap */
        transition: background-color 0.3s ease;
    }

    /* Pushes text to the right so it doesn't overlap the arrow cutout */
    .arrow-steps .step:not(:first-child) {
        padding-left: 25px;
    }

    /* The Right-facing Arrow Point */
    .arrow-steps .step:not(:last-child)::after {
        content: '';
        position: absolute;
        top: 0;
        right: -15px;
        width: 0;
        height: 0;
        border-top: 22px solid transparent; /* Half of height */
        border-bottom: 22px solid transparent; /* Half of height */
        border-left: 15px solid #e0e7ff; /* Matches background */
        z-index: 2;
        transition: border-left-color 0.3s ease;
    }

    /* The Left-facing Cutout (Indentation) */
    .arrow-steps .step:not(:first-child)::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 0;
        height: 0;
        border-top: 22px solid transparent;
        border-bottom: 22px solid transparent;
        border-left: 15px solid #fff; /* White background to create cutout */
        z-index: 1;
    }

    /* --- STATES: 'current' and 'done' --- */
    .arrow-steps .step.current,
    .arrow-steps .step.done {
        background-color: #1e3a8a; /* Dark Blue */
        color: #fff;
    }

    /* Change the arrow point color to match the Dark Blue background */
    .arrow-steps .step.current::after,
    .arrow-steps .step.done::after {
        border-left-color: #1e3a8a;
    }
</style>

<div class="container py-5 order-details-wrapper">
    <div class="mb-4 d-flex justify-content-between align-items-end">
        <div>
<%--            <a href="/owner/today-orders" class="text-decoration-none small fw-bold text-primary">--%>
<%--                <i class="fa-solid fa-chevron-left me-1"></i> Dashboard--%>
<%--            </a>--%>
            <h2 class="fw-black text-dark mt-2 mb-0">Order #<span id="order-id-num">...</span></h2>
        </div>
    </div>

    <div class="arrow-steps clearfix shadow-sm">
        <div class="step" id="step-PLACED"> <span>PLACED</span> </div>
        <div class="step" id="step-PROCESSING"> <span>Processing</span> </div>
        <div class="step" id="step-ASSIGNED"> <span>Assigned</span> </div>
        <div class="step" id="step-IN_ROUTE"> <span>In Route</span> </div>
        <div class="step" id="step-DELIVERED"> <span>Delivered</span> </div>
        <div class="step" id="step-RECEIVED"> <span>Received</span> </div>
    </div>

    <div class="action-panel text-center" id="owner-action-panel">

        <div id="state-placed" style="display:none;">
            <h5 class="fw-bold text-primary mb-3">New Order Received</h5>
            <button class="btn btn-primary btn-lg rounded-pill px-5 fw-bold shadow-sm" onclick="handleStatusUpdate('PROCESSING')">
                <i class="fa-solid fa-fire-burner me-2"></i>Start Preparation
            </button>
        </div>

        <div id="state-processing" style="display:none;">
            <h5 class="fw-bold text-warning mb-3"><i class="fa-solid fa-motorcycle me-2"></i>Assign Delivery Partner</h5>
            <div class="d-flex justify-content-center gap-2 mx-auto" style="max-width: 400px;">
                <select id="staff-selector" class="form-select border-0 shadow-sm rounded-pill px-4 fw-bold">
                    <option value="">Loading staff...</option>
                </select>
                <button id="btn-assign" class="btn btn-success rounded-pill px-4 fw-bold shadow-sm" onclick="assignAndDispatch()">
                    Dispatch
                </button>
            </div>
        </div>

        <div id="state-in-route" style="display:none;">
            <div class="bg-white p-4 rounded-4 shadow-sm border border-light mx-auto" style="max-width: 450px;">
                <h5 class="fw-bold text-dark mb-1" id="delivery-status-msg"><i class="fa-solid fa-person-biking text-primary me-2"></i>Waiting for Delivery</h5>
                <p class="text-muted small fw-bold mb-3">Assigned to: <span id="assigned-staff-name" class="text-primary">Loading...</span></p>

                <div class="d-flex justify-content-between align-items-center bg-light p-3 rounded-3 border">
                    <span class="fw-bold text-secondary text-uppercase small">OTP</span>
                    <span class="fs-3 fw-black text-primary" style="letter-spacing: 4px;" id="display-otp">----</span>
                </div>
            </div>
        </div>

        <p id="canceled-msg" class="text-danger fw-bold mt-2 mb-0" style="display:none;">This order was cancelled by the customer.</p>
    </div>

    <div class="receipt-card">
        <div class="p-4 border-bottom">
            <h6 class="text-uppercase opacity-50 small fw-bold mb-3">Customer Information</h6>
            <div class="d-flex align-items-start">
                <i class="fa-solid fa-user-circle text-primary me-3 fs-3"></i>
                <div>
                    <h5 class="fw-bold mb-1" id="cust-name">Loading...</h5>
                    <p class="text-muted mb-1" id="cust-phone">---</p>
                    <p class="text-dark fw-medium mb-0" id="cust-address"><i class="fa-solid fa-location-dot me-2 text-danger"></i>---</p>

                </div>
            </div>
        </div>

        <div class="p-4">
            <h6 class="text-uppercase opacity-50 small fw-bold mb-3">Order Items</h6>
            <div id="order-items-list"></div>
        </div>
        <div class="p-4 p-md-5 bg-light border-top">
            <h6 class="text-uppercase opacity-50 small fw-bold mb-3">Bill Summary</h6>
            <div class="d-flex justify-content-between mb-2">
                <span class="text-secondary">Subtotal</span><span class="fw-bold" id="bill-subtotal">Rs 0.00</span>
            </div>
            <div class="d-flex justify-content-between mb-2 text-success fw-bold" id="bill-discount-row" style="display: none;">
                <span>Coupon Discount</span><span id="bill-discount-val">- Rs 0.00</span>
            </div>
            <div class="d-flex justify-content-between mb-2 text-primary fw-bold" id="bill-tip-row" style="display: none;">
                <span>Driver Tip</span><span id="bill-tip-val">+ Rs 0.00</span>
            </div>
            <div class="d-flex justify-content-between align-items-center pt-4 border-top">
                <span class="fs-4 fw-black text-dark">Total</span><span class="fs-2 fw-black text-primary" id="bill-total">Rs 0.00</span>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="ownerAlertModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-body text-center p-5">
                <h4 class="fw-bold mb-3" id="alert-modal-title">Notice</h4>
                <p class="text-muted mb-4" id="alert-modal-msg">Something went wrong.</p>
                <button type="button" class="btn btn-primary btn-lg w-100 rounded-pill fw-bold" data-bs-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>

<script>
    let currentOrder = null;


    $(document).ready(function() {
        const orderId = new URLSearchParams(window.location.search).get('id');
        if (orderId) loadOrderForOwner(orderId);
    });

    function loadOrderForOwner(id) {
        const token = localStorage.getItem('token');
        $.ajax({
            url: "/api/orders/" + id,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(order) {
                currentOrder = order;
                renderOwnerView(order);

                // CORRECT: Pass the ORDER ID (order.id), not the customer id
                if (order && order.id) {
                    fetchCustomerAddress(order.id, token);
                }
            }
        });
    }

    function renderOwnerView(order) {
        $('#order-id-num').text(order.id);

        // 1. Updated Stepper Logic
        const steps = ["PLACED", "PROCESSING", "ASSIGNED", "IN_ROUTE", "DELIVERED", "RECEIVED"];
        const currentIndex = steps.indexOf(order.status);

        steps.forEach((step, idx) => {
            const stepEl = $('#step-' + step);
            stepEl.removeClass('current done');
            if(idx < currentIndex) stepEl.addClass('done');
            if(idx === currentIndex) stepEl.addClass('current');
        });

        // 2. Initial Reset
        $('#state-placed, #state-processing, #state-in-route, #canceled-msg').hide();

        // 3. Status Logic
        if (order.status === "PLACED") {
            $('#state-placed').show();
        }
        else if (order.status === "PROCESSING") {
            $('#state-processing').show();
            loadStaffDropdown(order.restaurant.id);
        }
        // Handle ASSIGNED and IN_ROUTE through the tracking fetch
        else if (order.status === "ASSIGNED" || order.status === "IN_ROUTE") {
            $('#state-in-route').show();
            fetchTrackingDetails(order.id); // This will handle the sub-status logic
        }
        else if (order.status === "DELIVERED" || order.status === "RECEIVED") {
            $('#state-in-route').show();
            $('#delivery-status-msg').html('<i class="fa-solid fa-check-double text-success me-2"></i>Delivery Completed');
            $('#display-otp').text('DONE');
            fetchTrackingDetails(order.id);
        }
        else if (order.status === "CANCELED") {
            $('#canceled-msg').show();
        }

        // Render Items & Bill (Same as before)
        const itemsList = $('#order-items-list').empty();
        if (order.items) {
            order.items.forEach(item => {
                const itemPrice = item.priceAtPurchase || 0;
                const productName = item.product ? item.product.name : "Item";
                itemsList.append(`<div class="item-list-row d-flex justify-content-between"><div><h6 class="fw-bold mb-0">\${productName}</h6><small>Qty: \${item.quantity}</small></div><span class="fw-bold">Rs \${(itemPrice * item.quantity).toFixed(2)}</span></div>`);
            });
        }
        $('#bill-subtotal').text("Rs " + (order.totalAmount||0).toFixed(2));
        $('#bill-total').text("Rs " + (order.totalAmountAfterTax||0).toFixed(2));
        if (order.tipAmount > 0) {
            $('#bill-tip-row').show();
            $('#bill-tip-val').text("+ Rs " + order.tipAmount.toFixed(2));
        } else {
            $('#bill-tip-row').hide();
        }
    }

    // --- NEW: Load Staff for Dropdown ---
    function loadStaffDropdown(restaurantId) {
        const token = localStorage.getItem('token');
        $.ajax({
            url: "/api/restaurants/" + restaurantId + "/staff",
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(staffList) {
                const selector = $('#staff-selector').empty();
                selector.append('<option value="">Select Staff...</option>');

                // ADD THE BACKSLASHES HERE: \${ }
                staffList.forEach(s => {
                    selector.append(`<option value="\${s.staff.id}">\${s.staff.firstName} \${s.staff.lastName}</option>`);
                });
            },
            error: function() {
                $('#staff-selector').empty().append('<option value="">Failed to load staff</option>');
            }
        });
    }

    // --- NEW: Assign & Dispatch API Call ---
    function assignAndDispatch() {
        const staffId = $('#staff-selector').val();
        if (!staffId) {
            showCustomAlert("Wait!", "Please select a delivery partner first.");
            return;
        }

        const btn = $('#btn-assign');
        btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm"></span>');

        $.ajax({
            url: `/api/orders/\${currentOrder.id}/assign-delivery?staffId=\${staffId}`,
            type: 'POST',
            headers: { 'Authorization': 'Bearer ' + localStorage.getItem('token') },
            success: function() { location.reload(); },
            error: function() { showCustomAlert("Error", "Could not assign staff."); btn.prop('disabled', false).text('Dispatch'); }
        });
    }

    // --- NEW: Fetch Tracking Details for display ---
    function fetchTrackingDetails(orderId) {
        $.ajax({
            url: '/api/orders/' + orderId + '/tracking',
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + localStorage.getItem('token') },
            success: function(tracking) {
                if (tracking && tracking.staff) {
                    // 1. Always show staff name
                    $('#assigned-staff-name').text(tracking.staff.firstName + ' ' + tracking.staff.lastName);

                    // 2. Always show the OTP (no matter the status)
                    $('#display-otp').text(currentOrder.otp ? currentOrder.otp : '----');

                    // 3. Update only the status message/icon
                    if (tracking.delivered || currentOrder.status === "DELIVERED" || currentOrder.status === "RECEIVED") {
                        $('#delivery-status-msg').html('<i class="fa-solid fa-circle-check text-success me-2"></i>Order Delivered');
                        // Optional: Change OTP box color to light green to show it was successfully used
                        $('#display-otp').closest('.bg-light').css('background-color', '#f0fdf4');
                    } else {
                        $('#delivery-status-msg').html('<i class="fa-solid fa-person-biking text-primary me-2"></i>Delivery in Progress');
                        $('#display-otp').closest('.bg-light').css('background-color', '#f8fafc');
                    }
                }
            },
            error: function() {
                $('#assigned-staff-name').text("Staff details unavailable");
            }
        });
    }

    function fetchCustomerAddress(orderId, token) {
        $.ajax({
            // Use the orderId specifically to get the snapshot of the address used
            url: '/api/user/address/' + orderId + '/delivery-address',
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(addr) {
                if(addr) {
                    $('#cust-name').text(addr.receiverName || "Customer");
                    $('#cust-phone').text(addr.mobile || "N/A");
                    $('#cust-address').html('<i class="fa-solid fa-location-dot me-2 text-danger"></i>' +
                        (addr.address || "") + ", " + (addr.city || ""));
                }
            }
        });
    }

    // Call it like this in loadOrderForOwner:
    fetchCustomerAddress(order.id, token);

    function showCustomAlert(title, message) {
        $('#alert-modal-title').text(title);
        $('#alert-modal-msg').text(message);
        new bootstrap.Modal(document.getElementById('ownerAlertModal')).show();
    }

    // Only used for PLACED -> PROCESSING now
    function handleStatusUpdate(nextStatus) {
        const token = localStorage.getItem('token');
        $.ajax({
            url: `/api/orders/\${currentOrder.id}/status?status=\${nextStatus}`,
            type: 'PUT',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function() { location.reload(); },
            error: function() { showCustomAlert("Update Failed", "Status update failed."); }
        });
    }

</script>