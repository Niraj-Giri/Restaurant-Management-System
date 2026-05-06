<style>
    .navbar-owner {
        background: #ffffff !important;
        border-bottom: 2px solid #f1f5f9;
        padding: 1rem 0;
    }
    .owner-brand-custom {
        font-weight: 800; font-size: 1.6rem; color: #0d6efd !important;
        text-decoration: none; display: flex; align-items: center; transition: opacity 0.2s;
    }
    .owner-brand-custom:hover { opacity: 0.8; }
    .nav-link-owner {
        font-weight: 600; color: #475569 !important; margin-right: 20px;
        transition: 0.2s; padding: 8px 12px !important; border-radius: 8px;
    }
    .nav-link-owner:hover { color: #0d6efd !important; background: #f8fafc; }
    .nav-link-owner.active { color: #0d6efd !important; background: #eff6ff; }
    .owner-indicator {
        width: 8px; height: 8px; background: #10b981;
        border-radius: 50%; display: inline-block; margin-right: 8px;
    }
</style>

<nav class="navbar navbar-expand-lg sticky-top navbar-owner">
    <div class="container">
        <div class="d-flex align-items-center">
            <a class="owner-brand-custom" href="/staff/assigned-orders">
                <i class="fa-solid fa-motorcycle me-2"></i>
                <span id="staff-res-name">Loading...</span>
            </a>
        </div>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#staffNav">
            <i class="fa-solid fa-bars"></i>
        </button>

        <div class="collapse navbar-collapse" id="staffNav">
            <ul class="navbar-nav mx-auto">
                <li class="nav-item">
                    <a class="nav-link nav-link-owner" href="/staff/assigned-orders">
                        <i class="fa-solid fa-clipboard-list me-1"></i> Assigned Orders
                    </a>
                </li>
                <!-- li class="nav-item">
                    <a class="nav-link nav-link-owner" href="/staff/delivery-histroy">
                        <i class="fa-solid fa-circle-check me-1"></i> Delivery history
                    </a>
                </li-->
            </ul>

            <div class="d-flex align-items-center">
                <div class="dropdown">
                    <button class="btn btn-light border rounded-pill px-3 dropdown-toggle fw-bold d-flex align-items-center" type="button" data-bs-toggle="dropdown">
                        <span class="owner-indicator"></span>
                        <i class="fa-solid fa-user-gear me-2"></i> Staff Account
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-4 p-2 mt-2" style="min-width: 180px;">
                        <li class="px-3 py-2 border-bottom mb-1">
                            <small class="text-muted d-block">Staff Member</small>
                            <span id="staff-email-display" class="fw-bold small text-truncate d-block">---</span>
                        </li>
                        <li>
                            <button class="dropdown-item py-2 text-danger fw-bold rounded-3" data-bs-toggle="modal" data-bs-target="#logoutModalStaff">
                                <i class="fa-solid fa-right-from-bracket me-2"></i> Logout
                            </button>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</nav>

<div class="modal fade" id="logoutModalStaff" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content p-4 shadow border-0 rounded-4 text-center">
            <h5 class="fw-bold">Ready to leave?</h5>
            <p class="text-muted small">Select "Logout" below if you are ready to end your session.</p>
            <div class="d-grid gap-2">
                <button class="btn btn-danger rounded-pill fw-bold" onclick="executeLogout()">Logout</button>
                <button class="btn btn-light rounded-pill fw-bold border" data-bs-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // 1. STRICT ROLE GUARD
        const role = localStorage.getItem('role');
        const token = localStorage.getItem('token');

        if (!token || role !== 'ROLE_RESTAURANT_STAFF') {
            window.location.replace('/owner/login'); // Redirect to login if not staff
            return;
        }

        fetchStaffContext();
        setActiveLink();
    });

    function fetchStaffContext() {
        const token = localStorage.getItem('token');
        const email = localStorage.getItem('userEmail') || 'Staff Member';

        $('#staff-email-display').text(email);

        $.ajax({
            url: '/api/staff/my-restaurant',
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(res) {
                $('#staff-res-name').text(res.name || 'Staff Portal');
            },
            error: function() {
                $('#staff-res-name').text('Staff Portal');
            }
        });
    }

    function setActiveLink() {
        const path = window.location.pathname;
        $('.nav-link-owner').each(function() {
            if ($(this).attr('href') === path) {
                $(this).addClass('active');
            }
        });
    }

    function executeLogout() {
        localStorage.clear();
        window.location.replace('/owner/login');
    }
</script>