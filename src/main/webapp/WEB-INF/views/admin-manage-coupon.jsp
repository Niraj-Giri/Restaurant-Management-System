<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4 bg-white p-4 rounded-4 shadow-sm">
        <div>
            <h2 class="fw-bold text-dark mb-1">Coupon Inventory</h2>
            <p class="text-muted mb-0">View and manage discount codes for the system.</p>
        </div>
        <a href="/admin/add-coupon" class="btn btn-primary rounded-pill px-4 fw-bold">
            <i class="fa-solid fa-plus-circle me-2"></i>Create New Coupon
        </a>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <table class="table table-hover align-middle mb-0">
            <thead class="bg-light text-secondary small fw-bold text-uppercase">
            <tr>
                <th class="py-3 px-4">Coupon Code</th>
                <th class="py-3">Discount</th>
                <th class="py-3">Min. Order</th>
                <th class="py-3 text-end px-4">Actions</th>
            </tr>
            </thead>
            <tbody id="coupon-table-body"></tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    $(document).ready(function() {
        const token = localStorage.getItem('token');
        const contextPath = '${pageContext.request.contextPath}';

        function loadCoupons() {
            $.ajax({
                url: contextPath + '/admin/coupons/all',
                type: 'GET',
                headers: {'Authorization': 'Bearer ' + token},
                success: function(coupons) {
                    const tbody = $('#coupon-table-body').empty();
                    coupons.forEach(c => {
                        const displayValue = c.couponType === 'PERCENTAGE' ? c.couponValue + '%' : '₹' + c.couponValue;
                        tbody.append(`
                            <tr>
                                <td class="px-4">
                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 rounded-3 fw-bold">
                                        \${c.couponCode}
                                    </span>
                                </td>
                                <td class="fw-bold text-dark">\${displayValue}</td>
                                <td class="text-muted">₹\${c.minimumOrderAmount}</td>
                                <td class="text-end px-4">
                                    <a href="/admin/add-coupon?id=\${c.id}" class="btn btn-sm btn-outline-primary rounded-pill px-3 me-1">
                                        <i class="fa-solid fa-pen"></i>
                                    </a>
                                    <button class="btn btn-sm btn-outline-danger rounded-pill px-3" onclick="deleteCoupon(\${c.id})">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        `);
                    });
                }
            });
        }
        loadCoupons();
    });

    function deleteCoupon(id) {
        Swal.fire({
            title: 'Delete Coupon?',
            text: "Customers will no longer be able to use this code.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, delete it',
            customClass: { popup: 'rounded-4' }
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/coupons/' + id,
                    type: 'DELETE',
                    headers: {'Authorization': 'Bearer ' + localStorage.getItem('token')},
                    success: function() {
                        Swal.fire('Deleted!', 'Coupon removed.', 'success').then(() => location.reload());
                    }
                });
            }
        });
    }
</script>