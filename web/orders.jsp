<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String userName = (String) session.getAttribute("userName");
%>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA — Orders (MySQL)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/style.css" />
  </head>
  <body class="page-offset">
    <header class="vera-header">
      <a href="index.html" class="vera-brand">VÉRA</a>
      <nav class="vera-nav-links d-none d-md-flex">
        <a href="index.html" class="vera-nav-link">Home</a>
        <a href="products.jsp" class="vera-nav-link">Catalog</a>
        <a href="orders.jsp" class="vera-nav-link active">Orders</a>
        <a href="add-product.jsp" class="vera-nav-link">Add Product</a>
      </nav>
      <div class="vera-header-actions">
        <% if (userName != null) { %>
          <span class="small"><%= userName %></span>
          <a href="LogoutServlet" class="vera-icon-btn">Logout</a>
        <% } else { %>
          <a href="login.jsp" class="vera-icon-btn">Login</a>
        <% } %>
      </div>
    </header>

    <main class="container py-5">
      <div class="d-flex justify-content-between align-items-end border-bottom border-vera pb-3 mb-4">
        <h1 class="font-display ls-editorial fs-4 fw-normal mb-0">Order History</h1>
        <a href="products.jsp" class="btn btn-vera-outline">Shop More</a>
      </div>

      <% if ("1".equals(request.getParameter("placed"))) { %>
        <div class="alert alert-success small mb-4">Order placed and saved to MySQL database.</div>
      <% } %>

      <div class="border border-vera p-3">
        <div class="table-responsive">
          <table class="admin-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Customer</th>
                <th>Product</th>
                <th>Size</th>
                <th>Qty</th>
                <th>City</th>
                <th>Payment</th>
                <th>Status</th>
                <th class="text-end">Total (₹)</th>
              </tr>
            </thead>
            <tbody>
              <%
                try {
                  Connection con = DBConnection.getConnection();
                  Statement st = con.createStatement();
                  ResultSet rs = st.executeQuery("SELECT * FROM orders ORDER BY id DESC");
                  while (rs.next()) {
              %>
              <tr>
                <td class="font-mono-num">#<%= rs.getInt("id") %></td>
                <td><%= rs.getString("customer_name") %></td>
                <td><%= rs.getString("product_name") %></td>
                <td><%= rs.getString("size") %></td>
                <td class="font-mono-num"><%= rs.getInt("quantity") %></td>
                <td><%= rs.getString("city") %> - <%= rs.getString("pin_code") %></td>
                <td><%= rs.getString("payment_method") %></td>
                <td><%= rs.getString("status") %></td>
                <td class="text-end font-mono-num">₹ <%= String.format("%.2f", rs.getDouble("total_amount")) %></td>
              </tr>
              <%
                  }
                  con.close();
                } catch (Exception e) {
              %>
              <tr>
                <td colspan="9" class="text-danger small">Database error: <%= e.getMessage() %></td>
              </tr>
              <%
                }
              %>
            </tbody>
          </table>
        </div>
      </div>
    </main>
  </body>
</html>
