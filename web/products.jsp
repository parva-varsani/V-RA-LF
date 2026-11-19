<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA — Products (MySQL)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/style.css" />
  </head>
  <body class="page-offset">
    <header class="vera-header">
      <a href="index.html" class="vera-brand">VÉRA</a>
      <nav class="vera-nav-links d-none d-md-flex">
        <a href="index.html" class="vera-nav-link">Home</a>
        <a href="products.jsp" class="vera-nav-link active">Catalog</a>
        <a href="orders.jsp" class="vera-nav-link">Orders</a>
        <a href="add-product.jsp" class="vera-nav-link">Add Product</a>
      </nav>
      <div class="vera-header-actions">
        <a href="login.jsp" class="vera-icon-btn">Account</a>
      </div>
    </header>

    <main class="container py-5">
      <div class="d-flex justify-content-between align-items-end border-bottom border-vera pb-3 mb-4">
        <h1 class="font-display ls-editorial fs-4 fw-normal mb-0">Store Catalog</h1>
        <a href="add-product.jsp" class="btn btn-vera-primary">Add New Product</a>
      </div>

      <% if ("1".equals(request.getParameter("added"))) { %>
        <div class="alert alert-success small mb-4">Product added successfully.</div>
      <% } %>

      <div class="row g-4">
        <%
          try {
            Connection con = DBConnection.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM products ORDER BY id DESC");
            while (rs.next()) {
              String pName = rs.getString("name");
              String pSku = rs.getString("sku");
              String pCat = rs.getString("category");
              double pPrice = rs.getDouble("price");
              int pStock = rs.getInt("stock");
              String pColor = rs.getString("color_name");
              String pDesc = rs.getString("description");
        %>
        <div class="col-12 col-md-6 col-lg-4">
          <div class="border border-vera p-4 h-100 d-flex flex-column justify-content-between">
            <div>
              <div class="d-flex justify-content-between small text-muted-vera mb-2">
                <span class="font-display ls-editorial"><%= pCat %></span>
                <span class="font-mono-num"><%= pSku %></span>
              </div>
              <h2 class="font-display ls-editorial fs-6 fw-normal mb-2"><%= pName %></h2>
              <div class="font-mono-num mb-2">₹ <%= String.format("%.2f", pPrice) %></div>
              <p class="small text-muted-vera mb-3"><%= pDesc %></p>
            </div>
            <div class="pt-3 border-top border-vera d-flex justify-content-between align-items-center">
              <span class="small text-muted-vera"><%= pColor %> · Stock: <%= pStock %></span>
              <a href="checkout.jsp?product=<%= java.net.URLEncoder.encode(pName, "UTF-8") %>&price=<%= pPrice %>" class="btn btn-vera-outline py-2 px-3">Order Now</a>
            </div>
          </div>
        </div>
        <%
            }
            con.close();
          } catch (Exception e) {
        %>
          <div class="col-12">
            <div class="alert alert-danger small">Database connection error: <%= e.getMessage() %></div>
          </div>
        <%
          }
        %>
      </div>
    </main>
  </body>
</html>
