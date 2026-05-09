<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    .contact-card {
        background: white;
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.08);
        overflow: hidden;
        border: none;
    }
    .contact-info-section {
        background: #0d6efd;
        color: white;
        padding: 3rem;
        height: 100%;
    }
    .contact-form-section {
        padding: 3rem;
    }
    .info-item {
        display: flex;
        align-items: flex-start;
        margin-bottom: 2rem;
    }
    .info-icon {
        font-size: 1.5rem;
        margin-right: 1.5rem;
        color: #8bb4f7;
    }
    .form-control-custom {
        border-radius: 10px;
        padding: 0.75rem 1rem;
        border: 1px solid #dee2e6;
        background-color: #f8f9fa;
    }
    .form-control-custom:focus {
        border-color: #0d6efd;
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.15);
        background-color: #ffffff;
    }
    [data-bs-theme="dark"] .contact-card {
        background: #212529;
    }
    [data-bs-theme="dark"] .form-control-custom {
        background-color: #343a40;
        border-color: #495057;
        color: white;
    }
</style>

<div class="container my-5">
    <div class="text-center mb-5">
        <h1 class="display-5 fw-bold">Get in Touch</h1>
        <p class="text-muted fs-5">Have questions or feedback? We'd love to hear from you.</p>
    </div>

    <div class="row justify-content-center">
        <div class="col-xl-10">
            <div class="contact-card">
                <div class="row g-0">
                    <div class="col-lg-5">
                        <div class="contact-info-section">
                            <h3 class="fw-bold mb-4 text-white">Contact Information</h3>
                            <p class="mb-5 text-white-50">Fill out the form and our team will get back to you within 24 hours.</p>

                            <div class="info-item">
                                <i class="fa-solid fa-phone info-icon"></i>
                                <div>
                                    <h5 class="fw-bold text-white mb-1">Phone</h5>
                                    <p class="text-white-50 mb-0">+1 (555) 123-4567</p>
                                </div>
                            </div>
                            <div class="info-item">
                                <i class="fa-solid fa-envelope info-icon"></i>
                                <div>
                                    <h5 class="fw-bold text-white mb-1">Email</h5>
                                    <p class="text-white-50 mb-0">support@foodapp.com</p>
                                </div>
                            </div>
                            <div class="info-item">
                                <i class="fa-solid fa-location-dot info-icon"></i>
                                <div>
                                    <h5 class="fw-bold text-white mb-1">Office</h5>
                                    <p class="text-white-50 mb-0">123 Culinary Avenue<br>Food District, NY 10001</p>
                                </div>
                            </div>

                            <div class="mt-5 pt-4 border-top border-light border-opacity-25 d-flex gap-3">
                                <a href="#" class="btn btn-outline-light rounded-circle" style="width: 40px; height: 40px; padding: 0; line-height: 38px; text-align: center;"><i class="fa-brands fa-twitter"></i></a>
                                <a href="#" class="btn btn-outline-light rounded-circle" style="width: 40px; height: 40px; padding: 0; line-height: 38px; text-align: center;"><i class="fa-brands fa-facebook-f"></i></a>
                                <a href="#" class="btn btn-outline-light rounded-circle" style="width: 40px; height: 40px; padding: 0; line-height: 38px; text-align: center;"><i class="fa-brands fa-instagram"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-7">
                        <div class="contact-form-section">
                            <h3 class="fw-bold mb-4">Send us a Message</h3>
                            <form onsubmit="event.preventDefault(); showSuccessToast('Message sent successfully!'); this.reset();">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">First Name</label>
                                        <input type="text" class="form-control form-control-custom" required placeholder="John">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Last Name</label>
                                        <input type="text" class="form-control form-control-custom" required placeholder="Doe">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-bold">Email Address</label>
                                        <input type="email" class="form-control form-control-custom" required placeholder="john@example.com">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-bold">Subject</label>
                                        <input type="text" class="form-control form-control-custom" required placeholder="How can we help you?">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-bold">Message</label>
                                        <textarea class="form-control form-control-custom" rows="4" required placeholder="Write your message here..."></textarea>
                                    </div>
                                    <div class="col-12 mt-4">
                                        <button type="submit" class="btn btn-primary btn-lg rounded-pill px-5 fw-bold w-100">Send Message <i class="fa-solid fa-paper-plane ms-2"></i></button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
