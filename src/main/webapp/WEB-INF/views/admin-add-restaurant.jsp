<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="card-header bg-primary py-4 text-center border-0">
                    <i class="fa-solid fa-store text-white fs-1 mb-2"></i>
                    <h3 class="fw-bold text-white mb-0" id="form-title">Assign Branch to Owner</h3>
                </div>

                <div class="card-body p-5">
                    <form id="admin-add-res-form">
                        <div class="mb-4">
                            <label class="form-label small fw-bold text-uppercase text-primary">Select Restaurant Owner</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-0"><i class="fa-solid fa-address-book"></i></span>
                                <select class="form-select bg-light border-0 py-3 rounded-end-3" id="ownerSelect" required>
                                    <option value="" selected disabled>Loading registered owners...</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-bold text-uppercase text-primary">Restaurant Name</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-0"><i class="fa-solid fa-shop"></i></span>
                                <input type="text" class="form-control bg-light border-0 py-3 rounded-end-3"
                                       id="resName" placeholder="e.g., Spice of India - Branch 1" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-bold text-uppercase text-primary">Description</label>
                            <textarea class="form-control bg-light border-0 py-3 px-4 rounded-3"
                                      id="resDesc" rows="3" placeholder="Brief description of the branch..."></textarea>
                        </div>

                        <div id="admin-res-error" class="alert alert-danger d-none rounded-3 small"></div>

                        <div class="d-grid gap-2 pt-3">
                            <button type="submit" id="saveResBtn" class="btn btn-primary py-3 fw-bold rounded-pill shadow">
                                Save Restaurant Details
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function() {
        const token = localStorage.getItem('token');
        const contextPath = '${pageContext.request.contextPath}';

        // Check if we are in EDIT mode via URL (?id=...)
        const urlParams = new URLSearchParams(window.location.search);
        const editId = urlParams.get('id');

        // 1. Fetch ALL registered owners to fill the dropdown
        function fetchRestaurantOwners() {
            return $.ajax({
                url: contextPath + '/admin/restaurant/owners',
                type: 'GET',
                headers: {'Authorization': 'Bearer ' + token},
                success: function(owners) {
                    const select = $('#ownerSelect').empty();
                    select.append('<option value="" selected disabled>Select an owner</option>');

                    owners.forEach(owner => {
                        const fullName = (owner.firstName + " " + (owner.lastName || "")).trim();
                        const displayName = `\${fullName} (\${owner.email})`;
                        // We use EMAIL as the value to match your backend DTO logic
                        select.append(`<option value="\${owner.email}">\${displayName}</option>`);
                    });
                },
                error: function() {
                    $('#admin-res-error').removeClass('d-none').text("Critical Error: Could not load owners list.");
                }
            });
        }

        // 2. Fetch specific Restaurant details (if editing)
        function loadRestaurantData(id) {
            $.ajax({
                url: contextPath + '/api/restaurants/' + id,
                type: 'GET',
                headers: {'Authorization': 'Bearer ' + token},
                success: function(res) {
                    // Update UI for Edit Mode
                    $('#form-title').text("Edit Restaurant: " + res.name);
                    $('#saveResBtn').text("Update Restaurant Details");

                    // Populate basic fields
                    $('#resName').val(res.name);
                    $('#resDesc').val(res.description);

                    // PRE-SELECT THE OWNER
                    // This works because fetchRestaurantOwners already ran and filled the <options>
                    if (res.owner && res.owner.email) {
                        $('#ownerSelect').val(res.owner.email);
                    }
                },
                error: function() {
                    $('#admin-res-error').removeClass('d-none').text("Error: Could not retrieve restaurant details.");
                }
            });
        }

        // --- EXECUTION FLOW ---
        // We use .done() to ensure owners are loaded BEFORE we try to select one
        fetchRestaurantOwners().done(function() {
            if (editId) {
                loadRestaurantData(editId);
            }
        });

        // 3. Unified Form Submission (POST for Add, PUT for Update)
        $('#admin-add-res-form').on('submit', function (e) {
            e.preventDefault();
            const btn = $('#saveResBtn');
            const errorBox = $('#admin-res-error');

            errorBox.addClass('d-none');
            btn.prop('disabled', true).html('<i class="fa-solid fa-spinner fa-spin me-2"></i>Processing...');

            const payload = {
                name: $('#resName').val().trim(),
                description: $('#resDesc').val().trim(),
                ownerEmail: $('#ownerSelect').val() // Sends the selected owner's email
            };

            const ajaxUrl = editId
                ? `\${contextPath}/api/restaurants/restaurant/\${editId}`
                : `\${contextPath}/api/restaurants/add`;

            const ajaxMethod = editId ? 'PUT' : 'POST';

            $.ajax({
                url: ajaxUrl,
                type: ajaxMethod,
                headers: {'Authorization': 'Bearer ' + token},
                contentType: 'application/json',
                data: JSON.stringify(payload),
                success: function () {
                    btn.removeClass('btn-primary').addClass('btn-success')
                        .html('<i class="fa-solid fa-check me-2"></i>Success!');

                    setTimeout(() => {
                        window.location.href = contextPath + '/admin/manage-restaurant';
                    }, 1200);
                },
                error: function (xhr) {
                    let msg = "Action failed.";
                    if(xhr.responseJSON && xhr.responseJSON.message) msg = xhr.responseJSON.message;
                    errorBox.removeClass('d-none').text(msg);
                    btn.prop('disabled', false).text('Save Restaurant Details');
                }
            });
        });
    });
</script>