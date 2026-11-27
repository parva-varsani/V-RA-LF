<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String sessionKey = session.getAttribute("userEmail") != null ? session.getAttribute("userEmail").toString() : session.getId();
  int cartCount = 0;
  try {
    Connection cCon = DBConnection.getConnection();
    PreparedStatement cPs = cCon.prepareStatement("SELECT COALESCE(SUM(quantity), 0) AS total_qty FROM cart WHERE session_key = ?");
    cPs.setString(1, sessionKey);
    ResultSet cRs = cPs.executeQuery();
    if (cRs.next()) {
      cartCount = cRs.getInt("total_qty");
    }
    cCon.close();
  } catch (Exception e) {
  }
%>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA — Minimalist Luxury Fashion India</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500&family=Jost:wght@300;400;500;600&family=Plus+Jakarta+Sans:wght@400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/style.css" />
  </head>
  <body>
    <header id="veraHeader" class="vera-header header-transparent">
      <div class="d-flex align-items-center gap-3">
        <button class="vera-icon-btn" type="button" data-bs-toggle="offcanvas" data-bs-target="#veraMenuDrawer">
          <i class="bi bi-list fs-5"></i>
        </button>
        <a href="index.jsp" class="vera-brand">VÉRA</a>
      </div>

      <nav class="vera-nav-links d-none d-lg-flex">
        <a href="products.jsp?category=WOMAN" class="vera-nav-link">Woman</a>
        <a href="products.jsp?category=MAN" class="vera-nav-link">Man</a>
        <a href="products.jsp?category=KIDS" class="vera-nav-link">Kids</a>
        <a href="products.jsp?category=PERFUMES" class="vera-nav-link">Perfumes</a>
      </nav>

      <div class="vera-header-actions">
        <a href="products.jsp" class="vera-icon-btn"><i class="bi bi-search"></i><span class="d-none d-md-inline">Search</span></a>
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
        <div>
          <ul class="list-unstyled d-flex flex-column gap-3 mb-5">
            <li><a href="products.jsp" class="text-decoration-none text-black font-display ls-editorial fs-6">All Collections</a></li>
            <li><a href="products.jsp?category=WOMAN" class="text-decoration-none text-black font-display ls-editorial fs-6">Woman</a></li>
            <li><a href="products.jsp?category=MAN" class="text-decoration-none text-black font-display ls-editorial fs-6">Man</a></li>
            <li><a href="products.jsp?category=KIDS" class="text-decoration-none text-black font-display ls-editorial fs-6">Kids</a></li>
            <li><a href="products.jsp?category=PERFUMES" class="text-decoration-none text-black font-display ls-editorial fs-6">Perfumes</a></li>
          </ul>
          <div class="border-top border-vera pt-4">
            <ul class="list-unstyled d-flex flex-column gap-2">
              <li><a href="account.jsp" class="text-decoration-none text-black small ls-editorial font-display">Account &amp; Orders</a></li>
              <li><a href="cart.jsp" class="text-decoration-none text-black small ls-editorial font-display">Shopping Bag</a></li>
            </ul>
          </div>
        </div>
        <div class="border-top border-vera pt-3">
          <a href="admin-dashboard.jsp" class="btn btn-vera-outline w-100">Atelier Admin Panel</a>
        </div>
      </div>
    </div>

    <main>
      <section class="vera-hero">
        <img src="images/hero_campaign.jpg" alt="VÉRA Campaign" class="vera-hero-img" />
        <div class="vera-hero-scrim">
          <div class="container-fluid px-0">
            <p class="vera-hero-subtitle mb-2">Autumn / Winter Editorial · India</p>
            <h1 class="vera-hero-title mb-4">Architectural Tailoring &amp; Monolith Silhouette</h1>
            <a href="products.jsp" class="btn btn-vera-hero">Explore Collection</a>
          </div>
        </div>
      </section>

      <section class="container-fluid px-3 px-md-5 py-5 my-3">
        <div class="d-flex justify-content-between align-items-end border-bottom border-vera pb-3 mb-4">
          <div>
            <div class="font-display ls-wide text-muted-vera" style="font-size:10px;">Editorial Selection</div>
            <h2 class="font-display ls-editorial fs-5 fw-normal mb-0 mt-1">Department Lookbook</h2>
          </div>
          <a href="products.jsp" class="font-display ls-editorial text-black text-decoration-none" style="font-size:11px;">View All Pieces <i class="bi bi-arrow-right ms-1"></i></a>
        </div>

        <div class="row g-4">
          <div class="col-12 col-md-4">
            <a href="products.jsp?category=WOMAN" class="editorial-split-card">
              <div class="editorial-split-media"><img src="images/woman_blazer.jpg" alt="Woman" /></div>
              <div class="p-3 d-flex justify-content-between align-items-center border-top border-vera">
                <span class="font-display ls-editorial" style="font-size:12px;">Woman · Winter Tailoring</span>
                <i class="bi bi-arrow-right"></i>
              </div>
            </a>
          </div>
          <div class="col-12 col-md-4">
            <a href="products.jsp?category=MAN" class="editorial-split-card">
              <div class="editorial-split-media"><img src="images/man_overcoat.jpg" alt="Man" /></div>
              <div class="p-3 d-flex justify-content-between align-items-center border-top border-vera">
                <span class="font-display ls-editorial" style="font-size:12px;">Man · Cashmere Outerwear</span>
                <i class="bi bi-arrow-right"></i>
              </div>
            </a>
          </div>
          <div class="col-12 col-md-4">
            <a href="products.jsp?category=PERFUMES" class="editorial-split-card">
              <div class="editorial-split-media"><img src="images/perfume_santal.jpg" alt="Perfumes" /></div>
              <div class="p-3 d-flex justify-content-between align-items-center border-top border-vera">
                <span class="font-display ls-editorial" style="font-size:12px;">Perfumes · Santal 04 Extrait</span>
                <i class="bi bi-arrow-right"></i>
              </div>
            </a>
          </div>
        </div>
      </section>

      <section class="container-fluid px-3 px-md-5 py-4">
        <div class="d-flex justify-content-between align-items-end border-bottom border-vera pb-3 mb-4">
          <div>
            <div class="font-display ls-wide text-muted-vera" style="font-size:10px;">Live Inventory</div>
            <h2 class="font-display ls-editorial fs-5 fw-normal mb-0 mt-1">New Arrivals</h2>
          </div>
          <a href="products.jsp" class="font-display ls-editorial text-black text-decoration-none" style="font-size:11px;">Shop Full Catalog <i class="bi bi-arrow-right ms-1"></i></a>
        </div>

        <div class="row g-4">
          <%
            try {
              Connection con = DBConnection.getConnection();
              Statement st = con.createStatement();
              ResultSet rs = st.executeQuery("SELECT * FROM products ORDER BY id DESC LIMIT 4");
              while (rs.next()) {
                int pid = rs.getInt("id");
                String pName = rs.getString("name");
                String pCat = rs.getString("category");
                String pColor = rs.getString("color_name");
                String pImg = rs.getString("image_url");
                double pPrice = rs.getDouble("price");
                String[] szList = rs.getString("sizes").split(",");
          %>
          <div class="col-6 col-lg-3">
            <article class="vera-product-card">
              <div class="vera-product-media">
                <a href="product-detail.jsp?id=<%= pid %>" class="d-block w-100 h-100">
                  <img src="<%= pImg %>" alt="<%= pName %>" />
                </a>
                <div class="vera-quick-add">
                  <div class="d-flex flex-wrap gap-1">
                    <% for (int i = 0; i < szList.length; i++) { %>
                      <form action="CartServlet" method="post" class="d-inline">
                        <input type="hidden" name="action" value="add" />
                        <input type="hidden" name="productId" value="<%= pid %>" />
                        <input type="hidden" name="size" value="<%= szList[i].trim() %>" />
                        <input type="hidden" name="redirect" value="cart.jsp" />
                        <button type="submit" class="vera-quick-size-btn"><%= szList[i].trim() %></button>
                      </form>
                    <% } %>
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
              con.close();
            } catch (Exception e) {
          %>
            <div class="col-12"><div class="alert alert-danger small">Database error: <%= e.getMessage() %></div></div>
          <%
            }
          %>
        </div>
      </section>

      <section class="container-fluid px-3 px-md-5 pt-5">
        <div class="editorial-banner-wide border border-vera">
          <img src="images/atelier_banner.jpg" alt="Atelier" />
          <div class="editorial-banner-overlay">
            <div>
              <p class="vera-hero-subtitle mb-2">Atelier Series · Mumbai &amp; Milan</p>
              <h2 class="font-display ls-editorial text-white fs-3 fw-normal mb-3" style="max-width:520px;">Natural Fibres, Unlined Precision &amp; Timeless Form</h2>
              <a href="products.jsp?category=KIDS" class="btn btn-vera-hero me-2">Discover Kids</a>
              <a href="products.jsp" class="btn btn-vera-outline text-white border-white">View All</a>
            </div>
          </div>
        </div>
      </section>
    </main>

    <footer class="vera-footer">
      <div class="container-fluid px-3 px-md-5">
        <div class="row g-4 pb-4 border-bottom border-vera">
          <div class="col-12 col-md-4">
            <div class="vera-brand mb-3">VÉRA</div>
            <p class="small text-muted-vera mb-0">Minimalist luxury apparel &amp; fine fragrance curated for India.</p>
          </div>
          <div class="col-6 col-md-2">
            <div class="vera-footer-heading">Collections</div>
            <a href="products.jsp?category=WOMAN" class="vera-footer-link">Woman</a>
            <a href="products.jsp?category=MAN" class="vera-footer-link">Man</a>
            <a href="products.jsp?category=KIDS" class="vera-footer-link">Kids</a>
            <a href="products.jsp?category=PERFUMES" class="vera-footer-link">Perfumes</a>
          </div>
          <div class="col-6 col-md-3">
            <div class="vera-footer-heading">Client Care</div>
            <a href="account.jsp" class="vera-footer-link">My Account &amp; Orders</a>
            <a href="cart.jsp" class="vera-footer-link">Shopping Bag &amp; Checkout</a>
          </div>
          <div class="col-12 col-md-3">
            <div class="vera-footer-heading">Atelier Operations</div>
            <a href="admin-dashboard.jsp" class="vera-footer-link">Admin Dashboard</a>
            <a href="admin-products.jsp" class="vera-footer-link">Manage Inventory</a>
            <a href="admin-orders.jsp" class="vera-footer-link">Order Fulfillment</a>
          </div>
        </div>
        <div class="d-flex justify-content-between pt-4 small text-muted-vera">
          <span>© 2026 VÉRA Fashion India Pvt. Ltd.</span>
          <span class="font-display ls-editorial" style="font-size:10px;">India · INR (₹)</span>
        </div>
      </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      window.addEventListener('scroll', function () {
        var h = document.getElementById('veraHeader');
        if (window.scrollY > 40) h.classList.add('is-scrolled');
        else h.classList.remove('is-scrolled');
      });
    </script>
  </body>
</html>
