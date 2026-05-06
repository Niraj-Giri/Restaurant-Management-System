<li class="nav-item">
    <a class="nav-link nav-link-owner" href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#addRestaurantModal">
        <i class="fa-solid fa-store me-2"></i> Add Restaurant
    </a>
</li>

<div class="modal fade" id="addRestaurantModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header border-0 pb-0">
                <h5 class="fw-bold text-dark mt-2 ps-2">Dashboard Add Restaurant</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <form id="add-restaurant-form">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Restaurant Name</label>
                        <input type="text" class="form-control bg-light border-0 py-2 rounded-3"
                               id="newResName" placeholder="Enter name..." required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Description</label>
                        <textarea class="form-control bg-light border-0 py-2 rounded-3"
                                  id="newResDesc" rows="3" placeholder="Description..." required></textarea>
                    </div>

                    <div id="add-res-error" class="alert alert-danger d-none small text-center"></div>

                    <div class="d-grid gap-2 mt-4">
                        <button type="submit" class="btn btn-primary py-2 fw-bold rounded-pill" id="saveResBtn">
                            Save Restaurant
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        $('#add-restaurant-form').on('submit', function (e) {
            e.preventDefault();

            const btn = $('#saveResBtn');
            const errorBox = $('#add-res-error');
            const token = localStorage.getItem('token');

            errorBox.addClass('d-none');
            btn.prop('disabled', true).html('<i class="fa-solid fa-spinner fa-spin me-2"></i>Saving...');

            // Payload keys match RestaurantRegistrationRequest.java
            const payload = {
                name: $('#newResName').val().trim(),
                description: $('#newResDesc').val().trim()
            };

            $.ajax({
                url: '/api/restaurants/add',
                type: 'POST',
                headers: { 'Authorization': 'Bearer ' + token },
                contentType: 'application/json',
                data: JSON.stringify(payload),
                success: function (response) {
                    $('#addRestaurantModal').modal('hide');
                    $('#add-restaurant-form')[0].reset();
                    alert('Restaurant added successfully!');

                    // Refresh Sidebar info if function exists
                    if (typeof fetchOwnerDetails === "function") {
                        fetchOwnerDetails();
                    }
                },
                error: function (xhr) {
                    let msg = "Error saving restaurant.";
                    if(xhr.status === 403) msg = "Access Denied: You don't have permission.";
                    errorBox.removeClass('d-none').text(msg);
                },
                complete: function () {
                    btn.prop('disabled', false).text('Save Restaurant');
                }
            });
        });
    });
</script>