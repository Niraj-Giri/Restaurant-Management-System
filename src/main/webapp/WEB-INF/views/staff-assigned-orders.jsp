<style>
    /* Custom spacing and font sizes */
    .x-small { font-size: 0.65rem; letter-spacing: 0.5px; }
    .letter-spacing-2 { letter-spacing: 0.5rem; }
    .fw-black { font-weight: 900; }

    /* Card Design */
    .delivery-card {
        transition: transform 0.2s ease-in-out;
        background: #fdfdfd;
    }

    .delivery-card:active {
        transform: scale(0.98);
    }

    .btn-indigo {
        background-color: #6366f1;
        color: white;
    }
    .btn-indigo:hover {
        background-color: #4f46e5;
        color: white;
    }

    .btn-sm {
        font-size: 0.8rem !important;
        letter-spacing: 0.3px;
    }

    @media (max-width: 380px) {
        .gap-3 { gap: 0.5rem !important; }
    }

    .transition-all { transition: all 0.3s ease; }
</style>

<div class="container py-5">
    <div class="mb-4">
        <h2 class="fw-black text-dark"><i class="fa-solid fa-person-biking text-primary me-2"></i>Assigned Orders</h2>
        <p class="text-muted">Manage your active deliveries and verify completion with customer OTP.</p>
    </div>

    <div id="assigned-orders-container" class="row g-4"></div>

    <div id="staff-spinner" class="text-center py-5">
        <div class="spinner-border text-primary" role="status"></div>
    </div>
    <div id="empty-state" class="text-center py-5" style="display:none;">
        <i class="fa-solid fa-box-open display-1 text-muted mb-3 opacity-25"></i>
        <h4 class="fw-bold">No active tasks</h4>
        <p class="text-muted">Check back later for new assignments.</p>
    </div>
</div>

