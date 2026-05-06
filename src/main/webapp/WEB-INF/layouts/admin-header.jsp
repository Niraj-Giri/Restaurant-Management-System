<style>
    :root {
        --sidebar-width: 280px;
        --admin-purple: #6366f1; /* Changed color to distinguish from owner blue */
        --bg-light: #f8fafc;
        --text-muted: #64748b;
    }

    body {
        background-color: var(--bg-light);
        padding-left: var(--sidebar-width);
        transition: padding 0.3s ease;
    }

    .sidebar-admin {
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

    .admin-brand-custom {
        font-weight: 800;
        font-size: 1.4rem;
        color: var(--admin-purple) !important;
        text-decoration: none;
        display: flex;
        align-items: center;
    }

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

    .nav-link-admin {
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

    .nav-link-admin i {
        width: 28px;
        font-size: 1.1rem;
    }

    .nav-link-admin:hover {
        background: #f1f5f9;
        color: var(--admin-purple) !important;
    }

    .nav-link-admin.active {
        background: #f5f3ff;
        color: var(--admin-purple) !important;
    }

    .sidebar-footer {
        padding: 1.5rem;
        border-top: 1px solid #f1f5f9;
    }

    .admin-indicator {
        width: 10px;
        height: 10px;
        background: #8b5cf6;
        border-radius: 50%;
        display: inline-block;
        margin-right: 10px;
    }

    @media (max-width: 992px) {
        body { padding-left: 0; }
        .sidebar-admin { transform: translateX(-100%); transition: transform 0.3s ease; }
        .sidebar-admin.active { transform: translateX(0); }
    }
</style>
<aside class="sidebar-admin shadow-sm" id="mainSidebar">
    <div class="sidebar-header">
        <i class="fa-solid fa-shield-halved me-2"></i>
        <span>Admin Console</span>
    </div>

    <div class="sidebar-body">
        <div class="nav-section-label">Restaurant Ops</div>
        <ul class="nav flex-column mb-3">
            <li class="nav-item">
                <a class="nav-link nav-link-admin" href="/admin/manage-restaurant">
                    <i class="fa-solid fa-list-check"></i> Manage Restaurants
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link nav-link-admin" href="/admin/manage-menu">
                    <i class="fa-solid fa-utensils"></i> Manage Menus
                </a>
            </li>
        </ul>

        <div class="nav-section-label">User Management</div>
        <ul class="nav flex-column mb-3">
            <li class="nav-item">
                <a class="nav-link nav-link-admin" href="/admin/manage-user"> <i class="fa-solid fa-users-gear"></i> Manage Users
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link nav-link-admin" href="/admin/add-user">
                    <i class="fa-solid fa-user-plus"></i> Add User
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link nav-link-admin" href="/admin/block-user">
                    <i class="fa-solid fa-user-lock"></i> Block History
                </a>
            </li>
        </ul>

        <div class="nav-section-label">Promotions</div>
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link nav-link-admin" href="/admin/manage-coupon"> <i class="fa-solid fa-tags"></i> Manage Coupons
                </a>
            </li>
            <!-- li class="nav-item">
                <a class="nav-link nav-link-admin" href="/admin/add-coupon">
                    <i class="fa-solid fa-ticket"></i> Add Coupons
                </a>
            </li-->
        </ul>
    </div>
    <div class="sidebar-footer">
        <div class="dropdown">
            <button class="btn btn-light w-100 border rounded-pill py-2 px-3 dropdown-toggle d-flex align-items-center" type="button" data-bs-toggle="dropdown">
                <span class="admin-indicator"></span>
                <span id="admin-display-name" class="small fw-bold">System Admin</span>
            </button>
            <ul class="dropdown-menu shadow border-0 rounded-4 p-2 mb-2 w-100">
                <li>
                    <button class="dropdown-item py-2 text-danger fw-bold rounded-3" onclick="executeLogout()">
                        <i class="fa-solid fa-right-from-bracket me-2"></i> Logout
                    </button>
                </li>
            </ul>
        </div>
    </div>

</aside>
    <script>
        $(document).ready(function() {
            // 1. Strict Admin Check
            const role = localStorage.getItem('role');
            const token = localStorage.getItem('token');

            if (role !== 'ROLE_ADMIN' || !token) {
                localStorage.clear();
                window.location.href = '/owner/login';
                return;
            }

            highlightActiveLink();
            $('#admin-display-name').text(localStorage.getItem('userEmail') || 'Administrator');
        });

        function highlightActiveLink() {
            const path = window.location.pathname;
            $('.nav-link-admin').each(function() {
                if ($(this).attr('href') === path) {
                    $(this).addClass('active');
                }
            });
        }

        function executeLogout() {
            localStorage.clear();
            sessionStorage.clear();
            window.location.href = '/owner/login';
        }

        function toggleSidebar() {
            $('#mainSidebar').toggleClass('active');
        }

    </script>