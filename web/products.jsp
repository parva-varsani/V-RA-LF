<%@ page import="java.sql.*, java.util.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String category = request.getParameter("category");
  if (category == null || category.trim().isEmpty()) category = "ALL";
  String search = request.getParameter("search");
  if (search == null) search = "";
  String sort = request.getParameter("sort");
  if (sort == null) sort = "featured";
  String cols = request.getParameter("cols");
  if (cols == null) cols = "4";

  String sessionKey = session.getAttribute("userEmail") != null ? session.getAttribute("userEmail").toString() : session.getId();
  int cartCount = 0;
  Set<Integer> wishIds = new HashSet<Integer>();

  try {
    Connection initCon = DBConnection.getConnection();
    PreparedStatement cPs = initCon.prepareStatement("SELECT COALESCE(SUM(quantity), 0) AS total_qty FROM cart WHERE session_key = ?");
    cPs.setString(1, sessionKey);
    ResultSet cRs = cPs.executeQuery();
    if (cRs.next()) cartCount = cRs.getInt("total_qty");

    PreparedStatement wPs = initCon.prepareStatement("SELECT product_id FROM wishlist WHERE session_key = ?");
    wPs.setString(1, sessionKey);
    ResultSet wRs = wPs.executeQuery();
    while (wRs.next()) wishIds.add(wRs.getInt("product_id"));
    initCon.close();
  } catch (Exception e) {
  }
