<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4 bg-white p-4 rounded-4 shadow-sm">
        <div>
            <h2 class="fw-bold text-dark mb-1">System User Access</h2>
            <p class="text-muted mb-0">Manage administrators and restaurant partners.</p>
        </div>
        <a href="/admin/add-user" class="btn btn-primary rounded-pill px-4 fw-bold">
            <i class="fa-solid fa-user-plus me-2"></i>Add New User
        </a>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <table class="table table-hover align-middle mb-0">
            <thead class="bg-light text-secondary small fw-bold text-uppercase">
            <tr>
                <th class="py-3 px-4">User Details</th>
                <th class="py-3">Role</th>
                <th class="py-3">Email</th>
                <th class="py-3 text-end px-4">Actions</th>
            </tr>
            </thead>
            <tbody id="user-table-body"></tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    $(document).ready(function() {
        const token = localStorage.getItem('token');
        const contextPath = '${pageContext.request.contextPath}';

        function loadInternalUsers() {
            $.ajax({
                url: contextPath + '/admin/internal-users', // Backend should filter roles here
                type: 'GET',
                headers: {'Authorization': 'Bearer ' + token},
                success: function(users) {
                    const tbody = $('#user-table-body').empty();
                    users.forEach(user => {
                        const roleClass = user.role === 'ADMIN' ? 'bg-primary' : 'bg-info';
                        tbody.append(`
                            <tr>
                                <td class="px-4">
                                    <div class="fw-bold text-dark">\${user.firstName} \${user.lastName}</div>
                                    <div class="small text-muted">UID: #\${user.id}</div>
                                </td>
                                <td><span class="badge \${roleClass} rounded-pill">\${user.role}</span></td>
                                <td>\${user.email}</td>
                                <td class="text-end px-4">
                                     <a href="/admin/add-user?id=\${user.id}" class="btn btn-sm btn-outline-primary rounded-pill px-3 me-1">
                                    <i class="fa-solid fa-pen"></i> Edit
                                </a>
                                    <button class="btn btn-sm btn-outline-danger rounded-pill px-3" onclick="deleteUser(\${user.id})">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        `);
                    });
                }
            });
        }
        loadInternalUsers();
    });

    function deleteUser(id) {
        Swal.fire({
            title: 'Delete User?',
            text: "This user will lose all system access!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, remove them',
            customClass: { popup: 'rounded-4' }
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/user/' + id,
                    type: 'DELETE',
                    headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
                    success: function() {
                        Swal.fire('Deleted!', 'User access revoked.', 'success').then(() => location.reload());
                    }
                });
            }
        });
    }
</script>