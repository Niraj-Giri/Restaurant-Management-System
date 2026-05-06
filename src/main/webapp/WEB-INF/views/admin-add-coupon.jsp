<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="card-header bg-primary py-4 text-center border-0">
                    <i class="fa-solid fa-ticket text-white fs-1 mb-2"></i>
                    <h3 class="fw-bold text-white mb-0">Create New Coupon</h3>
                </div>

                <div class="card-body p-5">
                    <form id="admin-add-coupon-form">
                        <div class="mb-4">
                            <label class="form-label small fw-bold text-uppercase text-primary">Coupon Code</label>
                            <input type="text" class="form-control bg-light border-0 py-3 rounded-3 fw-bold"
                                   id="couponCode" placeholder="e.g., WELCOME50" style="text-transform: uppercase" required>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-uppercase text-primary">Discount Type</label>
                                <select class="form-select bg-light border-0 py-3 rounded-3" id="couponType" required onchange="updateValuePrefix()">
                                    <option value="PERCENTAGE">Percentage (%)</option>
                                    <option value="FLAT">Flat Amount (₹)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-uppercase text-primary">Value</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-0" id="valuePrefix">%</span>
                                    <input type="number" step="0.01" class="form-control bg-light border-0 py-3 rounded-end-3" id="couponValue" required>
                                </div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-bold text-uppercase text-primary">Min. Order Amount (₹)</label>
                            <input type="number" step="0.01" class="form-control bg-light border-0 py-3 rounded-3" id="minAmount" placeholder="0.00" required>
                        </div>

                        <div id="coupon-alert" class="alert d-none rounded-3 small"></div>

                        <div class="d-grid gap-2 pt-3">
                            <button type="submit" id="saveCouponBtn" class="btn btn-primary py-3 fw-bold rounded-pill shadow">
                                <i class="fa-solid fa-plus-circle me-2"></i>Publish Coupon
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function updateValuePrefix() {
        const type = $('#couponType').val();
        $('#valuePrefix').text(type === 'PERCENTAGE' ? '%' : '₹');
    }

    $(document).ready(function() {
        const token = localStorage.getItem('token');
        const contextPath = '${pageContext.request.contextPath}';

        // Check for Edit Mode
        const urlParams = new URLSearchParams(window.location.search);
        const editId = urlParams.get('id');

        if (editId) {
            $.ajax({
                url: contextPath + '/admin/coupons/' + editId,
                type: 'GET',
                headers: {'Authorization': 'Bearer ' + token},
                success: function(coupon) {
                    $('.card-header h3').text('Edit Coupon');
                    $('#saveCouponBtn').html('<i class="fa-solid fa-save me-2"></i>Update Coupon');

                    $('#couponCode').val(coupon.couponCode);
                    $('#couponType').val(coupon.couponType);
                    $('#couponValue').val(coupon.couponValue);
                    $('#minAmount').val(coupon.minimumOrderAmount);

                    updateValuePrefix(); // Update the % or ₹ icon
                }
            });
        }

        $('#admin-add-coupon-form').on('submit', function(e) {
            e.preventDefault();
            const btn = $('#saveCouponBtn');
            const alertBox = $('#coupon-alert');

            alertBox.addClass('d-none');
            btn.prop('disabled', true).html('<i class="fa-solid fa-spinner fa-spin me-2"></i>Processing...');

            const payload = {
                couponCode: $('#couponCode').val().trim().toUpperCase(),
                couponType: $('#couponType').val(),
                couponValue: parseFloat($('#couponValue').val()),
                minimumOrderAmount: parseFloat($('#minAmount').val())
            };

            const ajaxUrl = editId ? `\${contextPath}/admin/coupons/\${editId}` : `\${contextPath}/admin/coupons/add`;
            const ajaxMethod = editId ? 'PUT' : 'POST';

            $.ajax({
                url: ajaxUrl,
                type: ajaxMethod,
                headers: {'Authorization': 'Bearer ' + token},
                contentType: 'application/json',
                data: JSON.stringify(payload),
                success: function(res) {
                    Swal.fire('Success', res.message, 'success').then(() => {
                        window.location.href = contextPath + '/admin/manage-coupon';
                    });
                },
                error: function(xhr) {
                    btn.prop('disabled', false).text(editId ? 'Update Coupon' : 'Publish Coupon');
                    alertBox.removeClass('d-none alert-success').addClass('alert-danger').text("Error processing coupon.");
                }
            });
        });
    });
</script>