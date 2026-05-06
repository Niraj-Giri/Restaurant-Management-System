<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Select Branch | Partner Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body { background-color: #f8fafc; font-family: 'Inter', sans-serif; }

        /* Minimalist Header */
        .selection-header {
            background: white;
            padding: 1rem 2rem;
            border-bottom: 1px solid #e2e8f0;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
        }

        .selection-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding-top: 60px;
        }

        .selection-card {
            background: #fff;
            padding: 3rem;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.05);
            max-width: 450px;
            width: 100%;
            text-align: center;
        }

        .res-dropdown {
            border-radius: 12px;
            padding: 12px 15px;
            border: 2px solid #e2e8f0;
            font-weight: 600;
            color: #1e293b;
        }

        .btn-manage {
            padding: 12px;
            font-weight: 700;
            border-radius: 12px;
            margin-top: 1.5rem;
        }

        .logout-link {
            color: #ef4444;
            text-decoration: none;
            font-weight: 600;
            cursor: pointer;
        }
    </style>
</head>
<body>

<nav class="selection-header d-flex justify-content-between align-items-center shadow-sm">
    <div class="fw-bold text-primary fs-5">
        <i class="fa-solid fa-utensils me-2"></i>Partner Panel
    </div>
    <div>
        <span onclick="handleLogout()" class="logout-link">
            <i class="fa-solid fa-right-from-bracket me-1"></i> Logout
        </span>
    </div>
</nav>

<div class="selection-wrapper">
    <div class="selection-card">
        <div class="mb-4">
            <div class="bg-primary bg-opacity-10 p-3 rounded-circle d-inline-block mb-3">
                <i class="fa-solid fa-shop text-primary fs-2"></i>
            </div>
            <h2 class="fw-bold text-dark">Switch Branch</h2>
            <p class="text-muted">Choose the restaurant you want to manage.</p>
        </div>

        <div id="loader-spinner" class="py-4">
            <div class="spinner-border text-primary" role="status"></div>
            <p class="small text-muted mt-2">Fetching your restaurants...</p>
        </div>

        <div id="selection-form" style="display: none;">
            <select id="restaurant-select" class="form-select res-dropdown mb-3">
            </select>

            <button class="btn btn-primary w-100 btn-manage shadow-sm" onclick="handleSelection()">
                Enter Dashboard <i class="fa-solid fa-arrow-right ms-2"></i>
            </button>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        const token = localStorage.getItem('token');
        if (!token) {
            window.location.href = '${pageContext.request.contextPath}/owner/login';
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/api/restaurants/my-all-restaurants',
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(data) {
                $('#loader-spinner').hide();

                // 1. BREAK THE LOOP: If 0 restaurants, go to the dedicated ADD page
                // Do NOT go to /owner/home, because the sidebar will just send you back here.
                if (!data || data.length === 0) {
                    window.location.href = '${pageContext.request.contextPath}/owner/add-restaurant';
                    return;
                }

                // 2. UX Improvement: If only one, just log them in automatically
                if (data.length === 1) {
                    enterDashboard(data[0].id, data[0].name);
                    return;
                }

                // 3. Regular Selection Logic
                const select = $('#restaurant-select');
                data.forEach(res => {
                    select.append(`<option value="\${res.id}">\${res.name}</option>`);
                });

                $('#selection-form').fadeIn();
            },
            error: function(xhr) {
                if (xhr.status === 401 || xhr.status === 403) {
                    handleLogout();
                }
            }
        });
    });

    function handleSelection() {
        const select = $('#restaurant-select');
        const id = select.val();
        const name = select.find("option:selected").text();

        if (id) {
            enterDashboard(id, name);
        }
    }

    function enterDashboard(id, name) {
        localStorage.setItem('activeRestaurantId', id);
        localStorage.setItem('activeRestaurantName', name);
        window.location.href = '${pageContext.request.contextPath}/owner/home';
    }

    function handleLogout() {
        localStorage.clear();
        window.location.href = '${pageContext.request.contextPath}/owner/login';
    }
</script>

</body>
</html>