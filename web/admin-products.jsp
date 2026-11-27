<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String q = request.getParameter("q");
  if (q == null) q = "";
  String cat = request.getParameter("category");
  if (cat == null || cat.isEmpty()) cat = "ALL";
%>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA Atelier Admin — Products</title>
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
            <a href="admin-products.jsp" class="admin-nav-link active"><i class="bi bi-box-seam"></i><span class="admin-nav-label">Products</span></a>
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
          <h1 class="font-display ls-editorial fs-6 fw-normal mb-0">Product Inventory</h1>
          <div class="d-flex align-items-center gap-2">
            <button type="button" onclick="document.getElementById('adminShell').classList.toggle('admin-dark')" class="btn btn-vera-subtle px-3 py-1">Theme</button>
            <a href="admin-add-product.jsp" class="btn btn-vera-primary px-3 py-1">New Product</a>
          </div>
        </header>

        <main class="p-4 p-lg-5 flex-fill">
          <% if ("1".equals(request.getParameter("saved"))) { %>
            <div class="alert alert-success small mb-4">Product saved to MySQL database.</div>
          <% } %>
          <% if ("1".equals(request.getParameter("deleted"))) { %>
            <div class="alert alert-warning small mb-4">Product deleted from catalog.</div>
          <% } %>

          <div class="admin-card mb-4">
            <form action="admin-products.jsp" method="get" class="row g-3 align-items-center">
              <div class="col-md-5">
                <input type="search" name="q" value="<%= q %>" class="form-control" placeholder="Search by product name or SKU..." />
              </div>
              <div class="col-md-4">
                <select name="category" class="form-select">
                  <option value="ALL" <%= "ALL".equals(cat) ? "selected" : "" %>>All Departments</option>
                  <option value="WOMAN" <%= "WOMAN".equals(cat) ? "selected" : "" %>>Woman</option>
                  <option value="MAN" <%= "MAN".equals(cat) ? "selected" : "" %>>Man</option>
                  <option value="KIDS" <%= "KIDS".equals(cat) ? "selected" : "" %>>Kids</option>
                  <option value="PERFUMES" <%= "PERFUMES".equals(cat) ? "selected" : "" %>>Perfumes</option>
                </select>
              </div>
              <div class="col-md-3">
                <button type="submit" class="btn btn-vera-primary w-100">Apply Filter</button>
              </div>
            </form>
          </div>

          <div class="admin-card">
            <div class="table-responsive">
              <table class="admin-table">
                <thead>
                  <tr>
                    <th>Piece</th>
                    <th>SKU</th>
                    <th>Category</th>
                    <th>Price (₹)</th>
                    <th>Stock</th>
                    <th class="text-end">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                    try {
                      Connection con = DBConnection.getConnection();
                      String sql = "SELECT * FROM products WHERE 1=1";
                      if (!"ALL".equals(cat)) sql += " AND category = ?";
                      if (!q.trim().isEmpty()) sql += " AND (name LIKE ? OR sku LIKE ?)";
                      sql += " ORDER BY id DESC";

                      PreparedStatement ps = con.prepareStatement(sql);
                      int idx = 1;
                      if (!"ALL".equals(cat)) ps.setString(idx++, cat);
                      if (!q.trim().isEmpty()) {
                        String like = "%" + q.trim() + "%";
                        ps.setString(idx++, like);
                        ps.setString(idx++, like);
                      }
                      ResultSet rs = ps.executeQuery();
                      while (rs.next()) {
                        int pid = rs.getInt("id");
                        int stock = rs.getInt("stock");
                        String stCls = stock == 0 ? "status-cancelled" : stock <= 5 ? "status-processing" : "status-delivered";
                  %>
                  <tr>
                    <td>
                      <div class="d-flex align-items-center gap-3">
                        <img src="<%= rs.getString("image_url") %>" alt="<%= rs.getString("name") %>" style="width:42px;height:56px;object-fit:cover;border:1px solid var(--admin-border);" />
                        <div>
                          <div class="font-display ls-editorial small"><%= rs.getString("name") %></div>
                          <div class="small text-muted-vera"><%= rs.getString("color_name") %></div>
                        </div>
                      </div>
                    </td>
                    <td class="font-mono-num small"><%= rs.getString("sku") %></td>
                    <td class="font-display ls-editorial small"><%= rs.getString("category") %></td>
                    <td class="font-mono-num">₹ <%= String.format("%,.2f", rs.getDouble("price")) %></td>
                    <td><span class="status-label <%= stCls %>"><%= stock %> units</span></td>
                    <td class="text-end">
                      <a href="admin-add-product.jsp?id=<%= pid %>" class="btn btn-vera-subtle px-2 py-1 me-1">Edit</a>
                      <form action="DeleteProductServlet" method="post" class="d-inline">
                        <input type="hidden" name="id" value="<%= pid %>" />
                        <button type="submit" class="btn btn-vera-subtle px-2 py-1 text-danger">Delete</button>
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
