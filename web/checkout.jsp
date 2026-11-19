<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String productName = request.getParameter("product");
  if (productName == null) productName = "STRUCTURED DOUBLE-BREASTED WOOL BLAZER";
  String unitPrice = request.getParameter("price");
  if (unitPrice == null) unitPrice = "12990";
  String sessionName = (String) session.getAttribute("userName");
  String sessionEmail = (String) session.getAttribute("userEmail");
%>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA — Checkout</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/style.css" />
  </head>
  <body class="page-offset">
    <header class="vera-header">
      <a href="index.html" class="vera-brand">VÉRA</a>
      <nav class="vera-nav-links d-none d-md-flex">
        <a href="index.html" class="vera-nav-link">Home</a>
        <a href="products.jsp" class="vera-nav-link">Catalog</a>
        <a href="orders.jsp" class="vera-nav-link">Orders</a>
      </nav>
      <div class="vera-header-actions">
        <a href="login.jsp" class="vera-icon-btn">Account</a>
      </div>
    </header>

    <main class="container py-5" style="max-width: 720px;">
      <div class="border-bottom border-vera pb-3 mb-4">
        <h1 class="font-display ls-editorial fs-4 fw-normal mb-0">Place Order</h1>
      </div>

      <% if ("1".equals(request.getParameter("error"))) { %>
        <div class="alert alert-danger small mb-4">Unable to place order. Please try again.</div>
      <% } %>

      <div class="border border-vera p-4">
        <form action="PlaceOrderServlet" method="post">
          <div class="row g-3">
            <div class="col-md-8">
              <label class="form-label font-display ls-editorial small">Product</label>
              <input type="text" name="productName" class="form-control" value="<%= productName %>" readonly />
            </div>
            <div class="col-md-4">
              <label class="form-label font-display ls-editorial small">Unit Price (₹)</label>
              <input type="number" name="unitPrice" step="0.01" class="form-control font-mono-num" value="<%= unitPrice %>" readonly />
            </div>
            <div class="col-md-6">
              <label class="form-label font-display ls-editorial small">Size</label>
              <select name="size" class="form-select">
                <option value="XS">XS</option>
                <option value="S">S</option>
                <option value="M" selected>M</option>
                <option value="L">L</option>
                <option value="XL">XL</option>
              </select>
            </div>
            <div class="col-md-6">
              <label class="form-label font-display ls-editorial small">Quantity</label>
              <input type="number" name="quantity" min="1" value="1" class="form-control" required />
            </div>
            <div class="col-md-6">
              <label class="form-label font-display ls-editorial small">Customer Name</label>
              <input type="text" name="customerName" class="form-control" value="<%= sessionName != null ? sessionName : "" %>" required />
            </div>
            <div class="col-md-6">
              <label class="form-label font-display ls-editorial small">Email</label>
              <input type="email" name="customerEmail" class="form-control" value="<%= sessionEmail != null ? sessionEmail : "" %>" required />
            </div>
            <div class="col-12">
              <label class="form-label font-display ls-editorial small">Address</label>
              <input type="text" name="address" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label font-display ls-editorial small">City</label>
              <input type="text" name="city" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label font-display ls-editorial small">PIN Code</label>
              <input type="text" name="pinCode" maxlength="6" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label font-display ls-editorial small">Payment</label>
              <select name="paymentMethod" class="form-select">
                <option value="UPI">UPI</option>
                <option value="Card">Card</option>
                <option value="COD">COD</option>
              </select>
            </div>
          </div>
          <div class="mt-4 d-flex gap-3">
            <button type="submit" class="btn btn-vera-primary">Confirm Order</button>
            <a href="products.jsp" class="btn btn-vera-outline">Back</a>
          </div>
        </form>
      </div>
    </main>
  </body>
</html>
