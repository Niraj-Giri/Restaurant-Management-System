<style>
    .login-wrapper {
        min-height: 85vh;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 100%;
    }

    .login-card {
        max-width: 450px;
        width: 100%;
        background: white;
        border-radius: 24px;
        box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        padding: 3rem;
    }

    /* Updated: Text instead of icon */
    .brand-text {
        font-weight: 800;
        font-size: 1.8rem;
        color: #0d6efd;
        letter-spacing: -1px;
        margin-bottom: 1.5rem;
        display: block;
    }
</style>

<div class="login-wrapper">
    <div class="login-card text-center">

        <span class="brand-text">Dashboard</span>

        <ul class="nav nav-pills justify-content-center mb-4">
            <li class="nav-item">
                <button class="nav-link active fw-bold" data-bs-toggle="pill" data-bs-target="#loginTab">Login</button>
            </li>
            <li class="nav-item">
                <button class="nav-link fw-bold" data-bs-toggle="pill" data-bs-target="#registerTab">Register</button>
            </li>
        </ul>

        <div class="tab-content">
            <div class="tab-pane fade show active" id="loginTab">
                <form id="owner-login-form">
                    <div class="form-floating mb-3">
                        <input type="email" class="form-control bg-light rounded-4" id="loginEmail" placeholder="name@example.com" required>
                        <label>Email</label>
                    </div>
                    <div class="form-floating mb-4">
                        <input type="password" class="form-control bg-light rounded-4" id="loginPassword" placeholder="Password" required>
                        <label>Password</label>
                    </div>
                    <div id="login-error-msg" class="alert alert-danger d-none small"></div>
                    <button id="login-btn" class="btn btn-primary w-100 py-3 rounded-pill fw-bold">Login to Dashboard</button>
                </form>
            </div>

            <div class="tab-pane fade" id="registerTab">
                <form id="ownerRegisterForm" class="mt-3">
                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <input class="form-control bg-light rounded-4" id="regFirstName" placeholder="First Name" required>
                        </div>
                        <div class="col-6">
                            <input class="form-control bg-light rounded-4" id="regLastName" placeholder="Last Name" required>
                        </div>
                    </div>
                    <div class="input-group mb-3">
                        <span class="input-group-text bg-light border-end-0 rounded-start-4">+91</span>
                        <input class="form-control bg-light rounded-end-4" id="regMobile" placeholder="Mobile Number" required>
                    </div>
                    <input type="email" class="form-control bg-light rounded-4 mb-3" id="regEmail" placeholder="Email Address" required>
                    <div class="row g-3 mb-4">
                        <div class="col-6">
                            <input type="password" class="form-control bg-light rounded-4" id="regPassword" placeholder="Password" required>
                        </div>
                        <div class="col-6">
                            <input type="password" class="form-control bg-light rounded-4" id="regConfirmPassword" placeholder="Confirm" required>
                        </div>
                    </div>
                    <div id="reg-error-msg" class="alert alert-danger d-none small"></div>
                    <button type="submit" class="btn btn-primary w-100 py-3 rounded-pill fw-bold">Create Account</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        // --- LOGIN LOGIC ---
        $('#owner-login-form').on('submit', function (e) {
            e.preventDefault();
            handleAuth('/api/auth/login', {
                email: $('#loginEmail').val().trim(),
                password: $('#loginPassword').val()
            }, '#login-btn', '#login-error-msg');
        });

        // --- REGISTER LOGIC (Redirects to Home on Success) ---
        $('#ownerRegisterForm').on('submit', function (e) {
            e.preventDefault();
            const errorBox = $('#reg-error-msg');
            errorBox.addClass('d-none');

            if ($('#regPassword').val() !== $('#regConfirmPassword').val()) {
                errorBox.removeClass('d-none').text('Passwords do not match');
                return;
            }

            const payload = {
                firstName: $('#regFirstName').val().trim(),
                lastName: $('#regLastName').val().trim(),
                email: $('#regEmail').val().trim(),
                mobileNumber: '+91' + $('#regMobile').val().trim(),
                password: $('#regPassword').val(),
                role: "RESTAURANT_OWNER"
            };

            const btn = $(this).find('button[type="submit"]');
            btn.prop('disabled', true).text('Creating Account...');

            $.ajax({
                url: '/api/auth/register',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(payload),
                success: function (response) {
                    // Assuming your registration API now returns the token
                    // or you perform an auto-login after registration
                    window.location.href = '/owner/login';

                },
                error: function (xhr) {
                    errorBox.removeClass('d-none').text(xhr.responseText || 'Registration failed');
                    btn.prop('disabled', false).text('Create Account');
                }
            });
        });

        function autoLogin(email, password) {
            $.ajax({
                url: '/api/auth/login',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({email, password}),
                success: function (response) {
                    localStorage.setItem('token', response.token);
                    localStorage.setItem('role', 'ROLE_RESTAURANT_OWNER');
                    window.location.href = '/owner/select-restaurant';
                }
            });
        }

        function handleAuth(url, data, btnId, errorId) {
            const btn = $(btnId);
            const errorBox = $(errorId);
            btn.prop('disabled', true).text('Please wait...');

            $.ajax({
                url: url,
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function (response) {
                    // 1. Extract roles from the JSON response you just shared
                    const roles = response.roles || [];

                    // 2. Clear old data and store the new token
                    localStorage.clear();
                    localStorage.setItem('token', response.token);

                    if (roles.includes('ROLE_RESTAURANT_OWNER')) {
                        localStorage.setItem('role', 'ROLE_RESTAURANT_OWNER');
                        window.location.href = '/owner/select-restaurant';
                    }
                    // 3. Now 'roles' is defined and will work for the staff check
                    else if (roles.includes('ROLE_RESTAURANT_STAFF')) {
                        localStorage.setItem('role', 'ROLE_RESTAURANT_STAFF');
                        window.location.href = '/staff/assigned-orders';
                    }
                    else if (roles.includes('ROLE_ADMIN')) {
                        localStorage.setItem('role', 'ROLE_ADMIN');
                        window.location.href = '/admin/manage-restaurant';
                    }
                    else {
                        localStorage.clear();
                        $('#login-error-msg').removeClass('d-none').text('Access denied: Unauthorized role.');
                        $('#login-btn').prop('disabled', false).text('Login');
                    }
                },
                error: function (xhr) {
                    errorBox.removeClass('d-none').text(xhr.responseJSON?.message || 'Invalid credentials.');
                    btn.prop('disabled', false).text('Login');
                }
            });
        }
    });
</script>