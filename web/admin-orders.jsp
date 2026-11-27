<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String statusFilter = request.getParameter("status");
  if (statusFilter == null || statusFilter.isEmpty()) statusFilter = "ALL";
%>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA Atelier Admin — Orders</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500&family=Jost:wght@300;400;500;600&family=Plus+Jakarta+Sans:wght@400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/style.css" />
  </head>
  <body>
    <div id="adminShell" class="admin-shell">
      <aside class="admin-sidebar">
        <div>
          <div class="p-4 border-bottom d-flex justify-content-between align-items-center" style="border-color: var(--admin-border) !important;">
            <div>
              <div class="vera-brand fs-5">VÉRA</div>
              <div class="admin-brand-sub font-display ls-wide text-muted-vera mt-1" style="font-size:9px;">Atelier Console</div>
            </div>
            <button type="button" onclick="document.getElementById('adminShell').classList.toggle('sidebar-collapsed')" class="btn btn-link p-0 text-reset">
              <i class="bi bi-layout-sidebar"></i>
            </button>
          </div>
          <nav class="mt-2">
            <a href="admin-dashboard.jsp" class="admin-nav-link"><i class="bi bi-speedometer2"></i><span class="admin-nav-label">Dashboard</span></a>
            <a href="admin-products.jsp" class="admin-nav-link"><i class="bi bi-box-seam"></i><span class="admin-nav-label">Products</span></a>
            <a href="admin-add-product.jsp" class="admin-nav-link"><i class="bi bi-plus-square"></i><span class="admin-nav-label">Add Product</span></a>
            <a href="admin-orders.jsp" class="admin-nav-link active"><i class="bi bi-receipt"></i><span class="admin-nav-label">Orders</span></a>
            <a href="admin-customers.jsp" class="admin-nav-link"><i class="bi bi-people"></i><span class="admin-nav-label">Customers</span></a>
          </nav>
        </div>
        <div class="p-3 border-top" style="border-color: var(--admin-border) !important;">
          <a href="index.jsp" class="admin-nav-link px-2"><i class="bi bi-arrow-up-right-square"></i><span class="admin-nav-label">View Live Store</span></a>
        </div>
      </aside>

      <div class="admin-main">
        <header class="admin-topbar">
          <h1 class="font-display ls-editorial fs-6 fw-normal mb-0">Order Management</h1>
          <div class="d-flex align-items-center gap-2">
            <button type="button" onclick="document.getElementById('adminShell').classList.toggle('admin-dark')" class="btn btn-vera-subtle px-3 py-1">Theme</button>
            <a href="account.jsp?tab=orders" class="btn btn-vera-outline px-3 py-1">Client Order View</a>
          </div>
        </header>

        <main class="p-4 p-lg-5 flex-fill">
          <% if ("1".equals(request.getParameter("updated"))) { %>
            <div class="alert alert-success small mb-4">Order status updated in MySQL.</div>
          <% } %>

          <div class="admin-card mb-4 d-flex flex-wrap gap-2">
            <a href="admin-orders.jsp?status=ALL" class="btn btn-vera-subtle <%= "ALL".equals(statusFilter) ? "active" : "" %>">All</a>
            <a href="admin-orders.jsp?status=Processing" class="btn btn-vera-subtle <%= "Processing".equals(statusFilter) ? "active" : "" %>">Processing</a>
            <a href="admin-orders.jsp?status=Shipped" class="btn btn-vera-subtle <%= "Shipped".equals(statusFilter) ? "active" : "" %>">Shipped</a>
            <a href="admin-orders.jsp?status=Delivered" class="btn btn-vera-subtle <%= "Delivered".equals(statusFilter) ? "active" : "" %>">Delivered</a>
            <a href="admin-orders.jsp?status=Cancelled" class="btn btn-vera-subtle <%= "Cancelled".equals(statusFilter) ? "active" : "" %>">Cancelled</a>
          </div>

          <div class="admin-card">
            <div class="table-responsive">
              <table class="admin-table">
                <thead>
                  <tr>
                    <th>Order ID</th>
                    <th>Customer</th>
                    <th>City &amp; PIN</th>
                    <th>Payment</th>
                    <th>Total (₹)</th>
                    <th>Update Status</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                    try {
                      Connection con = DBConnection.getConnection();
                      PreparedStatement ps;
                      if ("ALL".equals(statusFilter)) {
                        ps = con.prepareStatement("SELECT * FROM orders ORDER BY id DESC");
                      } else {
                        ps = con.prepareStatement("SELECT * FROM orders WHERE status = ? ORDER BY id DESC");
                        ps.setString(1, statusFilter);
                      }
                      ResultSet rs = ps.executeQuery();
                      while (rs.next()) {
                        int oid = rs.getInt("id");
                        String st = rs.getString("status");
                  %>
                  <tr>
                    <td class="font-mono-num small"><%= rs.getString("order_code") %></td>
                    <td>
                      <div><%= rs.getString("customer_name") %></div>
                      <div class="small text-muted-vera"><%= rs.getString("customer_email") %></div>
                    </td>
                    <td><%= rs.getString("city") %> — <span class="font-mono-num small"><%= rs.getString("pin_code") %></span></td>
                    <td class="small"><%= rs.getString("payment_method") %></td>
                    <td class="font-mono-num">₹ <%= String.format("%,.2f", rs.getDouble("total_amount")) %></td>
                    <td>
                      <form action="UpdateOrderStatusServlet" method="post" class="d-flex gap-2">
                        <input type="hidden" name="orderId" value="<%= oid %>" />
                        <select name="status" class="form-select form-select-sm" style="width:140px;">
                          <option value="Processing" <%= "Processing".equals(st) ? "selected" : "" %>>Processing</option>
                          <option value="Shipped" <%= "Shipped".equals(st) ? "selected" : "" %>>Shipped</option>
                          <option value="Delivered" <%= "Delivered".equals(st) ? "selected" : "" %>>Delivered</option>
                          <option value="Cancelled" <%= "Cancelled".equals(st) ? "selected" : "" %>>Cancelled</option>
                        </select>
                        <button type="submit" class="btn btn-vera-subtle px-2 py-1">Save</button>
                      </form>
                    </td>
                  </tr>
                  <%
                      }
                      con.close();
                    } catch (Exception e) {
                  %>
                  <tr><td colspan="6" class="text-danger small">Database error: <%= e.getMessage() %></td></tr>
                  <%
                    }
                  %>
                </tbody>
              </table>
            </div>
          </div>
        </main>
      </div>
    </div>
  </body>
</html>
