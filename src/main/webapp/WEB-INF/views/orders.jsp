<style>
    /* Premium UI Custom Styles */
    body {
        background-color: #f8f9fa;
    }

    /* Strict Card Sizing */
    .history-order-card {
        height: 480px; /* Force every card to be exactly this tall */
        display: flex;
        flex-direction: column;
        border-radius: 16px;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        background: #ffffff;
        border: 1px solid rgba(0,0,0,0.05);
        overflow: hidden; /* Keep rounded corners clean */
    }
    .history-order-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 1rem 3rem rgba(0,0,0,.1)!important;
    }

    /* Scrollable Middle Section */
    .card-scroll-area {
        flex: 1 1 auto; /* Allows this section to grow/shrink */
        overflow-y: auto; /* Adds scrollbar only here */
        padding: 1rem 1.5rem;
        background: rgba(248, 249, 250, 0.5); /* bg-light bg-opacity-50 */
    }

    /* Fixed Top and Bottom Sections */
    .card-fixed-header {
        flex: 0 0 auto;
        padding: 1.5rem;
        border-bottom: 1px solid rgba(0,0,0,0.05);
    }
    .card-fixed-footer {
        flex: 0 0 auto;
        padding: 1.5rem;
        border-top: 1px solid rgba(0,0,0,0.05);
        background: #ffffff;
    }

    .item-image {
        width: 60px;
        height: 60px;
        object-fit: cover;
        border-radius: 12px;
    }
    .custom-scrollbar::-webkit-scrollbar {
        width: 5px;
    }
    .custom-scrollbar::-webkit-scrollbar-track {
        background: transparent;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb {
        background: #dee2e6;
        border-radius: 10px;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb:hover {
        background: #adb5bd;
    }
    .page-header-gradient {
        background: linear-gradient(135deg, #fdfbfb 0%, #ebedee 100%);
        border-bottom: 1px solid #e9ecef;
    }
</style>

<div class="page-header-gradient py-5 mb-5 shadow-sm">
    <div class="container-fluid px-4 px-lg-5 text-center">
        <h1 class="fw-bold text-dark display-5 mb-2"><i class="fa-solid fa-receipt me-3 text-primary"></i>My Order History</h1>
        <p class="text-muted lead mb-0">Track your past meals and recent cravings.</p>
    </div>
</div>

<div class="container-fluid px-4 px-lg-5 mb-5">
    <div class="row justify-content-center" id="loading-spinner">
        <div class="col-12 text-center py-5">
            <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;"></div>
            <p class="mt-3 text-muted fs-5">Fetching your delicious history...</p>
        </div>
    </div>
    <div class="container mb-4">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="d-flex flex-column flex-md-row align-items-center justify-content-center gap-3">

                    <div class="text-secondary fw-bold small text-uppercase mb-2 mb-md-0">
                        <i class="fa-solid fa-filter me-2"></i>Find orders by date:
                    </div>

                    <div class="input-group shadow-sm rounded-pill overflow-hidden border" style="max-width: 300px;">
                    <span class="input-group-text bg-white border-0 ps-3">
                        <i class="fa-solid fa-calendar-day text-primary"></i>
                    </span>
                        <input type="date" id="order-date-filter"
                               class="form-control border-0 py-2 fw-bold text-dark"
                               style="cursor: pointer; font-size: 0.9rem;"
                               onchange="filterOrdersByDate()">
                        <button class="btn btn-white border-0 px-3 text-muted" onclick="clearDateFilter()" title="Clear Filter">
                            <i class="fa-solid fa-circle-xmark"></i>
                        </button>
                    </div>
                </div>

                <p class="text-center small text-muted mt-3 fw-medium" id="filter-status-msg" style="min-height: 20px;"></p>
            </div>
        </div>
    </div>
    <div class="row g-4" id="orders-container">
    </div>
</div>
<script>
    // 1. Modified to accept an optional date parameter
    function filterOrdersByDate() {
        const selectedDate = $('#order-date-filter').val();
        console.log("Filtering by date:", selectedDate);
        fetchMyOrders(selectedDate);
    }

    $(document).ready(function() {
        if (sessionStorage.getItem('orderPlaced') === 'true') {
            $('#order-success-capsule').fadeIn(400).delay(3500).fadeOut(400);
            sessionStorage.removeItem('orderPlaced');
        }
        fetchMyOrders(); // Initial load
    });

    // 2. Updated to send the date to the backend
    function fetchMyOrders(date = "") {
        const token = localStorage.getItem('token');
        const container = $('#orders-container');
        const spinner = $('#loading-spinner');

        if (!token) {
            window.location.href = '/login';
            return;
        }

        // Show spinner and clear container during new fetch
        spinner.show();
        container.empty();

        // Construct URL: adds ?date=YYYY-MM-DD if date is provided
        let url = '/api/orders/my-orders';
        if (date) {
            url += '?date=' + date;
        }

        $.ajax({
            url: url,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(orders) {
                spinner.hide();
                container.empty();

                if (orders.length === 0) {
                    const emptyMsg = date
                        ? "No orders found for this specific date."
                        : "You haven't placed any orders yet!";

                    container.append(`
                        <div class="col-12 text-center py-5">
                            <div class="bg-white rounded-4 shadow-sm border-0 p-5 mx-auto" style="max-width: 600px;">
                                <i class="fa-solid fa-calendar-xmark display-1 text-light mb-4"></i>
                                <h3 class="fw-bold text-dark">\${emptyMsg}</h3>
                                <p class="text-muted mb-4">Try selecting another date or explore our menu.</p>
                                <a href="/home" class="btn btn-primary px-5 rounded-pill shadow-sm fw-bold">Order Something</a>
                            </div>
                        </div>
                    `);
                    return;
                }

                // Sort newest first (if backend doesn't already sort)
                orders.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

                orders.forEach(order => {
                    const rawDate = order.createdAt || order.orderDate || new Date();
                    const orderDate = new Date(rawDate).toLocaleString('en-US', {
                        month: 'short', day: 'numeric', year: 'numeric', hour: 'numeric', minute: '2-digit'
                    });

                    // Status Logic
                    let badgeClass = "bg-secondary text-white";
                    let icon = "fa-circle-info";
                    if (order.status === "PLACED") { badgeClass = "bg-primary text-white"; icon = "fa-bell"; }
                    else if (order.status === "PROCESSING" || order.status === "PREPARING") { badgeClass = "bg-warning text-dark"; icon = "fa-fire-burner"; }
                    else if (order.status === "IN_ROUTE") { badgeClass = "bg-info text-dark"; icon = "fa-motorcycle"; }
                    else if (order.status === "DELIVERED" || order.status === "RECEIVED") { badgeClass = "bg-success text-white"; icon = "fa-check-circle"; }
                    else if (order.status === "CANCELED") { badgeClass = "bg-danger text-white"; icon = "fa-xmark-circle"; }

                    // Items loop
                    let itemsHtml = '';
                    if (order.items) {
                        order.items.forEach(item => {
                            const imgUrl = (item.product && item.product.imageUrl) ? item.product.imageUrl : "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=150";
                            itemsHtml += `
                                <div class="d-flex align-items-center mb-3 bg-white p-2 rounded-3 shadow-sm border border-light">
                                    <img src="\${imgUrl}" class="item-image shadow-sm">
                                    <div class="flex-grow-1 ms-3">
                                        <h6 class="mb-1 fw-bold text-dark text-truncate" style="max-width: 140px;">\${item.product ? item.product.name : 'Item'}</h6>
                                        <span class="badge bg-light text-dark border">Qty: \${item.quantity}</span>
                                    </div>
                                    <div class="text-end fw-bold text-dark pe-2">Rs \${((item.priceAtPurchase || 0) * item.quantity).toFixed(2)}</div>
                                </div>`;
                        });
                    }

                    const finalTotal = order.totalAmountAfterTax || order.totalAmount || 0;
                    const resName = (order.restaurant && order.restaurant.name) ? order.restaurant.name : "Restaurant";

                    container.append(`
                        <div class="col-12 col-md-6 col-xl-4 mb-3">
                            <div class="history-order-card shadow-sm">
                                <div class="card-fixed-header d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="text-muted small fw-bold text-uppercase mb-1">Order #\${order.id}</div>
                                        <h5 class="fw-black text-dark mb-0 text-truncate" style="max-width: 180px;">\${resName}</h5>
                                        <div class="small text-muted mt-1"><i class="fa-regular fa-clock me-1"></i>\${orderDate}</div>
                                    </div>
                                    <span class="badge \${badgeClass} px-3 py-2 rounded-pill shadow-sm">
                                        <i class="fa-solid \${icon} me-1"></i> \${order.status}
                                    </span>
                                </div>
                                <div class="card-scroll-area custom-scrollbar">\${itemsHtml}</div>
                                <div class="card-fixed-footer">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <span class="text-muted fw-bold text-uppercase small">Total Paid</span>
                                        <span class="fs-4 fw-black text-primary">Rs \${finalTotal.toFixed(2)}</span>
                                    </div>
                                    <button class="btn btn-outline-primary w-100 rounded-pill fw-bold"
                                            onclick="window.location.href='/orderDetails?id=\${order.id}'">View Details</button>
                                </div>
                            </div>
                        </div>`);
                });
            },
            error: function() {
                spinner.hide();
                alert("Failed to fetch order history.");
            }
        });
    }
</script>