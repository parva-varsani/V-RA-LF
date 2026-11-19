<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA — Add Product</title>
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
        <a href="add-product.jsp" class="vera-nav-link active">Add Product</a>
      </nav>
      <div class="vera-header-actions">
        <a href="login.jsp" class="vera-icon-btn">Account</a>
      </div>
    </header>

    <main class="container py-5" style="max-width: 720px;">
      <div class="border-bottom border-vera pb-3 mb-4">
        <h1 class="font-display ls-editorial fs-4 fw-normal mb-0">Add New Product</h1>
      </div>

      <% if ("1".equals(request.getParameter("error"))) { %>
        <div class="alert alert-danger small mb-4">Could not save product. Please check all fields.</div>
      <% } %>

      <div class="border border-vera p-4">
        <form action="AddProductServlet" method="post">
          <div class="row g-3">
            <div class="col-md-8">
              <label class="form-label font-display ls-editorial small">Product Name</label>
              <input type="text" name="name" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label font-display ls-editorial small">SKU</label>
              <input type="text" name="sku" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label font-display ls-editorial small">Category</label>
              <select name="category" class="form-select" required>
                <option value="WOMAN">WOMAN</option>
                <option value="MAN">MAN</option>
                <option value="KIDS">KIDS</option>
                <option value="PERFUMES">PERFUMES</option>
              </select>
            </div>
            <div class="col-md-4">
              <label class="form-label font-display ls-editorial small">Price (INR)</label>
              <input type="number" name="price" step="0.01" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label font-display ls-editorial small">Stock</label>
              <input type="number" name="stock" class="form-control" required />
            </div>
            <div class="col-12">
              <label class="form-label font-display ls-editorial small">Colour</label>
              <input type="text" name="colorName" class="form-control" required />
            </div>
            <div class="col-12">
              <label class="form-label font-display ls-editorial small">Description</label>
              <textarea name="description" class="form-control" rows="3" required></textarea>
            </div>
          </div>
          <div class="mt-4 d-flex gap-3">
            <button type="submit" class="btn btn-vera-primary">Save Product</button>
            <a href="products.jsp" class="btn btn-vera-outline">Cancel</a>
          </div>
        </form>
      </div>
    </main>
  </body>
</html>
