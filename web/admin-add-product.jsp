<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String idParam = request.getParameter("id");
  String pId = "";
  String pSku = "", pName = "", pCat = "WOMAN", pColor = "Obsidian Black", pHex = "#111111", pSizes = "XS,S,M,L", pImg = "images/woman_blazer.jpg", pDesc = "", pComp = "";
  String pPrice = "", pStock = "15";

  if (idParam != null && !idParam.trim().isEmpty()) {
    try {
      Connection con = DBConnection.getConnection();
      PreparedStatement ps = con.prepareStatement("SELECT * FROM products WHERE id = ?");
      ps.setInt(1, Integer.parseInt(idParam));
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
        pId = String.valueOf(rs.getInt("id"));
        pSku = rs.getString("sku");
        pName = rs.getString("name");
        pCat = rs.getString("category");
        pPrice = String.valueOf(rs.getDouble("price"));
        pStock = String.valueOf(rs.getInt("stock"));
        pColor = rs.getString("color_name");
        pHex = rs.getString("color_hex");
        pSizes = rs.getString("sizes");
        pImg = rs.getString("image_url");
        pDesc = rs.getString("description");
        pComp = rs.getString("composition");
      }
      con.close();
    } catch (Exception e) {}
  }
%>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA Atelier Admin — <%= pId.isEmpty() ? "Add Product" : "Edit Product" %></title>
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
            <a href="admin-add-product.jsp" class="admin-nav-link active"><i class="bi bi-plus-square"></i><span class="admin-nav-label">Add Product</span></a>
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
          <h1 class="font-display ls-editorial fs-6 fw-normal mb-0"><%= pId.isEmpty() ? "Add New Product" : "Edit Product — " + pSku %></h1>
          <div class="d-flex align-items-center gap-2">
            <button type="button" onclick="document.getElementById('adminShell').classList.toggle('admin-dark')" class="btn btn-vera-subtle px-3 py-1">Theme</button>
            <a href="admin-products.jsp" class="btn btn-vera-outline px-3 py-1">Back to Products</a>
          </div>
        </header>

        <main class="p-4 p-lg-5 flex-fill">
          <% if ("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger small mb-4">Unable to save product. Make sure SKU is unique and all fields are valid.</div>
          <% } %>

          <div class="admin-card" style="max-width: 820px;">
            <form action="AddProductServlet" method="post">
              <input type="hidden" name="id" value="<%= pId %>" />
              <div class="row g-3">
                <div class="col-md-8">
                  <label class="form-label font-display ls-editorial small">Product Name</label>
                  <input type="text" name="name" value="<%= pName %>" class="form-control text-uppercase" required />
                </div>
                <div class="col-md-4">
                  <label class="form-label font-display ls-editorial small">SKU Code</label>
                  <input type="text" name="sku" value="<%= pSku %>" class="form-control font-mono-num text-uppercase" required />
                </div>

                <div class="col-md-4">
                  <label class="form-label font-display ls-editorial small">Category</label>
                  <select name="category" class="form-select">
                    <option value="WOMAN" <%= "WOMAN".equals(pCat) ? "selected" : "" %>>WOMAN</option>
                    <option value="MAN" <%= "MAN".equals(pCat) ? "selected" : "" %>>MAN</option>
                    <option value="KIDS" <%= "KIDS".equals(pCat) ? "selected" : "" %>>KIDS</option>
                    <option value="PERFUMES" <%= "PERFUMES".equals(pCat) ? "selected" : "" %>>PERFUMES</option>
                  </select>
                </div>
                <div class="col-md-4">
                  <label class="form-label font-display ls-editorial small">Price (₹ INR)</label>
                  <input type="number" name="price" step="0.01" value="<%= pPrice %>" class="form-control font-mono-num" required />
                </div>
                <div class="col-md-4">
                  <label class="form-label font-display ls-editorial small">Stock Quantity</label>
                  <input type="number" name="stock" value="<%= pStock %>" class="form-control font-mono-num" required />
                </div>

                <div class="col-md-6">
                  <label class="form-label font-display ls-editorial small">Colour Name</label>
                  <input type="text" name="colorName" value="<%= pColor %>" class="form-control" required />
                </div>
                <div class="col-md-6">
                  <label class="form-label font-display ls-editorial small">Swatch Hex</label>
                  <input type="color" name="colorHex" value="<%= pHex %>" class="form-control form-control-color w-100" />
                </div>

                <div class="col-12">
                  <div class="font-display ls-editorial small mb-2">Available Sizes</div>
                  <div class="d-flex flex-wrap gap-3">
                    <label class="form-check"><input class="form-check-input" type="checkbox" name="sizes" value="XS" <%= pSizes.contains("XS") ? "checked" : "" %> /> XS</label>
                    <label class="form-check"><input class="form-check-input" type="checkbox" name="sizes" value="S" <%= pSizes.contains("S") ? "checked" : "" %> /> S</label>
                    <label class="form-check"><input class="form-check-input" type="checkbox" name="sizes" value="M" <%= pSizes.contains("M") ? "checked" : "" %> /> M</label>
                    <label class="form-check"><input class="form-check-input" type="checkbox" name="sizes" value="L" <%= pSizes.contains("L") ? "checked" : "" %> /> L</label>
                    <label class="form-check"><input class="form-check-input" type="checkbox" name="sizes" value="XL" <%= pSizes.contains("XL") ? "checked" : "" %> /> XL</label>
                    <label class="form-check"><input class="form-check-input" type="checkbox" name="sizes" value="ONE SIZE" <%= pSizes.contains("ONE SIZE") ? "checked" : "" %> /> ONE SIZE</label>
                  </div>
                </div>

                <div class="col-12">
                  <label class="form-label font-display ls-editorial small">Image Path</label>
                  <select name="imageUrl" class="form-select">
                    <option value="images/woman_blazer.jpg" <%= "images/woman_blazer.jpg".equals(pImg) ? "selected" : "" %>>images/woman_blazer.jpg</option>
                    <option value="images/woman_dress.jpg" <%= "images/woman_dress.jpg".equals(pImg) ? "selected" : "" %>>images/woman_dress.jpg</option>
                    <option value="images/woman_trench.jpg" <%= "images/woman_trench.jpg".equals(pImg) ? "selected" : "" %>>images/woman_trench.jpg</option>
                    <option value="images/woman_tote.jpg" <%= "images/woman_tote.jpg".equals(pImg) ? "selected" : "" %>>images/woman_tote.jpg</option>
                    <option value="images/man_overcoat.jpg" <%= "images/man_overcoat.jpg".equals(pImg) ? "selected" : "" %>>images/man_overcoat.jpg</option>
                    <option value="images/man_suit.jpg" <%= "images/man_suit.jpg".equals(pImg) ? "selected" : "" %>>images/man_suit.jpg</option>
                    <option value="images/man_knit.jpg" <%= "images/man_knit.jpg".equals(pImg) ? "selected" : "" %>>images/man_knit.jpg</option>
                    <option value="images/kids_trench.jpg" <%= "images/kids_trench.jpg".equals(pImg) ? "selected" : "" %>>images/kids_trench.jpg</option>
                    <option value="images/perfume_santal.jpg" <%= "images/perfume_santal.jpg".equals(pImg) ? "selected" : "" %>>images/perfume_santal.jpg</option>
                  </select>
                </div>

                <div class="col-12">
                  <label class="form-label font-display ls-editorial small">Description</label>
                  <textarea name="description" class="form-control" rows="3" required><%= pDesc %></textarea>
                </div>

                <div class="col-12">
                  <label class="form-label font-display ls-editorial small">Composition &amp; Care</label>
                  <input type="text" name="composition" value="<%= pComp %>" class="form-control" required />
                </div>
              </div>

              <div class="mt-4 d-flex gap-3">
                <button type="submit" class="btn btn-vera-primary px-4"><%= pId.isEmpty() ? "Publish Product" : "Update Product" %></button>
                <a href="admin-products.jsp" class="btn btn-vera-outline">Cancel</a>
              </div>
            </form>
          </div>
        </main>
      </div>
    </div>
  </body>
</html>
