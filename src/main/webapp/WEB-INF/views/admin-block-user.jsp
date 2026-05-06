<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="adminToast" class="toast align-items-center text-white border-0 rounded-3 shadow" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body" id="toastMessage"></div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<div class="container py-5">
    <div class="row mb-4">
        <div class="col-12 bg-white p-4 rounded-4 shadow-sm">
            <h2 class="fw-bold text-dark mb-1"><i class="fa-solid fa-user-shield me-2 text-primary"></i>Restaurant Customer Control</h2>
            <p class="text-muted mb-0">Select a restaurant to manage its specific customer base and access levels.</p>
        </div>
    </div>

    <div class="card border-0 shadow-sm rounded-4 mb-4 p-4">
        <label class="form-label small fw-bold text-uppercase text-primary">Target Restaurant</label>
        <select class="form-select bg-light border-0 py-3 rounded-3 fw-bold" id="adminTargetResId">
            <option value="" selected disabled>-- Choose a restaurant to view its customers --</option>
        </select>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden d-none" id="customer-table-container">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light text-secondary small fw-bold">
                <tr>
                    <th class="py-3 px-4">Customer Details</th>
                    <th class="py-3">Contact Information</th>
                    <th class="py-3">Current Status</th>
                    <th class="py-3 text-end px-4">Action</th>
                </tr>
                </thead>
                <tbody id="admin-user-table-body"></tbody>
            </table>
        </div>
    </div>

    <div id="empty-state" class="text-center py-5 bg-white rounded-4 shadow-sm mt-2">
        <i class="fa-solid fa-utensils fs-1 text-light mb-3"></i>
        <h5 class="text-muted">Please select a restaurant to load customer data</h5>
    </div>

    <div id="admin-table-spinner" class="text-center py-5 d-none">
        <div class="spinner-border text-primary" role="status"></div>
        <p class="text-muted mt-2">Fetching customers...</p>
    </div>
</div>

