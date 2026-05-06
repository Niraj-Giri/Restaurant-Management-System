<form id="registerForm" class="w-100 mt-3">

  <div class="row g-3 mb-3">
    <div class="col-6">
      <div class="form-floating">
        <input type="text" class="form-control border-0 bg-light rounded-4" id="reg-firstName" placeholder="John" required>
        <label for="reg-firstName" class="text-muted fw-medium">First Name</label>
      </div>
    </div>
    <div class="col-6">
      <div class="form-floating">
        <input type="text" class="form-control border-0 bg-light rounded-4" id="reg-lastName" placeholder="Doe" required>
        <label for="reg-lastName" class="text-muted fw-medium">Last Name</label>
      </div>
    </div>
  </div>

  <div class="mb-3">
    <label class="form-label text-muted small fw-bold mb-1 ms-2">Mobile Number</label>
    <div class="input-group input-group-lg shadow-none">
      <span class="input-group-text border-0 bg-light fw-bold text-dark px-3 rounded-start-4">+91</span>
      <input type="tel" class="form-control border-0 bg-light rounded-end-4 fs-6" id="reg-mobile" placeholder="9876543210" required pattern="[0-9]{10}" maxlength="10">
    </div>
  </div>

  <div class="form-floating mb-3">
    <input type="email" class="form-control border-0 bg-light rounded-4" id="reg-email" placeholder="john@example.com" required>
    <label for="reg-email" class="text-muted fw-medium"><i class="fa-regular fa-envelope me-2"></i>Email Address</label>
  </div>

  <div class="row g-3 mb-4">
    <div class="col-6">
      <div class="form-floating">
        <input type="password" class="form-control border-0 bg-light rounded-4" id="reg-password" placeholder="Min. 6 chars" required minlength="6">
        <label for="reg-password" class="text-muted fw-medium">Password</label>
      </div>
    </div>
    <div class="col-6">
      <div class="form-floating">
        <input type="password" class="form-control border-0 bg-light rounded-4" id="reg-confirm-password" placeholder="Confirm" required minlength="6">
        <label for="reg-confirm-password" class="text-muted fw-medium">Confirm</label>
      </div>
    </div>
  </div>

  <div id="reg-error-msg" class="alert alert-danger d-none small py-2 rounded-3 text-center fw-bold" role="alert"></div>

  <button type="submit" id="reg-submit-btn" class="btn btn-primary w-100 fw-bold py-3 rounded-pill shadow-sm fs-6">
    <span id="reg-btn-text">Create Account</span>
    <span id="reg-btn-spinner" class="spinner-border spinner-border-sm d-none ms-2" role="status" aria-hidden="true"></span>
  </button>
</form>

<script>
  $(document).ready(function() {

    $('#registerForm').submit(function(e) {
      e.preventDefault();

      const firstName = $('#reg-firstName').val().trim();
      const lastName = $('#reg-lastName').val().trim();

      // Auto-append the +91 to the 10 digits the user typed
      const mobileNumber = '+91' + $('#reg-mobile').val().trim();

      const email = $('#reg-email').val().trim();
      const password = $('#reg-password').val();
      const confirmPassword = $('#reg-confirm-password').val();

      const errorBox = $('#reg-error-msg');
      const submitBtn = $('#reg-submit-btn');
      const btnText = $('#reg-btn-text');
      const btnSpinner = $('#reg-btn-spinner');

      if (password !== confirmPassword) {
        errorBox.removeClass('d-none').text("Passwords do not match. Please try again.");
        return;
      }

      errorBox.addClass('d-none');
      submitBtn.prop('disabled', true);
      btnText.text('Registering...');
      btnSpinner.removeClass('d-none');

      const userData = {
        firstName: firstName,
        lastName: lastName,
        mobileNumber: mobileNumber, // Sends the +91 version to backend
        email: email,
        password: password,
        role: "CUSTOMER"
      };

      $.ajax({
        url: '/api/auth/register',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(userData),
        success: function(response) {
          const modalEl = document.getElementById('authModal');
          if (modalEl) bootstrap.Modal.getInstance(modalEl).hide();

          $('#registerForm')[0].reset();
          submitBtn.prop('disabled', false);
          btnText.text('Create Account');
          btnSpinner.addClass('d-none');

          if (typeof showTab === "function") showTab('login');

          showSuccessToast("Account created successfully! You can now log in.");
        },
        error: function(xhr) {
          submitBtn.prop('disabled', false);
          btnText.text('Create Account');
          btnSpinner.addClass('d-none');

          let errorMessage = "Registration failed. Please try again.";
          if (xhr.responseText) errorMessage = xhr.responseText;
          errorBox.removeClass('d-none').text(errorMessage);
        }
      });
    });
  });
</script>