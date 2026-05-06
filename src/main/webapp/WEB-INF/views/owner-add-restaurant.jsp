<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-7">


            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-5">
                    <div class="text-center mb-5">
                        <div class="bg-primary bg-opacity-10 p-3 rounded-circle d-inline-block mb-3">
                            <i class="fa-solid fa-store text-primary fs-3"></i>
                        </div>
                        <h2 class="fw-bold text-dark">Register New Branch</h2>
                        <p class="text-muted">Expand your business by adding a new location.</p>
                    </div>

                    <form id="add-restaurant-page-form">
                        <div class="mb-4">
                            <label class="form-label small fw-bold text-secondary">Restaurant Name</label>
                            <input type="text" class="form-control bg-light border-0 py-3 px-4 rounded-3"
                                   id="resName" placeholder="your restaurant name " required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-bold text-secondary">Description</label>
                            <textarea class="form-control bg-light border-0 py-3 px-4 rounded-3"
                                      id="resDesc" rows="4" placeholder="Describe the vibe, cuisine, or location..."></textarea>
                        </div>

                        <div id="page-res-error" class="alert alert-danger d-none rounded-3 small"></div>

                        <div class="d-grid gap-2 pt-3">
                            <button type="submit" id="saveResBtn" class="btn btn-primary py-3 fw-bold rounded-pill shadow-sm">
                                Create Restaurant
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

        // 1. Check for "Edit Mode" by looking for an 'id' in the URL
        const urlParams = new URLSearchParams(window.location.search);
        const editId = urlParams.get('id');

        if (editId) {
            // Populate the info for editing
            $.ajax({
                url: contextPath + '/api/restaurants/' + editId,
                type: 'GET',
                headers: {'Authorization': 'Bearer ' + token},
                success: function(res) {
                    // Update UI labels for Edit Mode
                    $('.fw-bold.text-dark').text('Update Branch Details');
                    $('.text-muted').first().text('Modify the information for your existing location.');
                    $('#saveResBtn').text('Save Changes');

                    // Populate inputs
                    $('#resName').val(res.name);
                    $('#resDesc').val(res.description);
                },
                error: function() {
                    Swal.fire('Error', 'Could not fetch restaurant details', 'error');
                }
            });
        }

        // 2. Handle Form Submission
        $('#add-restaurant-page-form').on('submit', function (e) {
            e.preventDefault();
            const btn = $('#saveResBtn');
            const errorBox = $('#page-res-error');

            errorBox.addClass('d-none');
            btn.prop('disabled', true).html('<i class="fa-solid fa-spinner fa-spin me-2"></i>Processing...');

            const payload = {
                name: $('#resName').val().trim(),
                description: $('#resDesc').val().trim()
            };

            // Switch URL and Method based on mode
            const ajaxUrl = editId
                ? contextPath + '/api/restaurants/restaurant/' + editId
                : contextPath + '/api/restaurants/add';

            const ajaxMethod = editId ? 'PUT' : 'POST';

            $.ajax({
                url: ajaxUrl,
                type: ajaxMethod,
                headers: {'Authorization': 'Bearer ' + token},
                contentType: 'application/json',
                data: JSON.stringify(payload),
                success: function (response) {
                    btn.removeClass('btn-primary').addClass('btn-success')
                        .html('<i class="fa-solid fa-circle-check me-2"></i>' + (editId ? 'Updated!' : 'Created!'));

                    setTimeout(function () {
                        // After editing/creating, go back to the management list
                        window.location.href = contextPath + '/owner/manage-restaurant';
                    }, 1500);
                },
                error: function (xhr) {
                    errorBox.removeClass('d-none').text(xhr.responseText || 'Error: Could not save restaurant.');
                    btn.prop('disabled', false).text(editId ? 'Save Changes' : 'Create Restaurant');
                }
            });
        });
    });
</script>