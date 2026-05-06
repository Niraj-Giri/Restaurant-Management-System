<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container py-5">
    <div class="row mb-4">
        <div class="col-12 d-flex justify-content-between align-items-center bg-white p-4 rounded-4 shadow-sm">
            <div>
                <h2 class="fw-bold text-dark mb-1"><i class="fa-solid fa-utensils me-2 text-primary"></i>Branch Menu Control</h2>
                <p class="text-muted mb-0">Select one of your branches to manage its specific menu items.</p>
            </div>
            <a href="/owner/addmenu" class="btn btn-primary rounded-pill px-4 fw-bold">
                <i class="fa-solid fa-plus-circle me-2"></i>Add New Item
            </a>
        </div>
    </div>

    <div class="card border-0 shadow-sm rounded-4 mb-4 p-4">
        <label class="form-label small fw-bold text-uppercase text-primary">Select Your Branch</label>
        <select class="form-select bg-light border-0 py-3 rounded-3 fw-bold" id="resSelector">
            <option value="" selected disabled>-- Select a branch --</option>
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
<script>
    $(document).ready(function() {
        const token = localStorage.getItem('token');
        const contextPath = '${pageContext.request.contextPath}';
        const activeResId = localStorage.getItem('activeRestaurantId');

        // 1. Fetch only THIS owner's restaurants
        $.ajax({
            url: contextPath + '/api/restaurants/my-all-restaurants',
            type: 'GET',
            headers: {'Authorization': 'Bearer ' + token},
            success: function(list) {
                list.forEach(r => {
                    const selected = (activeResId == r.id) ? 'selected' : '';
                    $('#resSelector').append(`<option value="\${r.id}" \${selected}>\${r.name}</option>`);
                });

                // 2. Auto-load if an active restaurant is already in storage
                if (activeResId && activeResId !== "null") {
                    $('#resSelector').trigger('change');
                }
            }
        });

        $('#resSelector').on('change', function() {
            const selectedId = $(this).val();
            // Update local storage so the rest of the app knows which branch is active
            localStorage.setItem('activeRestaurantId', selectedId);

            $('#empty-state').addClass('d-none');
            $('#menu-container').addClass('d-none');
            $('#loader').removeClass('d-none');

            loadMenuForRestaurant(selectedId, token, contextPath);
        });
    });

    function loadMenuForRestaurant(resId, token, contextPath) {
        $.ajax({
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
                                <div class="small text-muted text-truncate" style="max-width: 250px;">\${item.description || '-'}</div>
                            </td>
                            <td class="fw-bold text-primary">₹\${item.price.toFixed(2)}</td>
                            <td>
                                \${item.deleted
                                    ? '<span class="badge bg-danger-subtle text-danger rounded-pill">Inactive</span>'
                                    : '<span class="badge bg-success-subtle text-success rounded-pill">Active</span>'}
                            </td>
                            <td class="text-end px-4">
                                <a href="\${contextPath}/owner/addmenu?id=\${item.id}"
                                   class="btn btn-sm btn-outline-primary rounded-pill px-3 me-2">
                                    <i class="fa-solid fa-pen me-1"></i> Edit
                                </a>

                                <button class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                        onclick="deleteItem(\${item.id})">
                                    <i class="fa-solid fa-trash me-1"></i> Delete
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
            title: 'Remove from Menu?',
            text: "This item will be deactivated and hidden from customers.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545', // Danger Red
            cancelButtonColor: '#6c757d',  // Muted Grey
            confirmButtonText: 'Yes, remove it',
            cancelButtonText: 'Cancel',
            customClass: {
                popup: 'rounded-4 border-0 shadow-lg',
                confirmButton: 'rounded-pill px-4 fw-bold',
                cancelButton: 'rounded-pill px-4 fw-bold'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                const token = localStorage.getItem('token');
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/restaurants/menu/' + id,
                    type: 'DELETE',
                    headers: {'Authorization': 'Bearer ' + token},
                    success: function() {
                        Swal.fire({
                            title: 'Success!',
                            text: 'Item has been removed.',
                            icon: 'success',
                            timer: 1500,
                            showConfirmButton: false,
                            customClass: { popup: 'rounded-4' }
                        }).then(() => {
                            // Refresh table logic
                            const activeResId = localStorage.getItem('activeRestaurantId');
                            loadMenuForRestaurant(activeResId, token, '${pageContext.request.contextPath}');
                        });
                    },
                    error: function(xhr) {
                        Swal.fire('Error', xhr.responseText || 'Failed to delete item.', 'error');
                    }
                });
            }
        });
    }
</script>