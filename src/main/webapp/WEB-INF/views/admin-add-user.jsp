<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="card-header bg-primary py-4 text-center border-0">
                    <i class="fa-solid fa-user-plus text-white fs-1 mb-2"></i>
                    <h3 class="fw-bold text-white mb-0">System User Registration</h3>
                </div>

                <div class="card-body p-5">
                    <form id="admin-add-user-form">
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-secondary">First Name</label>
                                <input type="text" class="form-control bg-light border-0 py-3 rounded-3" id="firstName" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-secondary">Last Name</label>
                                <input type="text" class="form-control bg-light border-0 py-3 rounded-3" id="lastName" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-secondary">Email Address</label>
                            <input type="email" class="form-control bg-light border-0 py-3 rounded-3" id="email" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-secondary">Select User Role</label>
                            <select class="form-select bg-light border-0 py-3 rounded-3" id="userRole" required>
                                <option value="" selected disabled>Choose Role...</option>
                                <option value="RESTAURANT_OWNER">Restaurant Owner</option>
                                <option value="ADMIN">System Admin</option>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-bold text-secondary">Temporary Password</label>
                            <input type="password" class="form-control bg-light border-0 py-3 rounded-3" id="password" required>
                        </div>

                        <div id="user-error-msg" class="alert alert-danger d-none rounded-3 small text-center"></div>

                        <div class="d-grid pt-2">
                            <button type="submit" id="saveUserBtn" class="btn btn-primary py-3 fw-bold rounded-pill shadow">
                                Create Account
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

        if (editId) {
            $.ajax({
                url: contextPath + '/admin/user/' + editId,
                type: 'GET',
                headers: {'Authorization': 'Bearer ' + token},
                success: function(user) {
                    $('.card-header h3').text('Edit User Account');
                    $('#saveUserBtn').text('Update Account');
                    $('#firstName').val(user.firstName);
                    $('#lastName').val(user.lastName);

                    // --- CHANGED: Allow email editing ---
                    $('#email').val(user.email).prop('readonly', false);

                    $('#userRole').val(user.role);
                    $('#password').prop('required', false).attr('placeholder', 'Leave blank to keep current');
                }
            });
        }

        $('#admin-add-user-form').on('submit', function (e) {
            e.preventDefault();
            const btn = $('#saveUserBtn');
            const errorBox = $('#user-error-msg');

            errorBox.addClass('d-none');
            btn.prop('disabled', true).html('<i class="fa-solid fa-spinner fa-spin me-2"></i>Processing...');

            // Build payload including the potentially new email
            const payload = {
                firstName: $('#firstName').val().trim(),
                lastName: $('#lastName').val().trim(),
                email: $('#email').val().trim(),
                role: $('#userRole').val()
            };

            const pass = $('#password').val();
            if(pass) payload.password = pass;

            const ajaxUrl = editId ? `\${contextPath}/admin/user/\${editId}` : `\${contextPath}/api/auth/register`;
            const ajaxMethod = editId ? 'PUT' : 'POST';

            $.ajax({
                url: ajaxUrl,
                type: ajaxMethod,
                headers: {'Authorization': 'Bearer ' + token},
                contentType: 'application/json',
                data: JSON.stringify(payload),
                success: function () {
                    Swal.fire({
                        title: 'Success',
                        text: editId ? 'User updated successfully!' : 'User created!',
                        icon: 'success',
                        confirmButtonColor: '#0d6efd'
                    }).then(() => {
                        window.location.href = contextPath + '/admin/manage-user';
                    });
                },
                error: function (xhr) {
                    let msg = "Operation failed.";
                    if(xhr.responseJSON && xhr.responseJSON.message) msg = xhr.responseJSON.message;
                    errorBox.removeClass('d-none').text(msg);
                    btn.prop('disabled', false).text(editId ? 'Update Account' : 'Create Account');
                }
            });
        });
    });
</script>