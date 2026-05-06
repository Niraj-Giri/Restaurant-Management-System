<div class="row mb-4 mt-3">
    <div class="col-12 text-center">
        <h2 class="fw-bold text-dark">Available Restaurants</h2>
        <p class="text-muted">Explore the best flavors in your city</p>
        <hr class="mx-auto border-primary border-3 opacity-75" style="width: 60px;">
    </div>
</div>

<div id="restaurant-tile-grid" class="row g-4"></div>

<div class="row" id="loading-spinner">
    <div class="col-12 text-center py-5">
        <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;"></div>
    </div>
</div>

<div id="load-more-container" class="text-center mt-5 mb-5" style="display: none;">
    <button id="load-more-btn" class="btn btn-outline-primary rounded-pill px-5 py-2 fw-bold shadow-sm" onclick="fetchRestaurants()">
        <i class="fa-solid fa-utensils me-2"></i> See More Places
    </button>
</div>

<style>
    .restaurant-tile {
        transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
        border-radius: 20px;
        border: none;
    }
    .restaurant-tile:hover {
        transform: translateY(-8px);
        box-shadow: 0 20px 40px rgba(0,0,0,0.1) !important;
    }
    .card-img-top {
        border-radius: 20px 20px 0 0;
    }
    #load-more-btn:hover {
        background-color: #0d6efd;
        color: white;
        transform: scale(1.05);
        transition: 0.3s;
    }
</style>

<script>
    let currentPage = 0;
    const pageSize = 6;
    let isLastPage = false;

    $(document).ready(function() {
        // Load initial set
        fetchRestaurants();
    });

    function fetchRestaurants() {
        const grid = $('#restaurant-tile-grid');
        const spinner = $('#loading-spinner');
        const loadMoreBtn = $('#load-more-btn');
        const loadMoreContainer = $('#load-more-container');

        // 1. Get the token from local storage
        const token = localStorage.getItem('token');
        let requestHeaders = {};

        // 2. Only attach the header if the user is actually logged in
        if (token && token !== "null" && token !== "undefined") {
            requestHeaders['Authorization'] = 'Bearer ' + token;
        }

        // Show spinner and disable button while loading
        spinner.show();
        loadMoreBtn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-2"></span> Finding more...');

        $.ajax({
            url: "/api/restaurants/all?page=" + currentPage + "&size=" + pageSize,
            type: 'GET',
            headers: requestHeaders, // 3. Send the token to the backend
            success: function(response) {
                spinner.hide();

                // Get data from Spring Page object
                const restaurants = response.content || [];
                isLastPage = response.last; // Spring Data 'Page' provides a 'last' boolean

                if(restaurants.length === 0 && currentPage === 0) {
                    grid.html('<div class="col-12 text-center py-5"><p class="text-muted fs-5">No restaurants available right now.</p></div>');
                    loadMoreContainer.hide();
                    return;
                }

                // APPEND (don't clear) the items
                restaurants.forEach(res => {
                    grid.append(`
                    <div class="col-md-6 col-lg-4 mb-2">
                        <div class="card h-100 shadow-sm restaurant-tile" onclick="viewMenu(\${res.id})" style="cursor: pointer;">
                            <div class="position-relative">
                                <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=500&q=60"
                                     class="card-img-top" alt="Restaurant" style="height: 200px; object-fit: cover;">
                                <div class="position-absolute bottom-0 start-0 m-3">
                                    <span class="badge bg-white text-dark shadow-sm px-3 py-2 rounded-pill">
                                        <i class="fa-solid fa-star text-warning me-1"></i> 4.5
                                    </span>
                                </div>
                            </div>
                            <div class="card-body p-4">
                                <h5 class="fw-bold text-dark mb-1">\${res.name}</h5>
                                <p class="text-muted small mb-3">\${res.description || 'Premium dining experience'}</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="text-primary fw-bold small">View Menu <i class="fa-solid fa-arrow-right ms-1"></i></span>
                                    <span class="text-muted extra-small"><i class="fa-solid fa-clock me-1"></i> 20-30 min</span>
                                </div>
                            </div>
                        </div>
                    </div>
                `);
                });

                // Update Pagination Logic
                if (isLastPage) {
                    loadMoreContainer.hide();
                } else {
                    currentPage++; // Increment for next click
                    loadMoreContainer.show();
                    loadMoreBtn.prop('disabled', false).html('<i class="fa-solid fa-utensils me-2"></i> See More Places');
                }
            },
            error: function() {
                spinner.hide();
                alert("Could not load restaurants.");
            }
        });
    }

    function viewMenu(id) {
        window.location.href = '/menu?id=' + id;
    }
</script>