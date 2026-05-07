<style>
    :root {
        --sidebar-width: 280px;
        --primary-blue: #0d6efd;
        --bg-light: #f8fafc;
        --text-muted: #64748b;
    }

    body {
        background-color: var(--bg-light);
        padding-left: var(--sidebar-width);
        /* Pushes content to the right */
        transition: padding 0.3s ease;
    }

    /* Sidebar Container */
    .sidebar-owner {
        width: var(--sidebar-width);
        height: 100vh;
        position: fixed;
        left: 0;
        top: 0;
        background: #ffffff;
        border-right: 2px solid #f1f5f9;
        display: flex;
        flex-direction: column;
        z-index: 1050;
    }

    .sidebar-header {
        padding: 2.5rem 1.5rem;
    }

    .owner-brand-custom {
        font-weight: 800;
        font-size: 1.4rem;
        color: var(--primary-blue) !important;
        text-decoration: none;
        display: flex;
        align-items: center;
    }

    /* Navigation Links */
    .sidebar-body {
        flex: 1;
        overflow-y: auto;
        padding: 0 1rem;
    }

    .nav-section-label {
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: var(--text-muted);
        font-weight: 800;
        padding: 1.5rem 1rem 0.5rem;
    }

    .nav-link-owner {
        font-weight: 600;
        color: #475569 !important;
        padding: 12px 16px !important;
        border-radius: 12px;
        margin-bottom: 4px;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
        text-decoration: none;
    }

    .nav-link-owner i {
        width: 28px;
        font-size: 1.1rem;
    }

    .nav-link-owner:hover {
        background: #f1f5f9;
        color: var(--primary-blue) !important;
    }

    .nav-link-owner.active {
        background: #eff6ff;
        color: var(--primary-blue) !important;
    }

    /* Sidebar Footer / Account Area */
    .sidebar-footer {
        padding: 1.5rem;
        border-top: 1px solid #f1f5f9;
    }

    .owner-indicator {
        width: 10px;
        height: 10px;
        background: #10b981;
        border-radius: 50%;
        display: inline-block;
        margin-right: 10px;
    }

    /* Mobile Toggle (Hidden on Desktop) */
    .mobile-nav-toggle {
        display: none;
        position: fixed;
        top: 15px;
        right: 15px;
        z-index: 1100;
        background: var(--primary-blue);
        color: white;
        border: none;
        border-radius: 8px;
        padding: 10px 15px;
    }

    @media (max-width: 992px) {
        body {
            padding-left: 0;
        }

        .sidebar-owner {
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }

        .sidebar-owner.active {
            transform: translateX(0);
        }

        .mobile-nav-toggle {
            display: block;
        }
    }
</style>

<button class="mobile-nav-toggle d-lg-none" onclick="toggleSidebar()">
    <i class="fa-solid fa-bars"></i>
