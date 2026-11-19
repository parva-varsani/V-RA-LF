<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA — Login &amp; Register</title>
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
        <a href="add-product.jsp" class="vera-nav-link">Add Product</a>
      </nav>
      <div class="vera-header-actions">
        <a href="login.jsp" class="vera-icon-btn">Account</a>
      </div>
    </header>

    <main class="container py-5">
      <div class="border-bottom border-vera pb-3 mb-4">
        <h1 class="font-display ls-editorial fs-4 fw-normal mb-0">Client Account</h1>
      </div>

      <% if ("1".equals(request.getParameter("error"))) { %>
        <div class="alert alert-danger small mb-4">Invalid email or password. Please try again.</div>
      <% } %>
      <% if ("1".equals(request.getParameter("registered"))) { %>
        <div class="alert alert-success small mb-4">Registration successful. Please sign in below.</div>
      <% } %>
      <% if ("1".equals(request.getParameter("regError"))) { %>
        <div class="alert alert-danger small mb-4">Could not register account. Email may already exist.</div>
      <% } %>

      <div class="row g-5">
        <div class="col-lg-5">
          <div class="border border-vera p-4">
            <h2 class="font-display ls-editorial fs-6 mb-3">Sign In</h2>
            <form action="LoginServlet" method="post">
              <div class="mb-3">
                <label class="form-label font-display ls-editorial small">Email</label>
                <input type="email" name="email" class="form-control" required />
              </div>
              <div class="mb-3">
                <label class="form-label font-display ls-editorial small">Password</label>
                <input type="password" name="password" class="form-control" required />
              </div>
              <button type="submit" class="btn btn-vera-primary w-100">Sign In</button>
            </form>
          </div>
        </div>

        <div class="col-lg-6">
          <div class="border border-vera p-4">
            <h2 class="font-display ls-editorial fs-6 mb-3">Register</h2>
            <form action="RegisterServlet" method="post">
              <div class="row g-3">
                <div class="col-md-6">
                  <label class="form-label font-display ls-editorial small">Full Name</label>
                  <input type="text" name="name" class="form-control" required />
                </div>
                <div class="col-md-6">
                  <label class="form-label font-display ls-editorial small">City</label>
                  <input type="text" name="city" class="form-control" required />
                </div>
                <div class="col-md-6">
                  <label class="form-label font-display ls-editorial small">Email</label>
                  <input type="email" name="email" class="form-control" required />
                </div>
                <div class="col-md-6">
                  <label class="form-label font-display ls-editorial small">Phone</label>
                  <input type="text" name="phone" class="form-control" required />
                </div>
                <div class="col-12">
                  <label class="form-label font-display ls-editorial small">Password</label>
                  <input type="password" name="password" class="form-control" required />
                </div>
              </div>
              <button type="submit" class="btn btn-vera-outline w-100 mt-4">Create Account</button>
            </form>
          </div>
        </div>
      </div>
    </main>
  </body>
</html>
