<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4 bg-white p-4 rounded-4 shadow-sm">
        <div>
            <h2 class="fw-bold text-dark mb-1">My Branches</h2>
            <p class="text-muted mb-0">Manage and update the details of your restaurant locations.</p>
        </div>
        <a href="/owner/add-restaurant" class="btn btn-primary rounded-pill px-4 fw-bold">
            <i class="fa-solid fa-plus me-2"></i>New Branch
        </a>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <table class="table table-hover align-middle mb-0">
            <thead class="bg-light text-secondary small fw-bold text-uppercase">
            <tr>
                <th class="py-3 px-4">Branch ID</th>
                <th class="py-3">Restaurant Details</th>
                <th class="py-3 text-end px-4">Actions</th>
            </tr>
            </thead>
            <tbody id="owner-res-table-body">
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    $(document).ready(function() {
        const token = localStorage.getItem('token');
        const contextPath = '${pageContext.request.contextPath}';

        $.ajax({
            // Endpoint that returns only restaurants for the current owner
            url: contextPath + '/api/restaurants/my-all-restaurants',
            type: 'GET',
            headers: {'Authorization': 'Bearer ' + token},
            success: function(list) {
                const tbody = $('#owner-res-table-body').empty();

                if (list.length === 0) {
                    tbody.append('<tr><td colspan="3" class="text-center py-5 text-muted">No branches found. Start by adding one!</td></tr>');
                    return;
                }

                list.forEach(res => {
                    tbody.append(`
                        <tr>
                            <td class="px-4 fw-bold text-primary">#\${res.id}</td>
                            <td>
                                <div class="fw-bold text-dark">\${res.name}</div>
                                <div class="small text-muted text-truncate" style="max-width: 400px;">
                                    \${res.description || 'No description provided.'}
                                </div>
                            </td>
                            <td class="text-end px-4">
                                <a href="/owner/add-restaurant?id=\${res.id}" class="btn btn-sm btn-outline-primary rounded-pill px-3 me-1">
                                    <i class="fa-solid fa-pen"></i> Edit
                                </a>
                                <button class="btn btn-sm btn-outline-danger rounded-pill px-3" onclick="deleteBranch(\${res.id})">
                                    <i class="fa-solid fa-trash"></i> Delete
                                </button>
                            </td>
                        </tr>
                    `);
                });
            },
            error: function() {
                Swal.fire('Error', 'Failed to load your branches.', 'error');
            }
        });
    });

    function deleteBranch(id) {
        Swal.fire({
            title: 'Delete Branch?',
            text: "All associated menus and staff links will be affected!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, delete it',
            customClass: { popup: 'rounded-4' }
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/restaurants/restaurant/' + id,
                    type: 'DELETE',
                    headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
                    success: function() {
                        Swal.fire('Deleted!', 'Branch removed successfully.', 'success').then(() => {
                            location.reload();
                        });
                    },
                    error: function(xhr) {
                        Swal.fire('Error', xhr.responseText || 'Cannot delete branch.', 'error');
                    }
                });
            }
        });
    }
</script>