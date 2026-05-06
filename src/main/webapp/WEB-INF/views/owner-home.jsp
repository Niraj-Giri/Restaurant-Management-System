<div class="row mb-5 mt-4">
    <div class="col-12 text-center bg-white p-5 rounded-4 shadow-sm border border-light">
        <h1 class="fw-bold text-dark display-5 mb-2">Your Menu</h1>
    </div>
</div>

<div id="owner-meals-grid" class="row g-4"></div>

<div class="row" id="loading-spinner">
    <div class="col-12 text-center py-5">
        <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;"></div>
        <p class="mt-3 text-muted">Loading your menu items...</p>
    </div>
</div>

<div id="load-more-container" class="text-center mt-5 mb-5" style="display: none;">
    <button id="load-more-btn" class="btn btn-outline-primary rounded-pill px-5 py-2 fw-bold shadow-sm" onclick="fetchOwnerMeals()">
        <i class="fa-solid fa-utensils me-2"></i> Show More Items
    </button>
</div>

<style>
    .meal-card-owner {
        transition: all 0.3s ease;
        border-radius: 20px;
        border: none;
    }
    .meal-card-owner:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 30px rgba(0,0,0,0.08) !important;
    }
    .price-tag {
        background: #f1f5f9;
        color: #0d6efd;
        padding: 4px 12px;
        border-radius: 50px;
        font-weight: 700;
        font-size: 0.9rem;
    }
</style>
<script>
    let currentPage = 0;
    const pageSize = 6;
    let isLastPage = false;
    // Get the ID from localStorage instead of waiting for an AJAX call
    let restaurantId = localStorage.getItem('activeRestaurantId');

    $(document).ready(function() {
        const token = localStorage.getItem('token');

        // Validation Guard
        if (!restaurantId || restaurantId === "null") {
            window.location.href = '${pageContext.request.contextPath}/owner/select-restaurant';
            return;
        }

        fetchOwnerMeals(); // Load initial batch of meals directly
    });

    function fetchOwnerMeals() {
        const grid = $('#owner-meals-grid');
        const spinner = $('#loading-spinner');
        const loadMoreBtn = $('#load-more-btn');
        const loadMoreContainer = $('#load-more-container');
        const token = localStorage.getItem('token');

        spinner.show();
        loadMoreBtn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-2"></span> Fetching...');

        $.ajax({
            url: "${pageContext.request.contextPath}/api/restaurants/" + restaurantId + "/meals?page=" + currentPage + "&size=" + pageSize,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token }, // Ensure token is sent here too
            success: function(response) {
                spinner.hide();

                const meals = response.content || [];
                isLastPage = response.last;

                if (meals.length === 0 && currentPage === 0) {
                    grid.html('<div class="col-12 text-center py-5"><p class="text-muted fs-5">No meals have been added to your menu yet.</p></div>');
                    loadMoreContainer.hide();
                    return;
                }

                meals.forEach(meal => {
                    grid.append(`
                        <div class="col-md-6 col-lg-4">
                            <div class="card h-100 shadow-sm meal-card-owner">
                                <img src="\${meal.imageUrl || 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=500&q=60'}"
                                     class="card-img-top" alt="\${meal.name}" style="height: 200px; object-fit: cover; border-radius: 20px 20px 0 0;">
                                <div class="card-body p-4">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <h5 class="fw-bold text-dark mb-0">\${meal.name}</h5>
                                        <span class="price-tag">Rs \${meal.price.toFixed(2)}</span>
                                    </div>
                                    <p class="text-muted small mb-0">\${meal.description || 'A delicious dish prepared fresh in our kitchen.'}</p>
                                </div>
                                <div class="card-footer bg-white border-0 pb-4 px-4">
                                     <hr class="mt-0 mb-3 opacity-50">
                                     <div class="d-flex justify-content-between align-items-center">
                                         <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3 py-2">Active on Menu</span>
                                         <small class="text-muted">ID: #\${meal.id}</small>
                                     </div>
                                </div>
                            </div>
                        </div>
                    `);
                });

                if (isLastPage) {
                    loadMoreContainer.hide();
                } else {
                    currentPage++;
                    loadMoreContainer.show();
                    loadMoreBtn.prop('disabled', false).html('<i class="fa-solid fa-utensils me-2"></i> Show More Items');
                }
            },
            error: function(xhr) {
                spinner.hide();
                if(xhr.status === 401 || xhr.status === 403) {
                    window.location.href = '${pageContext.request.contextPath}/owner/login';
                } else {
                    grid.html('<div class="col-12 text-center py-5"><h3 class="text-danger">Error loading menu items.</h3></div>');
                }
            }
        });
    }
</script>