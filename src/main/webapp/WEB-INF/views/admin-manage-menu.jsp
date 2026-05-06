<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container py-5">
    <div class="row mb-4">
        <div class="col-12 d-flex justify-content-between align-items-center bg-white p-4 rounded-4 shadow-sm">
            <div>
                <h2 class="fw-bold text-dark mb-1"><i class="fa-solid fa-utensils me-2 text-primary"></i>Branch Menu Control</h2>
                <p class="text-muted mb-0">Select a restaurant branch below to manage its specific menu items.</p>
            </div>
            <a href="/admin/add-menu" class="btn btn-primary rounded-pill px-4 fw-bold">
                <i class="fa-solid fa-plus-circle me-2"></i>Add New Item
            </a>
        </div>
    </div>

    <div class="card border-0 shadow-sm rounded-4 mb-4 p-4">
        <label class="form-label small fw-bold text-uppercase text-primary">Choose Restaurant</label>
        <select class="form-select bg-light border-0 py-3 rounded-3 fw-bold" id="resSelector">
            <option value="" selected disabled>-- Select a restaurant to load its menu --</option>
        </select>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden d-none" id="menu-container">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light text-secondary small fw-bold">
                <tr>
                    <th class="py-3 px-4">Item Name</th>
                    <th class="py-3">Price</th>
                    <th class="py-3">Status</th>
                    <th class="py-3 text-end px-4">Actions</th>
                </tr>
                </thead>
                <tbody id="menu-table-body"></tbody>
            </table>
        </div>
    </div>

    <div id="empty-state" class="text-center py-5 bg-white rounded-4 shadow-sm">
        <i class="fa-solid fa-store-slash fs-1 text-light mb-3"></i>
        <h5 class="text-muted">Select a branch above to view its menu</h5>
    </div>

    <div id="loader" class="text-center py-5 d-none">
        <div class="spinner-border text-primary" role="status"></div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        const token = localStorage.getItem('token');
        const contextPath = '${pageContext.request.contextPath}';

        // 1. Load the list of restaurants for the dropdown
        $.ajax({
            url: contextPath + '/api/restaurants/all?size=100',
            type: 'GET',
            headers: {'Authorization': 'Bearer ' + token},
            success: function(res) {
                const list = res.content || res;
                list.forEach(r => $('#resSelector').append(`<option value="\${r.id}">\${r.name}</option>`));
            }
        });

        // 2. When a restaurant is selected, fetch ONLY its menu
        $('#resSelector').on('change', function() {
            const selectedId = $(this).val();
            $('#empty-state').addClass('d-none');
            $('#menu-container').addClass('d-none');
            $('#loader').removeClass('d-none');

            loadMenuForRestaurant(selectedId, token, contextPath);
        });
    });

    function loadMenuForRestaurant(resId, token, contextPath) {
        $.ajax({
            // REUSING your existing endpoint: GET /api/restaurants/{id}/meals
            url: contextPath + '/api/restaurants/' + resId + '/meals?size=100',
            type: 'GET',
            headers: {'Authorization': 'Bearer ' + token},
            success: function(response) {
                $('#loader').addClass('d-none');
                const tbody = $('#menu-table-body').empty();
                const items = response.content || response;

                if (!items || items.length === 0) {
                    tbody.append('<tr><td colspan="4" class="text-center py-5 text-muted">No items found for this branch.</td></tr>');
                } else {
                    items.forEach(item => {
                        tbody.append(`
                        <tr>
                            <td class="px-4">
                                <div class="fw-bold text-dark">\${item.name}</div>
                                <div class="small text-muted">\${item.description || '-'}</div>
                            </td>
                            <td class="fw-bold text-primary">Rs \${item.price.toFixed(2)}</td>
                            <td>
                                \${item.deleted
                                    ? '<span class="badge bg-danger-subtle text-danger rounded-pill">Inactive</span>'
                                    : '<span class="badge bg-success-subtle text-success rounded-pill">Active</span>'}
                            </td>
                            <td class="text-end px-4">
                                <a href="\${contextPath}/admin/add-menu?id=\${item.id}" class="btn btn-sm btn-outline-primary rounded-pill px-3 me-2">
                                    <i class="fa-solid fa-pen"></i> Edit
                                </a>
                                <button class="btn btn-sm btn-outline-danger rounded-pill px-3" onclick="deleteItem(\${item.id})">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `);
                    });
                }
                $('#menu-container').removeClass('d-none');
            }
        });
    }

    function deleteItem(id) {
        Swal.fire({
            title: 'Delete this item?',
            text: "This dish will be removed from the restaurant menu.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#0d6efd',
            cancelButtonColor: '#dc3545',
            confirmButtonText: 'Yes, delete it!',
            customClass: { popup: 'rounded-4' }
        }).then((result) => {
            if (result.isConfirmed) {
                const token = localStorage.getItem('token');
                $.ajax({
                    // Ensure this matches your @DeleteMapping in the backend
                    url: '${pageContext.request.contextPath}/api/restaurants/menu/' + id,
                    type: 'DELETE',
                    headers: {'Authorization': 'Bearer ' + token},
                    success: function() {
                        Swal.fire({
                            title: 'Deleted!',
                            icon: 'success',
                            timer: 1000,
                            showConfirmButton: false
                        }).then(() => {
                            // Refresh the table by re-triggering the change event
                            $('#resSelector').trigger('change');
                        });
                    },
                    error: function(xhr) {
                        Swal.fire('Error!', xhr.responseText || 'Could not delete item', 'error');
                    }
                });
            }
        });
    }
</script>