<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4 bg-white p-4 rounded-4 shadow-sm">
        <h2 class="fw-bold text-dark mb-0">Restaurant Management</h2>
        <a href="/admin/add-restaurant" class="btn btn-primary rounded-pill px-4 fw-bold">
            <i class="fa-solid fa-plus me-2"></i>New Restaurant
        </a>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <table class="table table-hover align-middle mb-0">
            <thead class="bg-light text-secondary small fw-bold text-uppercase">
            <tr>
                <th class="py-3 px-4">ID</th>
                <th class="py-3">Details</th>
                <th class="py-3">Owner</th>
                <th class="py-3 text-end px-4">Actions</th>
            </tr>
            </thead>
            <tbody id="res-table-body"></tbody>
        </table>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        const token = localStorage.getItem('token');
        $.ajax({
            url: '/api/restaurants/all?size=100',
            type: 'GET',
            headers: {'Authorization': 'Bearer ' + token},
            success: function(response) {
                // Handle both Page objects and simple Arrays
                const list = response.content || response;

                const tbody = $('#res-table-body');
                tbody.empty(); // Clear existing rows before appending

                // ONLY ONE LOOP HERE
                list.forEach(res => {
                    // Safely construct owner info
                    const ownerName = res.owner
                        ? (res.owner.firstName + " " + (res.owner.lastName || "")).trim()
                        : "Unassigned";
                    const ownerEmail = res.owner ? res.owner.email : "N/A";

                    tbody.append(`
                        <tr>
                            <td class="px-4 fw-bold text-primary">#\${res.id}</td>
                            <td>
                                <div class="fw-bold text-dark">\${res.name}</div>
                                <div class="small text-muted">\${res.description || 'No description'}</div>
                            </td>
                            <td>
                                <div class="small fw-bold">\${ownerName}</div>
                                <div class="small text-muted">\${ownerEmail}</div>
                            </td>
                            <td class="text-end px-4">
                                <a href="/admin/add-restaurant?id=\${res.id}" class="btn btn-sm btn-outline-primary rounded-pill px-3 me-1">
                                    <i class="fa-solid fa-pen"></i> Edit
                                </a>
                                <button class="btn btn-sm btn-outline-danger rounded-pill px-3" onclick="deleteRes(\${res.id})">
                                    <i class="fa-solid fa-trash"></i> Delete
                                </button>
                            </td>
                        </tr>
                    `);
                });
            }
        });
    });

    function deleteRes(id) {
        Swal.fire({
            title: 'Are you sure?',
            text: "This will permanently remove this restaurant from the system!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#0d6efd', // Matches your Bootstrap Primary
            cancelButtonColor: '#dc3545',  // Matches your Bootstrap Danger
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'No, keep it',
            customClass: {
                popup: 'rounded-4 border-0 shadow-lg',
                confirmButton: 'rounded-pill px-4 fw-bold',
                cancelButton: 'rounded-pill px-4 fw-bold'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                const token = localStorage.getItem('token');

                $.ajax({
                    url: '/api/restaurants/restaurant/' + id,
                    type: 'DELETE',
                    headers: {'Authorization': 'Bearer ' + token},
                    success: function() {
                        Swal.fire({
                            title: 'Deleted!',
                            text: 'Restaurant has been removed.',
                            icon: 'success',
                            timer: 1500,
                            showConfirmButton: false,
                            customClass: { popup: 'rounded-4' }
                        }).then(() => {
                            location.reload();
                        });
                    },
                    error: function(xhr) {
                        Swal.fire({
                            title: 'Error!',
                            text: xhr.responseText || 'Could not delete restaurant.',
                            icon: 'error',
                            customClass: { popup: 'rounded-4' }
                        });
                    }
                });
            }
        });
    }
</script>