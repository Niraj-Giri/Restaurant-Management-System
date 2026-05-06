<form id="ownerRegisterForm" class="w-100 mt-3">

    <!-- OWNER DETAILS -->
    <h6 class="fw-bold mb-3">Owner Details</h6>

    <div class="row g-3 mb-3">
        <div class="col-6">
            <div class="form-floating">
                <input type="text" class="form-control bg-light rounded-4"
                       id="firstName" required>
                <label>First Name</label>
            </div>
        </div>
        <div class="col-6">
            <div class="form-floating">
                <input type="text" class="form-control bg-light rounded-4"
                       id="lastName" required>
                <label>Last Name</label>
            </div>
        </div>
    </div>

    <div class="mb-3">
        <label class="form-label small fw-bold ms-2">Mobile</label>
        <div class="input-group">
            <span class="input-group-text">+91</span>
            <input type="tel" class="form-control bg-light"
                   id="mobile" pattern="[0-9]{10}" required>
        </div>
    </div>

    <div class="form-floating mb-3">
        <input type="email" class="form-control bg-light rounded-4"
               id="email" required>
        <label>Email</label>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-6">
            <div class="form-floating">
                <input type="password" class="form-control bg-light"
                       id="password" required minlength="6">
                <label>Password</label>
            </div>
        </div>
        <div class="col-6">
            <div class="form-floating">
                <input type="password" class="form-control bg-light"
                       id="confirmPassword" required>
                <label>Confirm</label>
            </div>
        </div>
    </div>

    <!-- RESTAURANT DETAILS -->
    <h6 class="fw-bold mb-3">Restaurant Details</h6>

    <div class="form-floating mb-3">
        <input type="text" class="form-control bg-light rounded-4"
               id="restaurantName" required>
        <label>Restaurant Name</label>
    </div>

    <div class="form-floating mb-4">
    <textarea class="form-control bg-light rounded-4"
              id="restaurantDescription" style="height:120px" required></textarea>
        <label>Description</label>
    </div>

    <div id="errorMsg" class="alert alert-danger d-none text-center"></div>

    <button type="submit" class="btn btn-primary w-100 py-3 rounded-pill fw-bold">
        Register Restaurant
    </button>
</form>
<script>
    $('#ownerRegisterForm').submit(function(e) {
        e.preventDefault();

        if ($('#password').val() !== $('#confirmPassword').val()) {
            $('#errorMsg').removeClass('d-none').text("Passwords do not match");
            return;
        }

        const payload = {
            firstName: $('#firstName').val().trim(),
            lastName: $('#lastName').val().trim(),
            email: $('#email').val().trim(),
            mobileNumber: '+91' + $('#mobile').val().trim(),
            password: $('#password').val(),

            restaurantName: $('#restaurantName').val().trim(),
            restaurantDescription: $('#restaurantDescription').val().trim()
        };

        $.ajax({
            url: '/api/restaurants/register-owner',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(payload),
            success: function() {
                alert("Restaurant registered successfully!");
                window.location.href = '/owner/login';
            },
            error: function(xhr) {
                $('#errorMsg').removeClass('d-none')
                    .text(xhr.responseText || 'Registration failed');
            }
        });
    });
</script>