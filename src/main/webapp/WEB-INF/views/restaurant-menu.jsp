<div class="row mb-5 mt-4">
    <div class="col-12 text-center bg-white p-5 rounded-4 shadow-sm border border-light">
        <h1 id="restaurant-name" class="fw-bold text-dark display-5 mb-3">Loading Restaurant...</h1>
        <p id="restaurant-desc" class="text-muted lead w-75 mx-auto mb-0">
            Please wait while we fetch the details.
        </p>
    </div>
</div>

<div class="row mb-4">
    <div class="col-12 d-flex justify-content-end">
        <div class="d-flex align-items-center bg-white p-2 px-3 rounded-pill shadow-sm border">
            <label for="price-sort" class="me-2 fw-bold text-muted small text-uppercase"><i class="fa-solid fa-sort me-1"></i> Sort By:</label>
            <select id="price-sort" class="form-select form-select-sm border-0 fw-bold text-primary" style="width: auto; cursor: pointer;" onchange="resetAndFetchMeals()">
                <option value="">Default</option>
                <option value="price,asc">Price: Low to High</option>
                <option value="price,desc">Price: High to Low</option>
            </select>
        </div>
    </div>
</div>

<div id="meals-grid" class="row g-4"></div>

<div id="loading-spinner" class="col-12 text-center py-5">
    <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;"></div>
    <p class="mt-3 text-muted">Preparing delicious options...</p>
</div>

<div id="load-more-container" class="text-center mt-5 mb-5" style="display: none;">
    <button id="load-more-btn" class="btn btn-outline-primary rounded-pill px-5 py-2 fw-bold shadow-sm" onclick="fetchMeals()">
        <i class="fa-solid fa-utensils me-2"></i> Show More Meals
    </button>
</div>

<div class="modal fade" id="blockedUserModal" data-bs-backdrop="static" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-body text-center p-5">
                <div class="bg-danger bg-opacity-10 text-danger rounded-circle d-inline-flex align-items-center justify-content-center mb-4" style="width: 80px; height: 80px;">
                    <i class="fa-solid fa-user-slash display-4"></i>
                </div>
                <h3 class="fw-bold text-dark">Access Restricted</h3>
                <p class="text-muted" id="blocked-message">This restaurant has restricted your account.</p>
                <button type="button" class="btn btn-danger btn-lg w-100 rounded-pill fw-bold mt-3 shadow-sm" onclick="window.location.href='/home'">Back to Home</button>
            </div>
        </div>
    </div>
</div>

<script>
    var currentPage = 0;
    const pageSize = 6;
    var currentRestaurantId = null;
    var isLastPage = false;

    $(document).ready(function() {
        const urlParams = new URLSearchParams(window.location.search);
        currentRestaurantId = urlParams.get('id');

        if (!currentRestaurantId) {
            $('#restaurant-name').text("Error: No Restaurant ID");
            return;
        }

        fetchRestaurantDetails();
        fetchMeals();
    });

    function getAuthHeaders() {
        const token = localStorage.getItem('token');
        return (token && token !== "null") ? { 'Authorization': 'Bearer ' + token } : {};
    }

    function resetAndFetchMeals() {
        currentPage = 0;
        isLastPage = false;
        $('#meals-grid').empty();
        fetchMeals();
    }

    function fetchRestaurantDetails() {
        // FIXED: This should only call the basic restaurant info API
        $.ajax({
            url: "/api/restaurants/" + currentRestaurantId,
            type: 'GET',
            headers: getAuthHeaders(),
            success: function(r) {
                $('#restaurant-name').text(r.name || 'Unnamed Restaurant');
                $('#restaurant-desc').text(r.description || 'Welcome to our menu!');
            },
            error: function(xhr) {
                if (xhr.status === 403) {
                    new bootstrap.Modal(document.getElementById('blockedUserModal')).show();
                }
            }
        });
    }

    function fetchMeals() {
        const sortValue = $('#price-sort').val();
        const sortParam = sortValue ? "&sort=" + sortValue : "";

        $('#loading-spinner').show();
        $('#load-more-container').hide();

        // Standardizing URL construction
        const mealUrl = "/api/restaurants/" + currentRestaurantId + "/meals?page=" + currentPage + "&size=" + pageSize + sortParam;

        $.ajax({
            url: mealUrl,
            type: 'GET',
            headers: getAuthHeaders(),
            success: function(response) {
                $('#loading-spinner').hide();

                // Spring Data Page object returns content in .content
                const meals = response.content || [];
                isLastPage = response.last;

                if (meals.length === 0 && currentPage === 0) {
                    $('#meals-grid').html('<div class="col-12 text-center py-5"><h4>No menu items found.</h4></div>');
                    return;
                }

                meals.forEach(meal => {
                    $('#meals-grid').append(`
                        <div class="col-md-6 col-lg-4 mb-4">
                            <div class="card h-100 shadow-sm meal-tile border-0 overflow-hidden">
                                <div class="position-relative">
                                    <img src="\${meal.imageUrl || 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500'}"
                                         class="card-img-top" style="height: 220px; object-fit: cover;">
                                    <div class="position-absolute top-0 end-0 m-3">
                                        <span class="badge bg-white text-primary shadow-sm px-3 py-2 rounded-pill fw-bold">
                                            Rs \${meal.price.toFixed(2)}
                                        </span>
                                    </div>
                                </div>
                                <div class="card-body d-flex flex-column p-4">
                                    <h5 class="fw-bold text-dark mb-2">\${meal.name}</h5>
                                    <p class="text-muted small flex-grow-1">\${meal.description || 'Prepared fresh daily.'}</p>
                                    <button class="btn btn-primary w-100 mt-3 rounded-pill fw-bold shadow-sm"
                                            onclick="addToCart(\${meal.id}, '\${meal.name}', \${meal.price}, '\${currentRestaurantId}')">
                                        <i class="fa-solid fa-cart-plus me-2"></i> Add to Order
                                    </button>
                                </div>
                            </div>
                        </div>
                    `);
                });

                if (!isLastPage) {
                    currentPage++;
                    $('#load-more-container').show();
                    $('#load-more-btn').prop('disabled', false).html('<i class="fa-solid fa-utensils me-2"></i> Show More Meals');
                }
            },
            error: function(xhr) {
                $('#loading-spinner').hide();
                if (xhr.status === 403) {
                    new bootstrap.Modal(document.getElementById('blockedUserModal')).show();
                }
            }
        });
    }
</script>