</button>
<aside class="sidebar-owner shadow-sm" id="mainSidebar">
    <div class="sidebar-header">
        <a class="owner-brand-custom" href="/owner/select-restaurant">
            <i class="fa-solid fa-utensils me-2"></i>
            <span id="res-name-text">Partner Panel</span>
        </a>
    </div>

    <div class="sidebar-body">
        <div class="nav-section-label">Operations</div>
        <ul class="nav flex-column mb-3">
            <li class="nav-item">
                <a class="nav-link nav-link-owner" href="/owner/home">
                    <i class="fa-solid fa-gauge-high"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link nav-link-owner" href="/owner/today-orders">
                    <i class="fa-solid fa-clock"></i> Today's Orders
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link nav-link-owner" href="/owner/past-orders">
                    <i class="fa-solid fa-boxes-packing"></i> Order History
                </a>
            </li>
        </ul>

        <div class="nav-section-label">Management</div>
        <ul class="nav flex-column mb-3">
            <li class="nav-item">
                <a class="nav-link nav-link-owner" href="/owner/manage-restaurant">
                    <i class="fa-solid fa-store"></i> Manage restaurants
                </a>
            </li>
            <%-- <li class="nav-item">--%>
                <%-- <a class="nav-link nav-link-owner" href="/owner/add-restaurant">--%>
                    <%-- <i class="fa-solid fa-store"></i> Add resturant--%>
                        <%-- </a>--%>
                            <%-- </li>--%>
                                <li class="nav-item">
                                    <a class="nav-link nav-link-owner" href="/owner/manage-menu">
                                        <i class="fa-solid fa-list-check"></i> Manage Menu
                                    </a>
                                </li>
                                <%-- <li class="nav-item">--%>
                                    <%-- <a class="nav-link nav-link-owner" href="/owner/addmenu">--%>
                                        <%-- <i class="fa-solid fa-bowl-food"></i> Add Menu Item--%>
                                            <%-- </a>--%>
                                                <%-- </li>--%>
        </ul>

        <div class="nav-section-label">People & Access</div>
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link nav-link-owner" href="/owner/manage-staff">
                    <i class="fa-solid fa-users-gear"></i> Manage Staff
                </a>
            </li>
            <%-- <li class="nav-item">--%>
                <%-- <a class="nav-link nav-link-owner" href="/owner/add-staff">--%>
                    <%-- <i class="fa-solid fa-user-plus"></i> Register Staff--%>
                        <%-- </a>--%>
                            <%-- </li>--%>
                                <li class="nav-item">
                                    <a class="nav-link nav-link-owner" href="/owner/block-user">
                                        <i class="fa-solid fa-user-slash"></i> User block
                                    </a>
                                </li>
        </ul>
    </div>

    <div class="sidebar-footer">
        <div class="dropdown">
            <button class="btn btn-light w-100 border rounded-pill py-2 px-3 dropdown-toggle d-flex align-items-center"
                type="button" data-bs-toggle="dropdown">
                <span class="owner-indicator"></span>
                <span id="owner-email-display" class="small fw-bold text-truncate">Account</span>
            </button>
            <ul class="dropdown-menu shadow border-0 rounded-4 p-2 mb-2 w-100">
                <li>
                    <hr class="dropdown-divider">
                </li>
                <li>
                    <button class="dropdown-item py-2 text-danger fw-bold rounded-3" data-bs-toggle="modal"
                        data-bs-target="#logoutModal">
                        <i class="fa-solid fa-right-from-bracket me-2"></i> Logout
                    </button>
                </li>
            </ul>
        </div>
    </div>
</aside>

<div class="modal fade" id="logoutModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-sm modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-body p-4 text-center">
                <div class="mb-3 text-danger"><i class="fa-solid fa-circle-exclamation fs-1"></i></div>
                <h5 class="fw-bold">Logging Out?</h5>
                <p class="text-muted small">You will need to login again to manage your branches.</p>
                <div class="d-flex gap-2 mt-4">
                    <button type="button" class="btn btn-light w-100 rounded-pill fw-bold"
                        data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger w-100 rounded-pill fw-bold"
                        onclick="executeLogout()">Logout</button>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/sockjs.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/stomp.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/ring_sounds.js"></script>

