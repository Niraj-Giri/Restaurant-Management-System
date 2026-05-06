<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="card-header bg-primary py-4 text-center border-0">
                    <i class="fa-solid fa-utensils text-white fs-1 mb-2"></i>
                    <h3 class="fw-bold text-white mb-0">Global Menu Management</h3>
                </div>

                <div class="card-body p-5">
                    <form id="admin-add-menu-form">
                        <div class="mb-4">
                            <label class="form-label small fw-bold text-secondary text-uppercase">Select Restaurant</label>
                            <select class="form-select bg-light border-0 py-3 rounded-3" id="menuRestaurantId" required>
                                <option value="" selected disabled>Loading restaurants...</option>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-bold text-secondary text-uppercase">Item Name</label>
                            <input type="text" class="form-control bg-light border-0 py-3 rounded-3" id="menuItemName" placeholder="e.g. Garlic Naan" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-bold text-secondary text-uppercase">Price (INR)</label>
                            <input type="number" step="0.01" class="form-control bg-light border-0 py-3 rounded-3" id="menuItemPrice" placeholder="0.00" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-bold text-secondary text-uppercase">Description</label>
                            <textarea class="form-control bg-light border-0 py-3 px-4 rounded-3" id="menuItemDesc" rows="3" placeholder="Brief details about the dish..."></textarea>
                        </div>

                        <div id="menu-error-msg" class="alert alert-danger d-none rounded-3 small"></div>

                        <div class="d-grid gap-2 pt-3">
                            <button type="submit" id="saveMenuBtn" class="btn btn-primary py-3 fw-bold rounded-pill shadow">
                                <i class="fa-solid fa-plus-circle me-2"></i>Add to Menu
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        const token = localStorage.getItem('token');
        const contextPath = '${pageContext.request.contextPath}';

        const urlParams = new URLSearchParams(window.location.search);
        const editId = urlParams.get('id');

        // 1. Load Restaurants into dropdown
        function loadRestaurants() {
            return $.ajax({
                url: contextPath + '/api/restaurants/all?size=100',
                type: 'GET',
                headers: {'Authorization': 'Bearer ' + token},
                success: function(response) {
                    const select = $('#menuRestaurantId').empty();
                    select.append('<option value="" selected disabled>Choose a restaurant</option>');

                    const list = response.content || response;
                    list.forEach(res => {
                        // Use standard concatenation to avoid JSP EL interference
                        select.append('<option value="' + res.id + '">' + res.name + '</option>');
                    });
                }
            });
        }
        // 2. If editId exists, fetch item data
        function loadMenuItemDetails(id) {
            $.ajax({
                url: contextPath + '/api/restaurants/menu/' + id,
                type: 'GET',
                headers: {'Authorization': 'Bearer ' + token},
                success: function(item) {
                    // Change UI for Edit mode
                    $('.card-header h3').text('Edit Menu Item');
                    $('#saveMenuBtn').html('<i class="fa-solid fa-save me-2"></i> Update Item');

                    // Populate form fields
                    $('#menuItemName').val(item.name);
                    $('#menuItemPrice').val(item.price);
                    $('#menuItemDesc').val(item.description);

                    // Select the restaurant branch
                    if (item.restaurant && item.restaurant.id) {
                        // This triggers the dropdown to select the correct restaurant name
                        $('#menuRestaurantId').val(item.restaurant.id);
                    }
                },
                error: function(xhr) {
                    Swal.fire('Error', 'Could not load menu item details', 'error');
                }
            });
        }
        // Initialization: Load dropdown, THEN load data if editing
        loadRestaurants().done(function() {
            if (editId) {
                loadMenuItemDetails(editId);
            }
        });

        // 3. Handle Save (POST for add, PUT for edit)
        $('#admin-add-menu-form').on('submit', function (e) {
            e.preventDefault();

            const payload = {
                name: $('#menuItemName').val().trim(),
                description: $('#menuItemDesc').val().trim(),
                price: $('#menuItemPrice').val(),
                restaurantId: $('#menuRestaurantId').val()
            };

            // FIX: Use backticks and escape the dollar sign for editId
            const ajaxUrl = editId
                ? `\${contextPath}/api/restaurants/menu/\${editId}`
                : `\${contextPath}/api/restaurants/add/menu`;

            const ajaxMethod = editId ? 'PUT' : 'POST';

            const btn = $('#saveMenuBtn');
            btn.prop('disabled', true).html('<i class="fa-solid fa-spinner fa-spin me-2"></i> Processing...');

            $.ajax({
                url: ajaxUrl,
                type: ajaxMethod,
                headers: {'Authorization': 'Bearer ' + token},
                contentType: 'application/json',
                data: JSON.stringify(payload),
                success: function () {
                    Swal.fire({
                        title: 'Success!',
                        text: editId ? 'Item updated successfully.' : 'New item added to menu.',
                        icon: 'success',
                        timer: 1500,
                        showConfirmButton: false
                    }).then(() => {
                        window.location.href = contextPath + '/admin/manage-menu';
                    });
                },
                error: function (xhr) {
                    btn.prop('disabled', false).html(editId ? '<i class="fa-solid fa-save me-2"></i> Update Item' : '<i class="fa-solid fa-plus-circle me-2"></i> Add to Menu');
                    $('#menu-error-msg').removeClass('d-none').text(xhr.responseText || "An error occurred.");
                }
            });
        });
    });
</script>