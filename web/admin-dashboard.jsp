<%@ page import="java.sql.*, java.util.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  double totalRevenue = 0;
  int totalOrders = 0;
  int processingOrders = 0;
  int activeProducts = 0;
  int lowStockCount = 0;
  int womanCount = 0, manCount = 0, kidsCount = 0, perfumeCount = 0;

  try {
    Connection con = DBConnection.getConnection();
    Statement st = con.createStatement();

    ResultSet rs1 = st.executeQuery("SELECT COALESCE(SUM(total_amount), 0) AS rev, COUNT(*) AS cnt FROM orders WHERE status <> 'Cancelled'");
    if (rs1.next()) totalRevenue = rs1.getDouble("rev");

    ResultSet rs2 = st.executeQuery("SELECT COUNT(*) AS cnt FROM orders");
    if (rs2.next()) totalOrders = rs2.getInt("cnt");

    ResultSet rs3 = st.executeQuery("SELECT COUNT(*) AS cnt FROM orders WHERE status = 'Processing'");
    if (rs3.next()) processingOrders = rs3.getInt("cnt");

    ResultSet rs4 = st.executeQuery("SELECT COUNT(*) AS cnt FROM products");
    if (rs4.next()) activeProducts = rs4.getInt("cnt");

    ResultSet rs5 = st.executeQuery("SELECT COUNT(*) AS cnt FROM products WHERE stock <= 5");
    if (rs5.next()) lowStockCount = rs5.getInt("cnt");

    ResultSet rs6 = st.executeQuery("SELECT category, COUNT(*) AS cnt FROM products GROUP BY category");
    while (rs6.next()) {
      String c = rs6.getString("category");
      int n = rs6.getInt("cnt");
      if ("WOMAN".equals(c)) womanCount = n;
      else if ("MAN".equals(c)) manCount = n;
      else if ("KIDS".equals(c)) kidsCount = n;
      else if ("PERFUMES".equals(c)) perfumeCount = n;
    }

    con.close();
  } catch (Exception e) {
  }

  int maxCat = Math.max(1, Math.max(Math.max(womanCount, manCount), Math.max(kidsCount, perfumeCount)));
