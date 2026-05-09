<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    .about-hero {
        background: linear-gradient(135deg, #0d6efd 0%, #00d2ff 100%);
        color: white;
        padding: 4rem 2rem;
        border-radius: 20px;
        margin-bottom: 3rem;
        text-align: center;
        box-shadow: 0 10px 30px rgba(13, 110, 253, 0.2);
    }
    .feature-card {
        padding: 2rem;
        border-radius: 15px;
        background: white;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        transition: transform 0.3s ease;
        height: 100%;
        border: 1px solid #f1f5f9;
    }
    .feature-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0,0,0,0.1);
    }
    .feature-icon {
        font-size: 2.5rem;
        color: #0d6efd;
        margin-bottom: 1.5rem;
    }
    [data-bs-theme="dark"] .feature-card {
        background: #212529;
        border-color: #343a40;
    }
</style>

<div class="container my-5">
    <div class="about-hero">
        <h1 class="display-4 fw-bold mb-3"><i class="fa-solid fa-utensils me-3"></i>About FoodAPP</h1>
        <p class="lead mb-0">Connecting you with the best culinary experiences in town, delivered right to your door.</p>
    </div>

    <div class="row align-items-center mb-5">
        <div class="col-lg-6 mb-4 mb-lg-0">
            <h2 class="fw-bold mb-4">Our Story</h2>
            <p class="text-muted fs-5">Founded with a passion for great food and seamless technology, FoodAPP was created to bridge the gap between hungry customers and outstanding local restaurants.</p>
            <p class="text-muted fs-5">We believe that ordering food should be as delightful as eating it. That's why we've built a platform that focuses on speed, reliability, and an exceptional user experience.</p>
        </div>
        <div class="col-lg-6 text-center">
            <img src="https://images.unsplash.com/photo-1555939594-58d7cb561ad1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80" alt="Restaurant Food" class="img-fluid rounded-4 shadow-lg" style="max-height: 400px; object-fit: cover;">
        </div>
    </div>

    <div class="row g-4 mt-2">
        <div class="col-md-4">
            <div class="feature-card text-center">
                <i class="fa-solid fa-bolt feature-icon"></i>
                <h4 class="fw-bold">Lightning Fast</h4>
                <p class="text-muted mb-0">Our optimized delivery network ensures your food arrives hot and fresh, every single time.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="feature-card text-center">
                <i class="fa-solid fa-shield-halved feature-icon"></i>
                <h4 class="fw-bold">Secure Payments</h4>
                <p class="text-muted mb-0">Your transactions are protected with industry-leading encryption and security standards.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="feature-card text-center">
                <i class="fa-solid fa-award feature-icon"></i>
                <h4 class="fw-bold">Top Quality</h4>
                <p class="text-muted mb-0">We partner only with top-rated restaurants to guarantee a premium dining experience.</p>
            </div>
        </div>
    </div>
</div>
