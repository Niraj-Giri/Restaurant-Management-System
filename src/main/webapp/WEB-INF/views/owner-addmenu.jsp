<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card border-0 shadow-lg rounded-4">
                <div class="card-body p-5">
                    <div class="mb-4">
                        <h3 class="fw-bold text-dark" id="page-title">
                            <i class="fa-solid fa-plus-circle text-primary me-2"></i>Add New Dish
                        </h3>
                        <p class="text-muted" id="page-desc">Fill in the details to add a new item to your menu.</p>
                    </div>

                    <form id="add-product-form">
                        <div class="row">
                            <div class="col-12 mb-3">
                                <label class="form-label fw-bold small text-muted">Select Restaurant Branch</label>
                                <select id="resSelector" class="form-select bg-light border-0 py-2 rounded-3 fw-bold" required>
                                    <option value="" disabled selected>-- Choose Branch --</option>
                                </select>
                            </div>

                            <div class="col-12 mb-3">
                                <label class="form-label fw-bold small text-muted">Dish Name</label>
                                <input type="text" id="prodName" class="form-control bg-light border-0 py-2 rounded-3"
                                       placeholder="e.g. Paneer Butter Masala" required>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-muted">Price (Rs)</label>
                                <input type="number" id="prodPrice" step="0.01" class="form-control bg-light border-0 py-2 rounded-3"
                                       placeholder="0.00" required>
                            </div>

                            <div class="col-12 mb-4">
                                <label class="form-label fw-bold small text-muted">Description</label>
                                <textarea id="prodDesc" class="form-control bg-light border-0 py-2 rounded-3"
                                          rows="4" placeholder="Describe the ingredients and taste..." required></textarea>
                            </div>
                        </div>

                        <div id="product-alert" class="alert d-none small text-center rounded-3"></div>

                        <div class="d-grid gap-2">
                            <button type="submit" id="saveProductBtn" class="btn btn-primary py-3 fw-bold rounded-pill">
                                <i class="fa-solid fa-cloud-arrow-up me-2"></i>Save to Menu
                            </button>
                            <a href="/owner/manage-menu" class="btn btn-light py-2 rounded-pill fw-bold text-muted">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    $(document).ready(function() {
        const token = localStorage.getItem('token');
        const contextPath = '${pageContext.request.contextPath}';

        // 1. Check for "Edit Mode"
        const urlParams = new URLSearchParams(window.location.search);
        const editId = urlParams.get('id');

        // 2. Load Owner's Specific Restaurants for the Dropdown
        function loadOwnerBranches(selectedResId) {
            $.ajax({
                url: contextPath + '/api/restaurants/my-all-restaurants',
                type: 'GET',
                headers: { 'Authorization': 'Bearer ' + token },
                success: function(list) {
                    const selector = $('#resSelector');
                    list.forEach(r => {
                        const isSelected = (selectedResId == r.id) ? 'selected' : '';
                        selector.append(`<option value="\${r.id}" \${isSelected}>\${r.name}</option>`);
                    });
                }
            });
        }

        // 3. If Edit Mode, Populate Data
        if (editId) {
            $('#page-title').html('<i class="fa-solid fa-pen-to-square text-primary me-2"></i>Edit Dish Details');
            $('#page-desc').text('Update the pricing or description for this menu item.');
            $('#saveProductBtn').html('<i class="fa-solid fa-check-circle me-2"></i>Update Product');

            $.ajax({
                url: contextPath + '/api/restaurants/menu/' + editId,
                type: 'GET',
                headers: { 'Authorization': 'Bearer ' + token },
                success: function(product) {
                    $('#prodName').val(product.name);
                    $('#prodPrice').val(product.price);
                    $('#prodDesc').val(product.description);
                    loadOwnerBranches(product.restaurant.id); // Load branches and select the current one
                }
            });
        } else {
            // New Dish Mode: Select the active branch from storage by default
            const activeResId = localStorage.getItem('activeRestaurantId');
            loadOwnerBranches(activeResId);
        }

        // 4. Handle Submit (POST for New, PUT for Edit)
        $('#add-product-form').on('submit', function(e) {
            e.preventDefault();
            const btn = $('#saveProductBtn');
            const alertBox = $('#product-alert');

            btn.prop('disabled', true).html('<i class="fa-solid fa-spinner fa-spin me-2"></i>Processing...');

            const payload = {
                name: $('#prodName').val().trim(),
                description: $('#prodDesc').val().trim(),
                price: parseFloat($('#prodPrice').val()),
                restaurantId: parseInt($('#resSelector').val())
            };

            const ajaxUrl = editId
                ? contextPath + '/api/restaurants/menu/' + editId
                : contextPath + '/api/restaurants/add/menu';
            const ajaxMethod = editId ? 'PUT' : 'POST';

            $.ajax({
                url: ajaxUrl,
                type: ajaxMethod,
                headers: { 'Authorization': 'Bearer ' + token },
                contentType: 'application/json',
                data: JSON.stringify(payload),
                success: function(res) {
                    Swal.fire({
                        title: 'Success!',
                        text: editId ? 'Product updated.' : 'Product added to menu.',
                        icon: 'success',
                        timer: 1500,
                        showConfirmButton: false
                    }).then(() => {
                        window.location.href = contextPath + '/owner/manage-menu';
                    });
                },
                error: function(xhr) {
                    btn.prop('disabled', false).html('<i class="fa-solid fa-cloud-arrow-up me-2"></i>Save to Menu');
                    alertBox.removeClass('d-none alert-success').addClass('alert-danger').text(xhr.responseText || "Error saving product.");
                }
            });
        });
    });
</script>