<script>
    $(document).ready(function () {
        // 1. Global Security Check
        const role = localStorage.getItem('role');
        const token = localStorage.getItem('token');

        if (role !== 'ROLE_RESTAURANT_OWNER' || !token) {
            localStorage.clear();
            window.location.href = '/owner/login';
            return;
        }

        // 2. Initial Data Load
        fetchOwnerDetails();
        highlightActiveLink();

        // 3. Handle Add Restaurant Modal Submission
        $('#add-restaurant-modal-form').on('submit', function (e) {
            e.preventDefault();
            const btn = $('#modalSaveResBtn');
            const errorBox = $('#modal-res-error');
            const token = localStorage.getItem('token');

            errorBox.addClass('d-none');
            btn.prop('disabled', true).html('<i class="fa-solid fa-spinner fa-spin me-2"></i>Saving...');

            const payload = {
                restaurantName: $('#modalResName').val().trim(),
                restaurantDescription: $('#modalResDesc').val().trim()
            };

            $.ajax({
                url: '/api/restaurants/add',
                type: 'POST',
                headers: { 'Authorization': 'Bearer ' + token },
                contentType: 'application/json',
                data: JSON.stringify(payload),
                success: function (response) {
                    btn.removeClass('btn-primary').addClass('btn-success')
                        .html('<i class="fa-solid fa-check me-2"></i>Success!');
                    setTimeout(function () {
                        location.reload();
                    }, 1200);
                },
                error: function (xhr) {
                    errorBox.removeClass('d-none').text('Failed to save. Try again.');
                    btn.prop('disabled', false).text('Save Restaurant');
                }
            });
        });
    });
    function executeLogout() {
        // Clear all restaurant-specific and auth data
        localStorage.removeItem('token');
        localStorage.removeItem('role');
        localStorage.removeItem('userEmail');
        localStorage.removeItem('activeRestaurantId');
        localStorage.removeItem('activeRestaurantName');

        window.location.href = '${pageContext.request.contextPath}/owner/login';
    }
    function fetchOwnerDetails() {
        const token = localStorage.getItem('token');
        const activeResId = localStorage.getItem('activeRestaurantId');
        const path = window.location.pathname;

        // 1. If we ALREADY have a selected restaurant ID, just fetch its details
        if (activeResId && activeResId !== "null" && activeResId !== "undefined") {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/restaurants/my-restaurant',
                type: 'GET',
                headers: { 'Authorization': 'Bearer ' + token },
                data: { restaurantId: activeResId },
                success: function (res) {
                    $('#res-name-text').text(res.name);
                    $('#owner-email-display').text(localStorage.getItem('userEmail') || 'Owner');
                    if (res.id) connect(res.id);
                },
                error: function (xhr) {
                    if (xhr.status === 401 || xhr.status === 403) {
                        window.location.href = '${pageContext.request.contextPath}/owner/login';
                    }
                }
            });
        }
        // 2. If NO ID is selected, we must check if they even have a restaurant
        else {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/restaurants/my-all-restaurants',
                type: 'GET',
                headers: { 'Authorization': 'Bearer ' + token },
                success: function (restaurants) {
                    if (!restaurants || restaurants.length === 0) {
                        // NEW OWNER: No restaurants exist yet. Go to Add page.
                        if (path !== '${pageContext.request.contextPath}/owner/add-restaurant') {
                            window.location.href = '${pageContext.request.contextPath}/owner/add-restaurant';
                        }
                    } else {
                        // EXISTING OWNER: Has branches but hasn't picked one this session.
                        if (path !== '${pageContext.request.contextPath}/owner/select-restaurant') {
                            window.location.href = '${pageContext.request.contextPath}/owner/select-restaurant';
                        }
                    }
                }
            });
        }
    }

    function highlightActiveLink() {
        const path = window.location.pathname;
        $('.nav-link-owner').removeClass('active');
        $('.nav-link-owner').each(function () {
            if ($(this).attr('href') === path) {
                $(this).addClass('active');
            }
        });
    }

    function toggleSidebar() {
        $('#mainSidebar').toggleClass('active');
    }

    // --- SOCKET LOGIC START: Connection & Global Listener ---
    function connect(restaurantId) {
        var socket = new SockJS('/order-websocket');
        var stompClient = Stomp.over(socket);

        stompClient.connect({}, function (frame) {
            console.log('Connected to WebSocket: ' + frame);

            // Subscribing to the unique restaurant topic
            let topicName = "/topic/" + restaurantId + "/new-order";

            stompClient.subscribe(topicName, function (message) {
                let orderData = JSON.parse(message.body);
                console.log('New Order Received via Socket:', orderData);

                // Play Notification Sound
                ringBellSound();

                // UI Update: Only triggers if the page contains the orders grid
                // (Function defined in owner-today-order.jsp)
                if (typeof addRowInOrderTable === "function") {
                    addRowInOrderTable(
                        orderData.orderId,
                        orderData.customerName,
                        orderData.numberOfItems,
                        orderData.totalAmount,
                        orderData.status
                    );
                }
            });
        });
    }

    var orderAudio = new Audio('${pageContext.request.contextPath}/js/order_bell.wav');
    function ringBellSound() {
        let playPromise = orderAudio.play();

        if (playPromise !== undefined) {
            playPromise.catch(error => {
                // Auto-play was prevented
                console.warn("Sound blocked");

            });
        }
    }
    // --- SOCKET LOGIC END ---

    function highlightActiveLink() {
        const path = window.location.pathname;
        $('.nav-link-owner').each(function () {
            if ($(this).attr('href') === path) {
                $(this).addClass('active');
            }
        });
    }
</script>