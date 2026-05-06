<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-lg rounded-4">
                <div class="card-body p-5">
                    <div class="text-center mb-4">
                        <div class="bg-primary bg-opacity-10 p-3 rounded-circle d-inline-block mb-3">
                            <i class="fa-solid fa-user-plus text-primary fs-3"></i>
                        </div>
                        <h2 class="fw-bold" id="form-title">Register New Staff</h2>
                        <p class="text-muted" id="form-desc">Create a new account and assign it to this branch.</p>
                    </div>

                    <form id="full-staff-reg-form" autocomplete="off">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">First Name</label>
                                <input type="text" id="sFirstName" class="form-control bg-light border-0 py-2" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Last Name</label>
                                <input type="text" id="sLastName" class="form-control bg-light border-0 py-2" required>
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold">Email Address</label>
                                <input type="email" id="sEmail" class="form-control bg-light border-0 py-2"
                                       autocomplete="new-password" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Mobile Number</label>
                                <input type="text" id="sMobile" class="form-control bg-light border-0 py-2" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Password</label>
                                <input type="text" id="sPassword" class="form-control bg-light border-0 py-2"
                                       autocomplete="new-password" required>
                            </div>
                        </div>

                        <div id="reg-feedback" class="alert d-none mt-4 small text-center rounded-3"></div>

                        <div class="mt-5">
                            <button type="submit" id="regStaffBtn" class="btn btn-primary w-100 py-3 fw-bold rounded-pill">
                                Create Account & Link to Branch
                            </button>
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
        const resId = localStorage.getItem('activeRestaurantId');
        const urlParams = new URLSearchParams(window.location.search);
        const editStaffId = urlParams.get('id');

        // Logic Switch
        if (editStaffId) {
            // EDIT MODE
            $.ajax({
                url: `\${contextPath}/api/restaurants/staff-user/\${editStaffId}`,
                type: 'GET',
                headers: {'Authorization': 'Bearer ' + token},
                success: function(user) {
                    $('#form-title').text('Update Staff Details');
                    $('#form-desc').text('Modify account details for ' + user.firstName);
                    $('#regStaffBtn').text('Update Staff Member');

                    $('#sFirstName').val(user.firstName);
                    $('#sLastName').val(user.lastName);
                    $('#sEmail').val(user.email);
                    $('#sMobile').val(user.mobileNumber);

                    // Show password as plain text with default
                    $('#sPassword').val('pass123').prop('required', false);
                }
            });
        } else {
            // NEW STAFF MODE
            $('#sEmail').val(''); // Clear any browser autofill
            $('#sPassword').val('pass123'); // Default password for new members
        }

        $('#full-staff-reg-form').on('submit', function(e) {
            e.preventDefault();
            const btn = $('#regStaffBtn');
            const feedback = $('#reg-feedback');

            if (!resId) {
                Swal.fire('Warning', 'Select a branch from the dashboard first.', 'warning');
                return;
            }

            feedback.addClass('d-none');
            btn.prop('disabled', true).html('<i class="fa-solid fa-spinner fa-spin me-2"></i>Saving...');

            const payload = {
                firstName: $('#sFirstName').val().trim(),
                lastName: $('#sLastName').val().trim(),
                email: $('#sEmail').val().trim(),
                mobileNumber: $('#sMobile').val().trim(),
                password: $('#sPassword').val(),
                restaurantId: resId
            };

            const ajaxUrl = editStaffId
                ? `\${contextPath}/api/restaurants/staff-user/\${editStaffId}`
                : `\${contextPath}/api/restaurants/register-staff`;

            const ajaxMethod = editStaffId ? 'PUT' : 'POST';

            $.ajax({
                url: ajaxUrl,
                type: ajaxMethod,
                headers: {'Authorization': 'Bearer ' + token},
                contentType: 'application/json',
                data: JSON.stringify(payload),
                success: function(res) {
                    Swal.fire('Success', res.message || 'Action completed!', 'success').then(() => {
                        window.location.href = contextPath + '/owner/manage-staff';
                    });
                },
                error: function(xhr) {
                    feedback.removeClass('d-none alert-success').addClass('alert-danger')
                        .text(xhr.responseText || "Request failed.");
                    btn.prop('disabled', false).text('Try Again');
                }
            });
        });
    });
</script>