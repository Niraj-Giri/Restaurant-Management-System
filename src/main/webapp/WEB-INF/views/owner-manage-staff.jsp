<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4 bg-white p-4 rounded-4 shadow-sm">
        <div>
            <h2 class="fw-bold text-dark mb-1"><i class="fa-solid fa-users-gear me-2 text-primary"></i>Staff Management</h2>
            <p class="text-muted mb-0">Manage employees assigned to this specific branch.</p>
        </div>
        <a href="/owner/add-staff" class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm">
            <i class="fa-solid fa-user-plus me-2"></i>Register New Staff
        </a>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light text-secondary small fw-bold text-uppercase">
                <tr>
                    <th class="py-3 px-4">Staff Member</th>
                    <th class="py-3">Contact Details</th>
                    <th class="py-3">Status</th>
                    <th class="py-3 text-end px-4">Actions</th>
                </tr>
                </thead>
                <tbody id="staff-table-body">
                </tbody>
            </table>
        </div>
        <div id="staff-loader" class="text-center py-5">
            <div class="spinner-border text-primary" role="status"></div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    $(document).ready(function() {
        const token = localStorage.getItem('token');
        const resId = localStorage.getItem('activeRestaurantId');
        const contextPath = '${pageContext.request.contextPath}';

        if (!resId) {
            Swal.fire('No Branch Selected', 'Please select a restaurant branch first.', 'warning')
                .then(() => window.location.href = '/owner/select-restaurant');
            return;
        }

        function loadStaffList() {
            $.ajax({
                url: `\${contextPath}/api/restaurants/\${resId}/staff`,
                type: 'GET',
                headers: {'Authorization': 'Bearer ' + token},
                success: function(data) {
                    $('#staff-loader').hide();
                    const tbody = $('#staff-table-body').empty();

                    if (!data || data.length === 0) {
                        tbody.append('<tr><td colspan="4" class="text-center py-5 text-muted">No staff members found for this branch.</td></tr>');
                        return;
                    }

                    data.forEach(item => {
                        const s = item.staff; // The User object inside RestaurantStaff
                        tbody.append(`
                            <tr>
                                <td class="px-4">
                                    <div class="fw-bold text-dark">\${s.firstName} \${s.lastName}</div>
                                    <div class="small text-muted">ID: #\${s.id}</div>
                                </td>
                                <td>
                                    <div class="small fw-bold text-dark">\${s.email}</div>
                                    <div class="small text-muted">\${s.mobileNumber || 'No mobile number'}</div>
                                </td>
                                <td>
                                    <span class="badge bg-success-subtle text-success rounded-pill px-3">Active</span>
                                </td>
                                <td class="text-end px-4">
                                    <a href="\${contextPath}/owner/add-staff?id=\${s.id}"
                                       class="btn btn-sm btn-outline-primary rounded-pill px-3 me-2">
                                        <i class="fa-solid fa-pen"></i> Edit
                                    </a>
                                    <button class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                            onclick="removeStaffLink(\${item.id})">
                                        <i class="fa-solid fa-user-minus"></i> Remove
                                    </button>
                                </td>
                            </tr>
                        `);
                    });
                },
                error: function(xhr) {
                    $('#staff-loader').hide();
                    Swal.fire('Error', 'Failed to load staff members.', 'error');
                }
            });
        }

        loadStaffList();
    });

    function removeStaffLink(mappingId) {
        Swal.fire({
            title: 'Remove Staff access?',
            text: "This user will no longer be able to manage this branch.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            confirmButtonText: 'Yes, remove them',
            customClass: { popup: 'rounded-4' }
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/restaurants/staff/' + mappingId,
                    type: 'DELETE',
                    headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
                    success: function() {
                        Swal.fire({
                            title: 'Removed!',
                            icon: 'success',
                            timer: 1000,
                            showConfirmButton: false
                        }).then(() => location.reload());
                    }
                });
            }
        });
    }
</script>