%>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA Atelier Admin — Dashboard</title>
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
            <a href="admin-dashboard.jsp" class="admin-nav-link active"><i class="bi bi-speedometer2"></i><span class="admin-nav-label">Dashboard</span></a>
            <a href="admin-products.jsp" class="admin-nav-link"><i class="bi bi-box-seam"></i><span class="admin-nav-label">Products</span></a>
            <a href="admin-add-product.jsp" class="admin-nav-link"><i class="bi bi-plus-square"></i><span class="admin-nav-label">Add Product</span></a>
            <a href="admin-orders.jsp" class="admin-nav-link"><i class="bi bi-receipt"></i><span class="admin-nav-label">Orders</span></a>
            <a href="admin-customers.jsp" class="admin-nav-link"><i class="bi bi-people"></i><span class="admin-nav-label">Customers</span></a>
          </nav>
        </div>
        <div class="p-3 border-top" style="border-color: var(--admin-border) !important;">
          <a href="index.jsp" class="admin-nav-link px-2"><i class="bi bi-arrow-up-right-square"></i><span class="admin-nav-label">View Live Store</span></a>
        </div>
      </aside>

      <div class="admin-main">
        <header class="admin-topbar">
          <h1 class="font-display ls-editorial fs-6 fw-normal mb-0">Overview &amp; Analytics</h1>
          <div class="d-flex align-items-center gap-2">
            <button type="button" onclick="document.getElementById('adminShell').classList.toggle('admin-dark')" class="btn btn-vera-subtle px-3 py-1">Theme</button>
            <a href="index.jsp" class="btn btn-vera-primary px-3 py-1">Live Store</a>
          </div>
        </header>

        <main class="p-4 p-lg-5 flex-fill">
          <div class="row g-4 mb-5">
            <div class="col-6 col-xl-3">
              <div class="admin-card h-100">
                <div class="admin-kpi-label">Total Revenue (INR)</div>
                <div class="admin-kpi-value">₹ <%= String.format("%,.2f", totalRevenue) %></div>
                <div class="small text-muted-vera mt-2">Active &amp; delivered orders</div>
              </div>
            </div>
            <div class="col-6 col-xl-3">
              <div class="admin-card h-100">
                <div class="admin-kpi-label">Total Orders</div>
                <div class="admin-kpi-value"><%= totalOrders %></div>
                <div class="small text-muted-vera mt-2"><%= processingOrders %> processing</div>
              </div>
            </div>
            <div class="col-6 col-xl-3">
              <div class="admin-card h-100">
                <div class="admin-kpi-label">Active Products</div>
                <div class="admin-kpi-value"><%= activeProducts %></div>
                <div class="small text-muted-vera mt-2">Stored in MySQL</div>
              </div>
            </div>
            <div class="col-6 col-xl-3">
              <div class="admin-card h-100">
                <div class="admin-kpi-label">Low Stock Alerts</div>
                <div class="admin-kpi-value"><%= lowStockCount %></div>
                <div class="small text-muted-vera mt-2">Pieces with &le; 5 units</div>
              </div>
            </div>
          </div>

          <div class="row g-4 mb-5">
            <div class="col-12 col-xl-7">
              <div class="admin-card h-100">
                <div class="admin-kpi-label">Catalog Analytics</div>
                <h2 class="font-display ls-editorial fs-6 fw-normal mb-4 mt-1">Products by Department</h2>
                <div class="vera-chart-grid">
                  <div class="vera-chart-col">
                    <div class="vera-chart-val"><%= womanCount %></div>
                    <div class="vera-chart-bar" style="height:<%= Math.max(15, (womanCount * 85) / maxCat) %>%;"></div>
                  </div>
                  <div class="vera-chart-col">
                    <div class="vera-chart-val"><%= manCount %></div>
                    <div class="vera-chart-bar" style="height:<%= Math.max(15, (manCount * 85) / maxCat) %>%;"></div>
                  </div>
                  <div class="vera-chart-col">
                    <div class="vera-chart-val"><%= kidsCount %></div>
                    <div class="vera-chart-bar" style="height:<%= Math.max(15, (kidsCount * 85) / maxCat) %>%;"></div>
                  </div>
                  <div class="vera-chart-col">
                    <div class="vera-chart-val"><%= perfumeCount %></div>
                    <div class="vera-chart-bar" style="height:<%= Math.max(15, (perfumeCount * 85) / maxCat) %>%;"></div>
                  </div>
                </div>
                <div class="vera-chart-labels">
                  <div>WOMAN</div>
                  <div>MAN</div>
                  <div>KIDS</div>
                  <div>PERFUMES</div>
                </div>
              </div>
            </div>

            <div class="col-12 col-xl-5">
              <div class="admin-card h-100 d-flex flex-column justify-content-between">
                <div>
                  <div class="admin-kpi-label">Quick Actions</div>
                  <h2 class="font-display ls-editorial fs-6 fw-normal mb-4 mt-1">Atelier Shortcuts</h2>
                  <div class="d-grid gap-2">
                    <a href="admin-add-product.jsp" class="btn btn-vera-primary">Add New Product</a>
                    <a href="admin-orders.jsp" class="btn btn-vera-outline">Manage Customer Orders</a>
                    <a href="admin-products.jsp" class="btn btn-vera-subtle">View All Inventory</a>
                  </div>
                </div>
                <div class="small text-muted-vera pt-3 border-top" style="border-color: var(--admin-border) !important;">
                  Connected via JDBC to MySQL database vera_store.
                </div>
              </div>
            </div>
          </div>

          <div class="admin-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <h2 class="font-display ls-editorial fs-6 fw-normal mb-0">Recent Orders</h2>
              <a href="admin-orders.jsp" class="font-display ls-editorial small text-reset text-decoration-underline">View All</a>
            </div>
            <div class="table-responsive">
              <table class="admin-table">
                <thead>
                  <tr>
                    <th>Order Code</th>
                    <th>Customer</th>
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
                      ResultSet rs = st.executeQuery("SELECT * FROM orders ORDER BY id DESC LIMIT 6");
                      while (rs.next()) {
                        String stVal = rs.getString("status");
                  %>
                  <tr>
                    <td class="font-mono-num"><%= rs.getString("order_code") %></td>
                    <td><%= rs.getString("customer_name") %></td>
                    <td><%= rs.getString("city") %></td>
                    <td><%= rs.getString("payment_method") %></td>
                    <td><span class="status-label status-<%= stVal.toLowerCase() %>"><%= stVal %></span></td>
                    <td class="text-end font-mono-num">₹ <%= String.format("%,.2f", rs.getDouble("total_amount")) %></td>
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
