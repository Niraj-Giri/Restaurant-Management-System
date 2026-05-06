<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="container py-4">
    <div class="row mb-4">
        <div class="col-12 d-flex justify-content-between align-items-center bg-white p-4 rounded-4 shadow-sm">
            <div>
                <h2 class="fw-bold text-dark mb-1"><i class="fa-solid fa-user-slash me-2 text-danger"></i>User Access Control</h2>
                <p class="text-muted mb-0">Manage which customers can place orders at this branch.</p>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light text-secondary small fw-bold">
                <tr>
                    <th class="py-3 px-4">Customer</th>
                    <th class="py-3">Contact</th>
                    <th class="py-3">Account Status</th>
                    <th class="py-3 text-end px-4">Action</th>
                </tr>
                </thead>
                <tbody id="customer-list-body">
                </tbody>
            </table>
        </div>
        <div id="table-spinner" class="text-center py-5">
            <div class="spinner-border text-primary" role="status"></div>
        </div>
    </div>
</div>
<div class="modal fade" id="blockReasonModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header border-0 pb-0">
                <h5 class="fw-bold text-dark mt-2 ps-2">
                    <i class="fa-solid fa-triangle-exclamation text-danger me-2"></i>Restrict User Access
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <form id="block-reason-form">
                    <input type="hidden" id="targetUserId">

                    <p class="small text-muted mb-3">Please provide a reason for blocking this customer. They will no longer be able to place orders at this branch.</p>

                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Reason for Block</label>
                        <textarea class="form-control bg-light border-0 py-2 rounded-3"
                                  id="blockReasonText" rows="3"
                                  placeholder="e.g., Repeated fake orders, disruptive behavior" required></textarea>
                    </div>

                    <div class="d-grid gap-2 mt-4">
                        <button type="submit" class="btn btn-danger py-2 fw-bold rounded-pill" id="confirmBlockBtn">
                            Confirm Restriction
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    $(document).ready(function() {
        const resId = localStorage.getItem('activeRestaurantId');
        const token = localStorage.getItem('token');

        if (!resId) {
            window.location.href = '/owner/select-restaurant';
            return;
        }

        fetchCustomers(resId, token);
    });

    function fetchCustomers(resId, token) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/restaurants/' + resId + '/customers',
            type: 'GET',
            headers: {'Authorization': 'Bearer ' + token},
            success: function(data) {
                $('#table-spinner').hide();
                const tbody = $('#customer-list-body').empty();

                if (data.length === 0) {
                    tbody.append('<tr><td colspan="4" class="text-center py-5 text-muted">No customers found for this branch.</td></tr>');
                    return;
                }

                data.forEach(user => {
                    // We check the status to see if they are currently blocked
                    // You may need an additional API check or field in the User object
                    checkIfBlocked(user.id, resId, token, function(isBlocked) {
                        const statusBadge = isBlocked
                            ? '<span class="badge bg-danger-subtle text-danger rounded-pill px-3">Blocked</span>'
                            : '<span class="badge bg-success-subtle text-success rounded-pill px-3">Active</span>';

                        const actionBtn = isBlocked
                            ? `<button class="btn btn-sm btn-outline-success rounded-pill fw-bold px-3" onclick="toggleBlock(\${user.id}, false)">Unblock</button>`
                            : `<button class="btn btn-sm btn-outline-danger rounded-pill fw-bold px-3" onclick="toggleBlock(\${user.id}, true)">Block User</button>`;

                        tbody.append(`
                        <tr id="user-row-\${user.id}">
                            <td class="px-4">
                                <div class="fw-bold text-dark">\${user.firstName} \${user.lastName}</div>
                                <div class="small text-muted">ID: #\${user.id}</div>
                            </td>
                            <td>
                                <div class="small fw-medium text-dark">\${user.email}</div>
                                <div class="small text-muted">\${user.mobileNumber}</div>
                            </td>
                            <td>\${statusBadge}</td>
                            <td class="text-end px-4">\${actionBtn}</td>
                        </tr>
                    `);
                    });
                });
            }
        });
    }

    function checkIfBlocked(userId, resId, token, callback) {
        $.ajax({
            url: '/api/restaurants/is-user-blocked',
            type: 'GET',
            headers: {'Authorization': 'Bearer ' + token},
            // This creates: /is-user-blocked?userId=X&restaurantId=Y
            data: {
                userId: userId,
                restaurantId: resId
            },
            success: function(res) { callback(res); },
            error: function() { callback(false); }
        });
    }

    function toggleBlock(userId, shouldBlock) {
        const resId = localStorage.getItem('activeRestaurantId');
        const token = localStorage.getItem('token');

        if (!shouldBlock) {
            // UNBLOCK logic: Send exactly what the DTO expects
            $.ajax({
                url: '${pageContext.request.contextPath}/api/restaurants/unblock-user',
                type: 'POST',
                headers: {'Authorization': 'Bearer ' + token},
                contentType: 'application/json',
                data: JSON.stringify({
                    userId: userId,
                    restaurantId: resId
                }),
                success: function() {
                    fetchCustomers(resId, token); // Refresh the list
                }
            });
        } else {
            // BLOCK logic: Open your modal as before
            $('#targetUserId').val(userId);
            $('#blockReasonModal').modal('show');
        }
    }
    $('#block-reason-form').on('submit', function(e) {
        e.preventDefault();

        const userId = $('#targetUserId').val();
        const reason = $('#blockReasonText').val().trim();
        const resId = localStorage.getItem('activeRestaurantId');
        const token = localStorage.getItem('token');

        $('#confirmBlockBtn').prop('disabled', true).text('Processing...');

        executeBlockAction(userId, resId, token, '/api/restaurants/block-user', reason, function() {
            $('#blockReasonModal').modal('hide');
            $('#confirmBlockBtn').prop('disabled', false).text('Confirm Restriction');
        });
    });
    function executeBlockAction(userId, resId, token, url, reason, callback) {
        $.ajax({
            url: '${pageContext.request.contextPath}' + url,
            type: 'POST',
            headers: {'Authorization': 'Bearer ' + token},
            contentType: 'application/json',
            data: JSON.stringify({
                userId: userId,
                reason: reason,
                restaurantId: resId
            }),
            success: function() {
                Swal.fire({
                    title: 'User Blocked',
                    text: 'The restriction has been applied.',
                    icon: 'warning',
                    timer: 1500,
                    showConfirmButton: false
                });
                fetchCustomers(resId, token);
                if (callback) callback();
            },
            error: function(xhr) {
                Swal.fire('Error', xhr.responseText || 'Action failed', 'error');
                if (callback) callback();
            }
        });
    }
</script>