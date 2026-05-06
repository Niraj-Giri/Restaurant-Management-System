<style>
    .order-details-wrapper { max-width: 800px; margin: 0 auto; }
    .receipt-card {
        background: #ffffff; border-radius: 28px;
        box-shadow: 0 15px 35px rgba(0,0,0,0.05);
        border: 1px solid rgba(0,0,0,0.05); overflow: hidden;
    }
    .status-badge {
        padding: 6px 16px; border-radius: 50px; font-weight: 800; font-size: 0.75rem;
        text-transform: uppercase; letter-spacing: 1px;
    }
    .status-placed { background: #fff7ed; color: #c2410c; }
    .status-processing { background: #f0f9ff; color: #0369a1; }
    .status-in_route { background: #f5f3ff; color: #6d28d9; }
    .status-assigned { background: #fef3c7; color: #92400e; }
    .status-delivered { background: #f0fdf4; color: #15803d; }

    .staff-action-box {
        background: #f8fafc; border-left: 4px solid #6366f1;
        padding: 15px; border-radius: 8px; margin-bottom: 20px;
    }
    .item-list-row { padding: 1.25rem 0; border-bottom: 1px solid #f1f5f9; }
    .contact-link { text-decoration: none; font-weight: 700; color: #6366f1; }
</style>

<div class="container py-5 order-details-wrapper">
    <div class="d-flex justify-content-between align-items-center mb-4 px-2">
        <div>

            <h2 class="fw-black text-dark mt-2">Delivery #<span id="order-id-num">...</span></h2>
        </div>
        <div id="order-status" class="status-badge">...</div>
    </div>

    <div class="staff-action-box">
        <i class="fa-solid fa-truck-fast me-2 text-primary"></i>
        <span class="fw-bold text-dark"> Order Details</span>
    </div>

    <div class="receipt-card mb-5">
        <div class="p-4 p-md-5 border-bottom">
            <h6 class="text-uppercase opacity-50 small fw-bold mb-3">Customer Details</h6>
            <div class="d-flex align-items-start mb-4">
                <i class="fa-solid fa-location-dot mt-1 text-danger me-3 fs-5"></i>
                <div class="flex-grow-1">
                    <h5 class="fw-bold mb-1" id="delivery-name">---</h5>
                    <p class="mb-2">
                        <a href="#" id="call-receiver" class="contact-link">
                            <i class="fa-solid fa-phone me-1"></i> <span id="delivery-phone">---</span>
                        </a>
                    </p>
                    <p class="text-dark fw-medium mb-0" id="delivery-address">---</p>
                    <div id="landmark-container" class="mt-2" style="display:none;">
                        <span class="badge bg-primary bg-opacity-10 text-primary fw-bold">
                            <i class="fa-solid fa-map-pin me-1"></i> Landmark: <span id="landmark-text"></span>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <div class="p-4 p-md-5">
            <h6 class="text-uppercase opacity-50 small fw-bold mb-3">Package Contents (<span id="item-count">0</span> Items)</h6>
            <div id="order-items-list"></div>
        </div>

        <div class="p-4 p-md-5 bg-light border-top">
            <div class="d-flex justify-content-between align-items-center">
                <span class="fs-4 fw-black text-dark">Collect Total:</span>
                <span class="fs-2 fw-black text-primary" id="bill-total">Rs 0.00</span>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        const urlParams = new URLSearchParams(window.location.search);
        const orderId = urlParams.get('id');
        if (orderId) {
            loadOrderDetails(orderId);
        }
    });

    function loadOrderDetails(id) {
        const token = localStorage.getItem('token');
        $.ajax({
            url: "/api/orders/" + id,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(order) {
                renderStaffDetails(order);
            },
            error: function(xhr) {
                window.location.href = '/staff/assigned-orders';
            }
        });
    }

    function renderStaffDetails(order) {
        $('#order-id-num').text(order.id);
        $('#order-status').text(order.status).removeClass().addClass('status-badge status-' + order.status.toLowerCase());

        // Mapping Customer/Address from deliveryAddress object
        const addr = order.deliveryAddress;
        if (addr) {
            $('#delivery-name').text(addr.receiverName || "Customer");
            $('#delivery-phone').text(addr.mobile || "N/A");
            $('#call-receiver').attr('href', 'tel:' + addr.mobile);

            const cleanAddr = addr.address ? addr.address.replace(/\r\n|\r|\n/g, ', ') : 'N/A';
            $('#delivery-address').text(`\${cleanAddr}, \${addr.city || ''} (\${addr.zip || ''})`);

            if (addr.landmark) {
                $('#landmark-text').text(addr.landmark);
                $('#landmark-container').show();
            }
        }

        // Render Items List
        const itemsList = $('#order-items-list').empty();
        $('#item-count').text(order.items.length);

        order.items.forEach(item => {
            itemsList.append(`
                <div class="item-list-row d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="fw-bold mb-0 text-dark">\${item.product.name}</h6>
                        <span class="text-muted small">Quantity: \${item.quantity}</span>
                    </div>

                </div>`);
        });

        $('#bill-total').text("Rs " + Math.round(order.totalAmountAfterTax || 0));
    }
</script>