<div class="modal fade" id="otpModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow rounded-4">
            <div class="modal-body p-4 text-center">
                <div class="mb-3">
                    <i class="fa-solid fa-shield-check text-primary display-4"></i>
                </div>
                <h5 class="fw-bold">Verify Delivery</h5>
                <p class="small text-muted">Ask the customer for their 4-digit OTP to complete this order.</p>

                <input type="hidden" id="pending-order-id">
                <div class="mb-3">
                    <input type="text" id="otp-input" class="form-control form-control-lg text-center fw-bold letter-spacing-2" maxlength="4" placeholder="0 0 0 0">
                </div>

                <div id="otp-error" class="text-danger small mb-3 d-none">Invalid OTP. Please try again.</div>

                <div class="d-grid gap-2">
                    <button class="btn btn-primary rounded-pill fw-bold py-2" onclick="submitOtp()">Verify & Complete</button>
                    <button class="btn btn-light border rounded-pill fw-bold py-2" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        loadAssignedOrders();
    });

    async function loadAssignedOrders() {
        const token = localStorage.getItem('token');

        try {
            const restaurant = await $.ajax({
                url: "/api/staff/my-restaurant",
                type: 'GET',
                headers: { 'Authorization': 'Bearer ' + token }
            });

            const trackingList = await $.ajax({
                url: "/api/staff/my-assigned-orders",
                type: 'GET',
                headers: { 'Authorization': 'Bearer ' + token }
            });

            $('#staff-spinner').hide();
            if (!trackingList || trackingList.length === 0) {
                $('#empty-state').show();
                return;
            }

            const container = $('#assigned-orders-container').empty();

            const ordersWithAddresses = await Promise.all(trackingList.map(async (t) => {
                const orderId = (t.order && t.order.id) ? t.order.id : null;
                if (!orderId) return { ...t, deliveryAddress: null };

                try {
                    const address = await $.ajax({
                        url: "/api/user/address/" + orderId + "/delivery-address",
                        type: 'GET',
                        headers: { 'Authorization': 'Bearer ' + token }
                    });
                    return { ...t, deliveryAddress: address };
                } catch (e) {
                    return { ...t, deliveryAddress: null };
                }
            }));

            ordersWithAddresses.forEach(t => {
                const order = t.order;
                const isStarted = t.tripStarted;
                const addr = t.deliveryAddress;

                // --- DATE & TIME FORMATTING ---
                const orderDate = new Date(order.createdAt);
                const dateStr = orderDate.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
                const timeStr = orderDate.toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit', hour12: true });
                const friendlyDateTime = `\${dateStr} | \${timeStr}`;

                let dropAddrStr = "Address details unavailable";
                if (addr) {
                    const mainAddress = addr.address ? addr.address.replace(/\r\n|\r|\n/g, ', ') : '';
                    const landmark = addr.landmark ? ` (Landmark: \${addr.landmark})` : '';
                    const cityZip = `\${addr.city || ''} - \${addr.zip || ''}`;
                    dropAddrStr = `\${mainAddress}\${landmark}, \${cityZip}`;
                }

                container.append(`
        <div class="col-md-6 col-lg-4">
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-3 delivery-card">
                <div class="card-header bg-primary text-white py-3 border-0 d-flex justify-content-between align-items-center">
                    <span class="fw-bold fs-5">Order #\${order.id}</span>
                    <span class="badge \${isStarted ? 'bg-white text-primary' : 'bg-warning text-dark'} rounded-pill text-uppercase" style="font-size:0.65rem">
                        \${isStarted ? 'In Route' : 'Assigned'}
                    </span>
                </div>

                <div class="card-body p-4">
                    <div class="mb-4">
                        <small class="text-muted d-block text-uppercase fw-bold x-small mb-1">Assigned At</small>
                        <div class="d-flex align-items-center">
                            <i class="fa-regular fa-clock text-primary me-2"></i>
                            <span class="fw-bold text-dark">\${friendlyDateTime}</span>
                        </div>
                    </div>

                    <div class="mb-3">
                        <small class="text-muted d-block text-uppercase fw-bold x-small">Pickup From</small>
                        <div class="d-flex align-items-start mt-1">
                            <i class="fa-solid fa-building text-secondary me-2 mt-1"></i>
                            <span class="text-dark fw-medium small">\${restaurant.name || 'N/A'}</span>
                        </div>
                    </div>

                    <div class="mb-4">
                        <small class="text-muted d-block text-uppercase fw-bold x-small">Drop Address</small>
                        <div class="d-flex align-items-start mt-1">
                            <i class="fa-solid fa-location-dot text-danger me-2 mt-1"></i>
                            <span class="text-dark fw-medium small">\${dropAddrStr}</span>
                        </div>
                    </div>

                    <div class="row mb-4">
                        <div class="col-7">
                            <small class="text-muted d-block text-uppercase fw-bold x-small">Customer</small>
                            <span class="fw-bold text-dark d-block">\${order.customer.firstName} \${order.customer.lastName}</span>
                        </div>
                        <div class="col-5">
                            <small class="text-muted d-block text-uppercase fw-bold x-small">Contact</small>

                                <i class="fa-solid fa-phone me-1 small"></i>\${order.customer.mobileNumber}

                        </div>
                    </div>

                    <div class="d-flex gap-3">
                        <button class="btn btn-sm \${isStarted ? 'btn-success' : 'btn-indigo'} flex-fill py-2 rounded-3 fw-bold shadow-sm transition-all"
                                onclick="\${isStarted ? 'openOtpModal('+order.id+')' : 'startTrip('+order.id+')'}">
                            \${isStarted ? 'Deliver' : 'Start Trip'}
                        </button>
                        <button class="btn btn-sm btn-light border flex-fill py-2 rounded-3 fw-bold shadow-sm text-muted"
                                onclick="viewOrderDetails(\${order.id})">
                            View
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `);
            });

        } catch (error) {
            console.error("Error loading delivery data", error);
            $('#staff-spinner').hide();
            $('#empty-state').show().find('h4').text("Failed to load tasks");
        }
    }

    function viewOrderDetails(orderId) {
        window.location.href = '/staff/order-details?id=' + orderId;
    }

    function startTrip(orderId) {
        $.ajax({
            url: "/api/staff/orders/" + orderId + "/start-trip",
            type: 'PUT',
            headers: { 'Authorization': 'Bearer ' + localStorage.getItem('token') },
            success: function() {
                location.reload();
            },
            error: function(xhr) {
                alert("Error starting trip: " + xhr.responseText);
            }
        });
    }

    function openOtpModal(orderId) {
        $('#pending-order-id').val(orderId);
        $('#otp-input').val('');
        $('#otp-error').addClass('d-none');
        $('#otpModal').modal('show');
    }

    function submitOtp() {
        const orderId = $('#pending-order-id').val();
        const otpValue = $('#otp-input').val();
        const token = localStorage.getItem('token');

        if(otpValue.length < 4) {
            alert("Please enter a valid 4-digit OTP");
            return;
        }

        $.ajax({
            url: "/api/staff/orders/" + orderId + "/complete-delivery",
            type: 'POST',
            contentType: 'application/json',
            headers: { 'Authorization': 'Bearer ' + token },
            data: JSON.stringify({ otp: otpValue }),
            success: function() {
                $('#otpModal').modal('hide');
                location.reload();
            },
            error: function(xhr) {
                $('#otp-error').removeClass('d-none').text(xhr.responseText || "Invalid OTP");
            }
        });
    }
</script>