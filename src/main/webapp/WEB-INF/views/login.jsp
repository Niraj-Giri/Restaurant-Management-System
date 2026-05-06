<form id="loginForm" class="w-100 mt-3">
  <div class="form-floating mb-3">
    <input type="email" class="form-control border-0 bg-light rounded-4" id="login-email" placeholder="name@example.com" required>
    <label for="login-email" class="text-muted fw-medium"><i class="fa-regular fa-envelope me-2"></i>Email Address</label>
  </div>

  <div class="form-floating mb-4">
    <input type="password" class="form-control border-0 bg-light rounded-4" id="login-password" placeholder="Password" required>
    <label for="login-password" class="text-muted fw-medium"><i class="fa-solid fa-lock me-2"></i>Password</label>
  </div>

  <div id="login-error-msg" class="alert alert-danger d-none small py-2 rounded-3 text-center fw-bold" role="alert"></div>

  <button type="submit" id="login-submit-btn" class="btn btn-primary w-100 fw-bold py-3 rounded-pill shadow-sm fs-6">
    <span id="login-btn-text">Login to Account</span>
    <span id="login-btn-spinner" class="spinner-border spinner-border-sm d-none ms-2" role="status" aria-hidden="true"></span>
  </button>
</form>

<script>
  $('#loginForm').submit(function(e) {
    e.preventDefault();

    const email = $('#login-email').val().trim();
    const password = $('#login-password').val();
    const errorBox = $('#login-error-msg');
    const submitBtn = $('#login-submit-btn');
    const btnText = $('#login-btn-text');
    const btnSpinner = $('#login-btn-spinner');

    errorBox.addClass('d-none');
    submitBtn.prop('disabled', true);
    btnText.text('Authenticating...');
    btnSpinner.removeClass('d-none');

    const credentials = { email: email, password: password };

    $.ajax({
      url: '/api/auth/login',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(credentials),
      success: function(response) {
        // Save auth data
        localStorage.setItem('token', response.token);
        localStorage.setItem('userRole', response.role);
        if (response.firstName) localStorage.setItem('userName', response.firstName);
        const guestId = localStorage.getItem('guestSessionId');
        if (typeof completeLoginFlow === "function") {
          completeLoginFlow();
        }
        // If guest items exist, merge them
        if (guestId) {
          $.ajax({
            url: '/api/cart/merge?guestId=' + guestId,
            type: 'POST',
            headers: { 'Authorization': 'Bearer ' + response.token },
            success: function() {
              localStorage.removeItem('guestSessionId');
              window.location.reload();
              completeLoginFlow();
            },
            error: function(xhr) {
              // Always clear guest ID to prevent infinite retry loops
              localStorage.removeItem('guestSessionId');

              if (xhr.status === 403) {
                // Pass the security error to the handler to show the modal
                completeLoginFlow(xhr);
              } else {
                // For general errors, just proceed to the normal flow
                completeLoginFlow();
              }
            }
          });
        } else {
          completeLoginFlow();
        }
      },
      error: function(xhr) {
        submitBtn.prop('disabled', false);
        btnText.text('Login to Account');
        btnSpinner.addClass('d-none');
        errorBox.removeClass('d-none').text("Invalid email or password.");
      }
    });

    /**
     * Standardizes the UI transition after login.
     * @param {Object} errorXhr - Optional XHR object if a security block occurred.
     */
    function completeLoginFlow(errorXhr) {
      // 1. Close the login modal
      const modalEl = document.getElementById('authModal');
      if (modalEl) {
        const modalInstance = bootstrap.Modal.getInstance(modalEl);
        if(modalInstance) modalInstance.hide();
      }

      // 2. Reset form and button states
      $('#loginForm')[0].reset();
      submitBtn.prop('disabled', false);
      btnText.text('Login to Account');
      btnSpinner.addClass('d-none');

      // 3. Handle 403 Forbidden (Blocked User)
      if (errorXhr && errorXhr.status === 403) {
        // Stop execution here and let the Cart Page's error handler
        // in fetchCart() catch the block and show the modal.
        if (typeof fetchCart === "function") fetchCart();
        return;
      }

      // 4. Normal Success Path
      if (typeof checkAuthState === "function") checkAuthState();
      if (typeof fetchCart === "function") fetchCart();
      if (typeof showSuccessToast === "function") showSuccessToast("Welcome back! Login successful.");
    }
  });
</script>