<div class="text-center mb-3 mt-2">
    <div class="text-danger mb-2">
        <i class="fa-solid fa-arrow-right-from-bracket fs-1"></i>
    </div>
    <h5 class="fw-bold text-dark">Ready to leave?</h5>
    <p class="text-muted small">Are you sure you want to log out?</p>
</div>

<div class="d-flex justify-content-center gap-2">
    <button type="button" class="btn btn-light fw-bold px-4" data-bs-dismiss="modal">Cancel</button>
    <button type="button" class="btn btn-danger fw-bold px-4" id="confirmLogoutBtn">Yes, Logout</button>
</div>

<script>
    $('#confirmLogoutBtn').click(function() {
        // 1. Capture the current role before deleting it
        // Note: Check if you named it 'userRole' or 'role' in your login script
        const currentRole = localStorage.getItem('role') || localStorage.getItem('userRole');

        // 2. Clear all user data
        localStorage.clear();

        // 3. Hide the Modal
        const modalEl = document.getElementById('logoutModal');
        if (modalEl) {
            bootstrap.Modal.getInstance(modalEl).hide();
        }

        // 4. Update UI states (if functions exist)
        if (typeof checkAuthState === "function") checkAuthState();

        // 5. Show Feedback
        if (typeof showSuccessToast === "function") {
            showSuccessToast("Logged out successfully. See you soon!");
        }

        // 6. Role-Based Redirection Logic
        setTimeout(() => {
            if (currentRole === 'ROLE_RESTAURANT_OWNER') {
                // Take the owner back to their dedicated login
                window.location.href = '/owner/login';
            } else {
                // Take the customer back to the public home
                window.location.href = '/home';
            }
        }, 1000);
    });
</script>