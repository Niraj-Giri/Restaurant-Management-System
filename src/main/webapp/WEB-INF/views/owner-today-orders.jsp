<style>
    /* Minimalist Header */
    .page-header { border-bottom: 1px solid #eaeaea; padding-bottom: 1.5rem; }

    /* Square Order Card */
    .square-order-card {
        background: #ffffff;
        border: 1px solid #e5e7eb;
        border-radius: 16px;
        padding: 1.5rem;
        transition: all 0.2s ease;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        min-height: 220px;
        height: 100%;
    }
    .square-order-card:hover {
        border-color: #d1d5db;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.04);
        transform: translateY(-4px);
    }

    .order-id-link { font-size: 1.25rem; font-weight: 800; color: #111827; text-decoration: none; }
    .order-id-link:hover { color: #2563eb; }
    .item-count-text { font-size: 0.95rem; font-weight: 600; color: #6b7280; }
    .price-text { font-size: 1.75rem; font-weight: 800; color: #0c4fdf; letter-spacing: -0.5px; }

    /* Badges */
    .badge-minimal { padding: 0.4em 0.8em; border-radius: 6px; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; }
    .status-placed     { background: #f3f4f6; color: #4b5563; }
    .status-processing { background: #fef3c7; color: #b45309; }
    .status-delivered  { background: #dcfce7; color: #15803d; }
    .status-new-badge {
        background: #fee2e2 !important; color: #dc2626 !important;
        border: 1px solid #fecaca; animation: pulse-red 2s infinite;
    }

    @keyframes pulse-red {
        0% { box-shadow: 0 0 0 0 rgba(220, 38, 38, 0.4); }
        70% { box-shadow: 0 0 0 10px rgba(220, 38, 38, 0); }
        100% { box-shadow: 0 0 0 0 rgba(220, 38, 38, 0); }
    }

    .animate-new-order { animation: entrance 0.5s ease-out forwards; }
    @keyframes entrance { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }

    .btn-minimal {
        background: #f9fafb; border: 1px solid #e5e7eb; color: #374151;
        font-weight: 600; border-radius: 8px; padding: 0.6rem 1rem; width: 100%;
    }
    .btn-minimal:hover { background: #111827; color: #ffffff; }
</style>

<div class="container py-4">
    <div class="page-header d-flex justify-content-between align-items-end mb-4">
        <div>
            <h3 class="fw-bold text-dark mb-1">Today's Orders</h3>
            <p class="text-muted small mb-0" id="today-date-display"></p>
        </div>
        <div>
            <span class="badge bg-light text-dark border px-3 py-2 rounded-pill shadow-sm" id="order-count-badge">
                0 Orders
            </span>
        </div>
    </div>

    <div id="today-orders-container" class="row g-4 mb-5"></div>

    <div id="order-spinner" class="text-center py-5">
        <div class="spinner-border text-secondary" style="width: 2rem; height: 2rem;" role="status"></div>
    </div>
</div>

<script>
    $(document).ready(function() {
        $('#today-date-display').text(new Date().toLocaleDateString('en-US', {
            weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
        }));
        initTodayOrders();
    });

    function initTodayOrders() {
        const token = localStorage.getItem('token');
        const activeResId = localStorage.getItem('activeRestaurantId');

        if (!activeResId || activeResId === "null") {
            window.location.href = '/owner/select-restaurant';
            return;
        }

        // First, fetch restaurant details to confirm authorization and setup socket
        $.ajax({
            url: '/api/restaurants/my-restaurant',
            type: 'GET',
            data: { restaurantId: activeResId }, // Fixed: passing restaurantId
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(res) {
                fetchOrders(res.id, token);
                // The connect() function is defined in your sidebar/layout
                if (typeof connect === "function") connect(res.id);
            },
            error: function(xhr) {
                console.error("Auth error", xhr.responseText);
                $('#order-spinner').hide();
                $('#today-orders-container').html('<div class="col-12 text-center py-5 text-danger">Session expired or unauthorized.</div>');
            }
        });
    }

    function fetchOrders(resId, token) {
        $.ajax({
            url: "/api/orders/today/" + resId,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(orders) {
                $('#order-spinner').hide();
                const container = $('#today-orders-container').empty();
                $('#order-count-badge').text(orders.length + " Orders");

                if (orders.length === 0) {
                    container.html(`<div class="col-12 text-center py-5"><p class="text-muted">No orders placed today.</p></div>`);
                    return;
                }

                orders.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

                orders.forEach(order => {
                    renderOrderCard(order, false);
                });
            }
        });
    }

    function renderOrderCard(order, isSocket) {
        const container = $('#today-orders-container');
        const itemCount = order.items ? order.items.length : (order.numberOfItems || 0);
        const total = order.totalAmountAfterTax || order.totalAmount || 0;
        const customerName = order.customer ? order.customer.firstName : (order.customerName || "Guest");

        const isNew = order.status === 'PLACED';
        const statusClass = isNew ? 'status-new-badge' : getStatusClass(order.status);
        const statusText = isNew ? 'NEW' : order.status;

        const cardHtml = `
            <div class="col-12 col-sm-6 col-lg-4 col-xl-3 \${isSocket ? 'animate-new-order' : ''}" id="order-card-\${order.id}">
                <div class="square-order-card \${isNew ? 'border-danger' : ''}">
                    <div>
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <a href="/owner/order-details?id=\${order.id}" class="order-id-link">#\${order.id}</a>
                            <span class="badge-minimal \${statusClass}">\${statusText}</span>
                        </div>
                        <span class="customer-name-text">
                            <i class="fa-solid fa-circle-user me-2 text-primary opacity-75"></i>\${customerName}
                        </span>
                        <div class="item-count-text">
                            <i class="fa-solid fa-box me-2 opacity-50"></i>\${itemCount} Items
                        </div>
                    </div>
                    <div class="mt-4">
                        <div class="price-text mb-3">Rs \${parseFloat(total).toFixed(2)}</div>
                        <button class="btn-minimal" onclick="window.location.href='/owner/order-details?id=\${order.id}'">Manage</button>
                    </div>
                </div>
            </div>`;

        if (isSocket) {
            container.find('.text-center.py-5').remove(); // Remove "No orders" text if present
            container.prepend(cardHtml);
            updateBadgeCount(1);
        } else {
            container.append(cardHtml);
        }
    }

    // Global function called by your WebSocket listener in the sidebar
    function addRowInOrderTable(orderId, customerName, numberOfItems, totalAmount, status) {
        if ($(`#order-card-\${orderId}`).length > 0) return;

        const dummyOrder = {
            id: orderId,
            customerName: customerName,
            numberOfItems: numberOfItems,
            totalAmount: totalAmount,
            status: status
        };
        renderOrderCard(dummyOrder, true);
    }

    function updateBadgeCount(increment) {
        const badge = $('#order-count-badge');
        const current = parseInt(badge.text()) || 0;
        badge.text((current + increment) + " Orders");
    }

    function getStatusClass(status) {
        const statusMap = {
            'PLACED': 'status-placed',
            'PROCESSING': 'status-processing',
            'IN_ROUTE': 'status-in_route',
            'DELIVERED': 'status-delivered',
            'RECEIVED': 'status-delivered',
            'CANCELED': 'status-canceled'
        };
        return statusMap[status] || 'status-placed';
    }
</script>