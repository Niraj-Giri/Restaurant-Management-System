<div class="row mb-4 mt-4">
    <div class="col-12 d-flex justify-content-between align-items-center bg-white p-4 rounded-4 shadow-sm border border-light">
        <div>
            <h2 class="fw-black text-dark mb-1"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i>Order History</h2>
            <p class="text-muted mb-0 fw-medium">View all past transactions.</p>
        </div>
    </div>
</div>

<div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-5">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="bg-light text-uppercase small fw-bold text-secondary">
            <tr>
                <th class="py-3 px-4">Order ID</th>
                <th class="py-3">Date & Time</th>
                <th class="py-3">Customer Name</th> <th class="py-3">Phone Number</th>  <th class="py-3">Amount</th>
                <th class="py-3">Status</th>
                <th class="py-3 text-end px-4">Action</th>
            </tr>
            </thead>
            <tbody id="history-orders-table">
            </tbody>
        </table>
    </div>

    <div id="order-spinner" class="text-center py-5">
        <div class="spinner-border text-primary" role="status"></div>
        <p class="mt-2 text-muted fw-bold">Loading history...</p>
    </div>
    <div id="empty-state" class="text-center py-5" style="display: none;">
        <div class="text-muted mb-3"><i class="fa-solid fa-folder-open display-4 opacity-25"></i></div>
        <h5 class="fw-bold text-dark">No orders found</h5>
        <p class="text-muted">No past transactions are available yet.</p>
    </div>
</div>

<style>
    /* Status Badges Matching the Kitchen Display */
    .status-badge {
        font-size: 0.7rem; font-weight: 800; letter-spacing: 0.5px;
        text-transform: uppercase; padding: 6px 14px; border-radius: 50px;
        display: inline-flex; align-items: center; gap: 6px;
    }
    .bg-placed { background-color: #e0f2fe; color: #0284c7; }
    .bg-processing { background-color: #fef3c7; color: #d97706; }
    .bg-in_route { background-color: #f3e8ff; color: #9333ea; }
    .bg-delivered { background-color: #dcfce7; color: #16a34a; }
    .bg-canceled { background-color: #fee2e2; color: #dc2626; }
    .bg-assigned { background-color: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
</style>
<script>
    $(document).ready(function() {
        initOrderHistory();
    });

    /**
     * Pulls the active branch ID and verifies it before fetching data.
     */
    function initOrderHistory() {
        const token = localStorage.getItem('token');
        const activeResId = localStorage.getItem('activeRestaurantId');

        // Safety check: if no restaurant is selected, redirect to selection page
        if (!activeResId || activeResId === "null" || activeResId === "undefined") {
            window.location.href = '/owner/select-restaurant';
            return;
        }

        $.ajax({
            url: '/api/restaurants/my-restaurant',
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            // Pass the required restaurantId parameter
            data: { restaurantId: activeResId },
            success: function(res) {
                // Now that we have the verified restaurant object, fetch history
                fetchHistoryData(res.id, token);
            },
            error: function(xhr) {
                $('#order-spinner').hide();
                if (xhr.status === 401 || xhr.status === 403) {
                    window.location.href = '/owner/login';
                } else {
                    $('#empty-state').show().html('<h5 class="text-danger fw-bold">Unauthorized branch access.</h5>');
                }
            }
        });
    }

    /**
     * Fetches the actual order history for the specific restaurant ID.
     */
    function fetchHistoryData(resId, token) {
        $.ajax({
            url: "/api/orders/history/" + resId,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(orders) {
                $('#order-spinner').hide();

                if (!orders || orders.length === 0) {
                    $('#empty-state').show();
                    return;
                }

                // Sort newest first and render
                const sortedOrders = orders.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
                renderTable(sortedOrders);
            },
            error: function() {
                $('#order-spinner').hide();
                $('#empty-state').show().html('<h5 class="text-danger fw-bold">Failed to load history.</h5>');
            }
        });
    }

    /**
     * UI Helper for Status Badges
     */
    function getStatusConfig(status) {
        const configs = {
            'PLACED': { class: 'bg-placed', icon: 'fa-bell', text: 'New' },
            'PROCESSING': { class: 'bg-processing', icon: 'fa-fire-burner', text: 'Cooking' },
            'ASSIGNED': { class: 'bg-assigned', icon: 'fa-user-check', text: 'Assigned' },
            'IN_ROUTE': { class: 'bg-in_route', icon: 'fa-motorcycle', text: 'Dispatched' },
            'DELIVERED': { class: 'bg-delivered', icon: 'fa-check-circle', text: 'Delivered' },
            'RECEIVED': { class: 'bg-delivered', icon: 'fa-check-double', text: 'Received' },
            'CANCELED': { class: 'bg-canceled', icon: 'fa-circle-xmark', text: 'Cancelled' }
        };
        return configs[status] || { class: 'bg-secondary text-white', icon: 'fa-info-circle', text: status };
    }

    /**
     * Dynamically renders the table rows
     */
    function renderTable(ordersToDisplay) {
        const tbody = $('#history-orders-table').empty();

        if (ordersToDisplay.length === 0) {
            $('#empty-state').show();
            return;
        }

        $('#empty-state').hide();

        ordersToDisplay.forEach(order => {
            const dateObj = new Date(order.createdAt);
            const dateStr = dateObj.toLocaleDateString([], {month: 'short', day: 'numeric', year: 'numeric'});
            const timeStr = dateObj.toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});

            const total = order.totalAmountAfterTax || 0;
            const statusConfig = getStatusConfig(order.status);

            const customer = order.customer || {};
            const firstName = customer.firstName || "Guest";
            const lastName = customer.lastName || "";
            const customerName = (firstName + " " + lastName).trim();
            const customerPhone = customer.mobileNumber || "N/A";

            tbody.append(`
                <tr>
                    <td class="px-4 fw-black text-dark">#\${order.id}</td>
                    <td>
                        <div class="fw-bold text-dark">\${dateStr}</div>
                        <div class="small text-muted">\${timeStr}</div>
                    </td>
                    <td class="fw-medium text-dark">\${customerName}</td>
                    <td class="fw-medium text-muted">
                        <i class="fa-solid fa-phone me-1 small text-primary"></i>\${customerPhone}
                    </td>
                    <td class="fw-bold text-primary">Rs \${total.toFixed(2)}</td>
                    <td>
                        <span class="status-badge \${statusConfig.class}">
                            <i class="fa-solid \${statusConfig.icon}"></i> \${statusConfig.text}
                        </span>
                    </td>
                    <td class="text-end px-4">
                        <button class="btn btn-light btn-sm fw-bold rounded-pill shadow-sm border" onclick="viewOrderDetails(\${order.id})">
                            View
                        </button>
                    </td>
                </tr>
            `);
        });
    }

    function viewOrderDetails(orderId) {
        window.location.href = '/owner/order-details?id=' + orderId;
    }
</script>