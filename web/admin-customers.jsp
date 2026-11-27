<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA Atelier Admin — Customers</title>
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
            <a href="admin-orders.jsp" class="admin-nav-link"><i class="bi bi-receipt"></i><span class="admin-nav-label">Orders</span></a>
            <a href="admin-customers.jsp" class="admin-nav-link active"><i class="bi bi-people"></i><span class="admin-nav-label">Customers</span></a>
          </nav>
        </div>
        <div class="p-3 border-top" style="border-color: var(--admin-border) !important;">
          <a href="index.jsp" class="admin-nav-link px-2"><i class="bi bi-arrow-up-right-square"></i><span class="admin-nav-label">View Live Store</span></a>
        </div>
      </aside>

      <div class="admin-main">
        <header class="admin-topbar">
          <h1 class="font-display ls-editorial fs-6 fw-normal mb-0">Customer &amp; Inventory Insights</h1>
          <div class="d-flex align-items-center gap-2">
            <button type="button" onclick="document.getElementById('adminShell').classList.toggle('admin-dark')" class="btn btn-vera-subtle px-3 py-1">Theme</button>
            <a href="index.jsp" class="btn btn-vera-primary px-3 py-1">Live Store</a>
          </div>
        </header>

        <main class="p-4 p-lg-5 flex-fill">
          <div class="admin-card mb-5">
            <h2 class="font-display ls-editorial fs-6 fw-normal mb-3">Registered Clients &amp; Spend</h2>
            <div class="table-responsive">
              <table class="admin-table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Client</th>
                    <th>Phone</th>
                    <th>City</th>
                    <th>Orders</th>
                    <th class="text-end">Total Spend (₹)</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                    try {
                      Connection con = DBConnection.getConnection();
                      Statement st = con.createStatement();
                      ResultSet rs = st.executeQuery(
                          "SELECT u.id, u.name, u.email, u.phone, u.city, COUNT(o.id) AS order_cnt, COALESCE(SUM(CASE WHEN o.status <> 'Cancelled' THEN o.total_amount ELSE 0 END), 0) AS total_spend " +
                          "FROM users u LEFT JOIN orders o ON u.email = o.customer_email GROUP BY u.id, u.name, u.email, u.phone, u.city ORDER BY u.id ASC");
                      while (rs.next()) {
                  %>
                  <tr>
                    <td class="font-mono-num small">USR-<%= rs.getInt("id") %></td>
                    <td>
                      <div><%= rs.getString("name") %></div>
                      <div class="small text-muted-vera"><%= rs.getString("email") %></div>
                    </td>
                    <td class="font-mono-num small"><%= rs.getString("phone") %></td>
                    <td><%= rs.getString("city") %></td>
                    <td class="font-mono-num"><%= rs.getInt("order_cnt") %></td>
                    <td class="text-end font-mono-num">₹ <%= String.format("%,.2f", rs.getDouble("total_spend")) %></td>
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

          <div class="admin-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <h2 class="font-display ls-editorial fs-6 fw-normal mb-0">Low Stock Watchlist (&le; 5 Units)</h2>
              <a href="admin-products.jsp" class="font-display ls-editorial small text-reset text-decoration-underline">Restock</a>
            </div>
            <div class="table-responsive">
              <table class="admin-table">
                <thead>
                  <tr>
                    <th>SKU</th>
                    <th>Product</th>
                    <th>Department</th>
                    <th>Price (₹)</th>
                    <th class="text-end">Stock</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                    try {
                      Connection con = DBConnection.getConnection();
                      Statement st = con.createStatement();
                      ResultSet rs = st.executeQuery("SELECT * FROM products WHERE stock <= 5 ORDER BY stock ASC");
                      boolean anyLow = false;
                      while (rs.next()) {
                        anyLow = true;
                        int stk = rs.getInt("stock");
                  %>
                  <tr>
                    <td class="font-mono-num small"><%= rs.getString("sku") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td class="font-display ls-editorial small"><%= rs.getString("category") %></td>
                    <td class="font-mono-num">₹ <%= String.format("%,.2f", rs.getDouble("price")) %></td>
                    <td class="text-end"><span class="status-label <%= stk == 0 ? "status-cancelled" : "status-processing" %>"><%= stk %> units</span></td>
                  </tr>
                  <%
                      }
                      if (!anyLow) {
                  %>
                  <tr><td colspan="5" class="text-center py-4 text-muted-vera">All products are well stocked.</td></tr>
                  <%
                      }
                      con.close();
                    } catch (Exception e) {}
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