%>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA — Collections</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500&family=Jost:wght@300;400;500;600&family=Plus+Jakarta+Sans:wght@400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/style.css" />
  </head>
  <body class="page-offset">
    <header class="vera-header">
      <div class="d-flex align-items-center gap-3">
        <button class="vera-icon-btn" type="button" data-bs-toggle="offcanvas" data-bs-target="#veraMenuDrawer">
          <i class="bi bi-list fs-5"></i>
        </button>
        <a href="index.jsp" class="vera-brand">VÉRA</a>
      </div>

      <nav class="vera-nav-links d-none d-lg-flex">
        <a href="products.jsp?category=WOMAN" class="vera-nav-link <%= "WOMAN".equals(category) ? "active" : "" %>">Woman</a>
        <a href="products.jsp?category=MAN" class="vera-nav-link <%= "MAN".equals(category) ? "active" : "" %>">Man</a>
        <a href="products.jsp?category=KIDS" class="vera-nav-link <%= "KIDS".equals(category) ? "active" : "" %>">Kids</a>
        <a href="products.jsp?category=PERFUMES" class="vera-nav-link <%= "PERFUMES".equals(category) ? "active" : "" %>">Perfumes</a>
      </nav>

      <div class="vera-header-actions">
        <a href="account.jsp" class="vera-icon-btn"><i class="bi bi-person"></i><span class="d-none d-md-inline">Account</span></a>
        <a href="cart.jsp" class="vera-icon-btn"><i class="bi bi-bag"></i><span>Bag (<%= cartCount %>)</span></a>
      </div>
    </header>

    <div class="offcanvas offcanvas-start" tabindex="-1" id="veraMenuDrawer">
      <div class="offcanvas-header border-bottom border-vera px-4 py-3">
        <span class="vera-brand fs-5">VÉRA</span>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas"></button>
      </div>
      <div class="offcanvas-body p-4 d-flex flex-column justify-content-between">
        <ul class="list-unstyled d-flex flex-column gap-3">
          <li><a href="products.jsp" class="text-decoration-none text-black font-display ls-editorial fs-6">All Collections</a></li>
          <li><a href="products.jsp?category=WOMAN" class="text-decoration-none text-black font-display ls-editorial fs-6">Woman</a></li>
          <li><a href="products.jsp?category=MAN" class="text-decoration-none text-black font-display ls-editorial fs-6">Man</a></li>
          <li><a href="products.jsp?category=KIDS" class="text-decoration-none text-black font-display ls-editorial fs-6">Kids</a></li>
          <li><a href="products.jsp?category=PERFUMES" class="text-decoration-none text-black font-display ls-editorial fs-6">Perfumes</a></li>
        </ul>
        <div class="border-top border-vera pt-3">
          <a href="admin-dashboard.jsp" class="btn btn-vera-outline w-100">Atelier Admin Panel</a>
        </div>
      </div>
    </div>

    <main class="container-fluid px-3 px-md-5 py-4">
      <div class="d-flex flex-wrap justify-content-between align-items-end border-bottom border-vera pb-3 mb-4 gap-3">
        <div>
          <div class="font-display ls-wide text-muted-vera" style="font-size:10px;">VÉRA Collection</div>
          <h1 class="font-display ls-editorial fs-4 fw-normal mb-0 mt-1"><%= "ALL".equals(category) ? "All Collections" : category + " Collection" %></h1>
        </div>

        <form action="products.jsp" method="get" class="d-flex flex-wrap align-items-center gap-2">
          <input type="hidden" name="category" value="<%= category %>" />
          <input type="hidden" name="cols" value="<%= cols %>" />
          <input type="search" name="search" value="<%= search %>" class="form-control" style="width:220px;" placeholder="Search pieces..." />
          <select name="sort" class="form-select" style="width:190px;" onchange="this.form.submit()">
            <option value="featured" <%= "featured".equals(sort) ? "selected" : "" %>>Sort: Featured</option>
            <option value="price_asc" <%= "price_asc".equals(sort) ? "selected" : "" %>>Price: Low to High</option>
            <option value="price_desc" <%= "price_desc".equals(sort) ? "selected" : "" %>>Price: High to Low</option>
          </select>
          <button type="submit" class="btn btn-vera-primary">Filter</button>
          <a href="products.jsp?category=<%= category %>&search=<%= search %>&sort=<%= sort %>&cols=2" class="btn btn-vera-subtle <%= "2".equals(cols) ? "active" : "" %>">2-Col</a>
          <a href="products.jsp?category=<%= category %>&search=<%= search %>&sort=<%= sort %>&cols=4" class="btn btn-vera-subtle <%= "4".equals(cols) ? "active" : "" %>">4-Col</a>
        </form>
      </div>

      <div class="d-flex flex-wrap gap-2 mb-4">
        <a href="products.jsp?category=ALL&cols=<%= cols %>" class="btn btn-vera-subtle <%= "ALL".equals(category) ? "active" : "" %>">All</a>
        <a href="products.jsp?category=WOMAN&cols=<%= cols %>" class="btn btn-vera-subtle <%= "WOMAN".equals(category) ? "active" : "" %>">Woman</a>
        <a href="products.jsp?category=MAN&cols=<%= cols %>" class="btn btn-vera-subtle <%= "MAN".equals(category) ? "active" : "" %>">Man</a>
        <a href="products.jsp?category=KIDS&cols=<%= cols %>" class="btn btn-vera-subtle <%= "KIDS".equals(category) ? "active" : "" %>">Kids</a>
        <a href="products.jsp?category=PERFUMES&cols=<%= cols %>" class="btn btn-vera-subtle <%= "PERFUMES".equals(category) ? "active" : "" %>">Perfumes</a>
      </div>

      <div class="row g-4">
        <%
          String colClass = "2".equals(cols) ? "col-6 col-md-6" : "col-6 col-lg-3";
          try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM products WHERE 1=1";
            if (!"ALL".equals(category)) sql += " AND category = ?";
            if (!search.trim().isEmpty()) sql += " AND (name LIKE ? OR color_name LIKE ? OR sku LIKE ?)";
            if ("price_asc".equals(sort)) sql += " ORDER BY price ASC";
            else if ("price_desc".equals(sort)) sql += " ORDER BY price DESC";
            else sql += " ORDER BY id DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            int idx = 1;
            if (!"ALL".equals(category)) ps.setString(idx++, category);
            if (!search.trim().isEmpty()) {
              String like = "%" + search.trim() + "%";
              ps.setString(idx++, like);
              ps.setString(idx++, like);
              ps.setString(idx++, like);
            }
            ResultSet rs = ps.executeQuery();
            boolean any = false;
            while (rs.next()) {
              any = true;
              int pid = rs.getInt("id");
              String pName = rs.getString("name");
              String pCat = rs.getString("category");
              String pColor = rs.getString("color_name");
              String pImg = rs.getString("image_url");
              double pPrice = rs.getDouble("price");
              int pStock = rs.getInt("stock");
              String[] szList = rs.getString("sizes").split(",");
              boolean wished = wishIds.contains(pid);
        %>
        <div class="<%= colClass %>">
          <article class="vera-product-card">
            <div class="vera-product-media">
              <form action="WishlistServlet" method="post">
                <input type="hidden" name="productId" value="<%= pid %>" />
                <input type="hidden" name="redirect" value="products.jsp?category=<%= category %>&cols=<%= cols %>" />
                <button type="submit" class="vera-wishlist-icon-btn <%= wished ? "is-active" : "" %>">
                  <i class="bi <%= wished ? "bi-heart-fill" : "bi-heart" %>"></i>
                </button>
              </form>
              <a href="product-detail.jsp?id=<%= pid %>" class="d-block w-100 h-100">
                <img src="<%= pImg %>" alt="<%= pName %>" />
              </a>
              <div class="vera-quick-add">
                <div class="d-flex justify-content-between mb-1">
                  <span class="font-display" style="font-size:9px;letter-spacing:0.12em;color:#666;">QUICK ADD</span>
                  <% if (pStock <= 0) { %>
                    <span class="font-display status-cancelled" style="font-size:9px;">SOLD OUT</span>
                  <% } else if (pStock <= 5) { %>
                    <span class="font-display status-processing" style="font-size:9px;">LOW STOCK</span>
                  <% } %>
                </div>
                <div class="d-flex flex-wrap gap-1">
                  <% if (pStock > 0) { for (int i = 0; i < szList.length; i++) { %>
                    <form action="CartServlet" method="post" class="d-inline">
                      <input type="hidden" name="action" value="add" />
                      <input type="hidden" name="productId" value="<%= pid %>" />
                      <input type="hidden" name="size" value="<%= szList[i].trim() %>" />
                      <input type="hidden" name="redirect" value="cart.jsp" />
                      <button type="submit" class="vera-quick-size-btn"><%= szList[i].trim() %></button>
                    </form>
                  <% } } %>
                </div>
              </div>
            </div>
            <div class="vera-product-meta">
              <div class="vera-product-kicker"><%= pCat %> · <%= pColor %></div>
              <a href="product-detail.jsp?id=<%= pid %>" class="vera-product-title"><%= pName %></a>
              <div class="vera-product-price">₹ <%= String.format("%,.2f", pPrice) %></div>
            </div>
          </article>
        </div>
        <%
            }
            if (!any) {
        %>
          <div class="col-12 py-5 text-center border border-vera">
            <p class="font-display ls-editorial small mb-3">No garments matched your filter.</p>
            <a href="products.jsp" class="btn btn-vera-primary">Reset Filters</a>
          </div>
        <%
            }
            con.close();
          } catch (Exception e) {
        %>
          <div class="col-12"><div class="alert alert-danger small">Database error: <%= e.getMessage() %></div></div>
        <%
          }
        %>
      </div>
    </main>

    <footer class="vera-footer">
      <div class="container-fluid px-3 px-md-5 d-flex justify-content-between small text-muted-vera">
        <span>© 2026 VÉRA Fashion India Pvt. Ltd.</span>
        <a href="admin-dashboard.jsp" class="text-decoration-none text-muted-vera font-display ls-editorial" style="font-size:10px;">Atelier Admin Panel</a>
      </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