<div class="modal fade" id="adminBlockModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-body p-4 text-center">
                <div class="mb-3"><i class="fa-solid fa-user-lock text-danger fs-1"></i></div>
                <h5 class="fw-bold mb-2">Restrict Customer</h5>
                <input type="hidden" id="adminTargetUserId">
                <textarea class="form-control bg-light border-0 mb-3 py-3 px-4 rounded-3" id="adminBlockReason" rows="3" placeholder="Reason for blocking..."></textarea>
                <div class="d-flex gap-2">
                    <button class="btn btn-light w-100 rounded-pill fw-bold" data-bs-dismiss="modal">Cancel</button>
                    <button class="btn btn-danger w-100 rounded-pill fw-bold" id="confirmBlockBtn" onclick="submitAdminBlock()">Confirm Block</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        const token = localStorage.getItem('token');

        // Load all restaurants for the dropdown
        $.ajax({
            url: '${pageContext.request.contextPath}/api/restaurants/all?size=100',
            type: 'GET',
            headers: {'Authorization': 'Bearer ' + token},
            success: function(res) {
                const list = res.content || res;
                list.forEach(r => $('#adminTargetResId').append(`<option value="\${r.id}">\${r.name}</option>`));
            }
        });

        // Trigger load when restaurant changes
        $('#adminTargetResId').on('change', function() {
            const resId = $(this).val();
            if (resId) {
                $('#empty-state').addClass('d-none');
                $('#customer-table-container').addClass('d-none');
                $('#admin-table-spinner').removeClass('d-none');
                loadRestaurantCustomers(resId, token);
            }
        });
    });

    function loadRestaurantCustomers(resId, token) {
        $.ajax({
            // Fetch ONLY the customers of the selected restaurant
            url: '${pageContext.request.contextPath}/api/restaurants/' + resId + '/customers',
            type: 'GET',
            headers: {'Authorization': 'Bearer ' + token},
            success: function(users) {
                $('#admin-table-spinner').addClass('d-none');
                const tbody = $('#admin-user-table-body').empty();

                if (!users || users.length === 0) {
                    tbody.append('<tr><td colspan="4" class="text-center py-5 text-muted">No customers found for this restaurant.</td></tr>');
                } else {
                    users.forEach(user => {
                        // We check status for each customer found
                        checkIfBlockedAndAppend(user, resId, token, tbody);
                    });
                }
                $('#customer-table-container').removeClass('d-none');
            },
            error: function() {
                $('#admin-table-spinner').addClass('d-none');
                showToast("Failed to load customers", "danger");
            }
        });
    }

    function checkIfBlockedAndAppend(user, resId, token, tbody) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/restaurants/is-user-blocked',
            type: 'GET',
            headers: {'Authorization': 'Bearer ' + token},
            data: { userId: user.id, restaurantId: resId },
            success: function(isBlocked) {
                const statusBadge = isBlocked
                    ? '<span class="badge bg-danger-subtle text-danger rounded-pill px-3">Blocked</span>'
                    : '<span class="badge bg-success-subtle text-success rounded-pill px-3">Active</span>';

                const actionBtn = isBlocked
                    ? `<button class="btn btn-sm btn-success rounded-pill px-3" onclick="handleUnblock(\${user.id})">Unblock</button>`
                    : `<button class="btn btn-sm btn-outline-danger rounded-pill px-3" onclick="openAdminBlockModal(\${user.id})">Block</button>`;

                tbody.append(`
                    <tr>
                        <td class="px-4">
                            <div class="fw-bold">\${user.firstName} \${user.lastName}</div>
                            <div class="small text-muted">User ID: #\${user.id}</div>
                        </td>
                        <td>
                            <div class="small fw-bold">\${user.email}</div>
                            <div class="small text-muted">\${user.mobileNumber || 'N/A'}</div>
                        </td>
                        <td>\${statusBadge}</td>
                        <td class="text-end px-4">\${actionBtn}</td>
                    </tr>
                `);
            }
        });
    }

    // Modal Logic
    function openAdminBlockModal(userId) {
        $('#adminTargetUserId').val(userId);
        $('#adminBlockReason').val('');
        $('#adminBlockModal').modal('show');
    }

    function submitAdminBlock() {
        const token = localStorage.getItem('token');
        const resId = $('#adminTargetResId').val();
        const btn = $('#confirmBlockBtn');

        btn.prop('disabled', true).text('Blocking...');

        $.ajax({
            url: '${pageContext.request.contextPath}/api/restaurants/block-user',
            type: 'POST',
            headers: {'Authorization': 'Bearer ' + token},
            contentType: 'application/json',
            data: JSON.stringify({
                userId: $('#adminTargetUserId').val(),
                restaurantId: resId,
                reason: $('#adminBlockReason').val()
            }),
            success: function() {
                $('#adminBlockModal').modal('hide');
                showToast("Customer blocked successfully");
                loadRestaurantCustomers(resId, token);
            },
            error: function() { showToast("Action failed", "danger"); },
            complete: function() { btn.prop('disabled', false).text('Confirm Block'); }
        });
    }

    function handleUnblock(userId) {
        const token = localStorage.getItem('token');
        const resId = $('#adminTargetResId').val();

        $.ajax({
            url: '${pageContext.request.contextPath}/api/restaurants/unblock-user',
            type: 'POST',
            headers: {'Authorization': 'Bearer ' + token},
            contentType: 'application/json',
            data: JSON.stringify({ userId: userId, restaurantId: resId }),
            success: function() {
                showToast("Customer unblocked successfully");
                loadRestaurantCustomers(resId, token);
            }
        });
    }

    function showToast(message, type = 'success') {
        const toastEl = $('#adminToast');
        toastEl.removeClass('bg-success bg-danger').addClass(type === 'success' ? 'bg-success' : 'bg-danger');
        $('#toastMessage').text(message);
        new bootstrap.Toast(toastEl).show();
    }
</script>