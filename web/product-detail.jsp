<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String idParam = request.getParameter("id");
  int pid = 1;
  if (idParam != null && !idParam.isEmpty()) {
    try { pid = Integer.parseInt(idParam); } catch (Exception e) {}
  }

  String sessionKey = session.getAttribute("userEmail") != null ? session.getAttribute("userEmail").toString() : session.getId();
  int cartCount = 0;
  boolean wished = false;

  String pSku = "", pName = "", pCat = "", pColor = "", pHex = "#111111", pSizes = "S,M,L", pImg = "", pDesc = "", pComp = "";
  double pPrice = 0;
  int pStock = 0;
  boolean found = false;

  try {
    Connection con = DBConnection.getConnection();
    PreparedStatement cPs = con.prepareStatement("SELECT COALESCE(SUM(quantity), 0) AS total_qty FROM cart WHERE session_key = ?");
    cPs.setString(1, sessionKey);
    ResultSet cRs = cPs.executeQuery();
    if (cRs.next()) cartCount = cRs.getInt("total_qty");

    PreparedStatement pPs = con.prepareStatement("SELECT * FROM products WHERE id = ?");
    pPs.setInt(1, pid);
    ResultSet rs = pPs.executeQuery();
    if (rs.next()) {
      found = true;
      pSku = rs.getString("sku");
      pName = rs.getString("name");
      pCat = rs.getString("category");
      pPrice = rs.getDouble("price");
      pStock = rs.getInt("stock");
      pColor = rs.getString("color_name");
      pHex = rs.getString("color_hex");
      pSizes = rs.getString("sizes");
      pImg = rs.getString("image_url");
      pDesc = rs.getString("description");
      pComp = rs.getString("composition");
    }

    PreparedStatement wPs = con.prepareStatement("SELECT id FROM wishlist WHERE session_key = ? AND product_id = ?");
    wPs.setString(1, sessionKey);
    wPs.setInt(2, pid);
    ResultSet wRs = wPs.executeQuery();
    if (wRs.next()) wished = true;

    con.close();
  } catch (Exception e) {
  }
  String[] sizeArr = pSizes.split(",");
%>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA — <%= found ? pName : "Product Detail" %></title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500&family=Jost:wght@300;400;500;600&family=Plus+Jakarta+Sans:wght@400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="css/style.css" />
  </head>
  <body class="page-offset">
    <header class="vera-header">
      <a href="index.jsp" class="vera-brand">VÉRA</a>
      <nav class="vera-nav-links d-none d-lg-flex">
        <a href="products.jsp?category=WOMAN" class="vera-nav-link">Woman</a>
        <a href="products.jsp?category=MAN" class="vera-nav-link">Man</a>
        <a href="products.jsp?category=KIDS" class="vera-nav-link">Kids</a>
        <a href="products.jsp?category=PERFUMES" class="vera-nav-link">Perfumes</a>
      </nav>
      <div class="vera-header-actions">
        <a href="account.jsp" class="vera-icon-btn"><i class="bi bi-person"></i><span class="d-none d-md-inline">Account</span></a>
        <a href="cart.jsp" class="vera-icon-btn"><i class="bi bi-bag"></i><span>Bag (<%= cartCount %>)</span></a>
      </div>
    </header>

    <main class="container-fluid px-3 px-md-5 py-4">
      <% if (!found) { %>
        <div class="border border-vera p-5 text-center">
          <p class="font-display ls-editorial mb-3">Product not found.</p>
          <a href="products.jsp" class="btn btn-vera-primary">Back to Collections</a>
        </div>
      <% } else { %>
      <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb mb-0 font-display ls-editorial" style="font-size:10px;">
          <li class="breadcrumb-item"><a href="index.jsp" class="text-muted-vera text-decoration-none">Home</a></li>
          <li class="breadcrumb-item"><a href="products.jsp?category=<%= pCat %>" class="text-muted-vera text-decoration-none"><%= pCat %></a></li>
          <li class="breadcrumb-item active text-black"><%= pSku %></li>
        </ol>
      </nav>

      <div class="row g-5 align-items-start">
        <div class="col-12 col-lg-7">
          <div class="pdp-gallery-item"><img src="<%= pImg %>" alt="<%= pName %>" /></div>
          <div class="pdp-gallery-item"><img src="images/detail_tailor.jpg" alt="Fabric Detail" /></div>
        </div>

        <div class="col-12 col-lg-5">
          <div class="pdp-sticky-panel border border-vera p-4 p-md-5">
            <div class="d-flex justify-content-between align-items-center mb-2">
              <span class="font-display ls-wide text-muted-vera" style="font-size:10px;"><%= pCat %></span>
              <span class="font-mono-num text-muted-vera" style="font-size:11px;"><%= pSku %></span>
            </div>

            <h1 class="font-display ls-editorial fs-5 fw-normal mb-2"><%= pName %></h1>
            <div class="font-mono-num fs-5 mb-1">₹ <%= String.format("%,.2f", pPrice) %></div>
            <div class="small text-muted-vera mb-4">MRP inclusive of all taxes (12% GST included)</div>

            <p class="small text-muted-vera mb-4"><%= pDesc %></p>

            <div class="mb-4">
              <div class="font-display ls-editorial small mb-2">Colour: <span class="text-muted-vera"><%= pColor %></span></div>
              <span class="pdp-swatch"><span class="pdp-swatch-fill" style="background-color:<%= pHex %>;"></span></span>
            </div>

            <form action="CartServlet" method="post" class="mb-3">
              <input type="hidden" name="action" value="add" />
              <input type="hidden" name="productId" value="<%= pid %>" />
              <input type="hidden" name="redirect" value="cart.jsp" />

              <div class="mb-4">
                <div class="d-flex justify-content-between align-items-center mb-2">
                  <label class="font-display ls-editorial small">Select Size (India)</label>
                  <span class="font-display ls-editorial <%= pStock <= 0 ? "status-cancelled" : pStock <= 5 ? "status-processing" : "status-delivered" %>" style="font-size:10px;">
                    <%= pStock <= 0 ? "OUT OF STOCK" : pStock <= 5 ? "ONLY " + pStock + " LEFT" : "IN STOCK" %>
                  </span>
                </div>
                <select name="size" class="form-select">
                  <% for (int i = 0; i < sizeArr.length; i++) { %>
                    <option value="<%= sizeArr[i].trim() %>"><%= sizeArr[i].trim() %></option>
                  <% } %>
                </select>
              </div>

              <button type="submit" class="btn btn-vera-primary w-100 py-3" <%= pStock <= 0 ? "disabled" : "" %>>
                <%= pStock <= 0 ? "Sold Out" : "Add to Bag" %>
              </button>
            </form>

            <form action="WishlistServlet" method="post" class="mb-4">
              <input type="hidden" name="productId" value="<%= pid %>" />
              <input type="hidden" name="redirect" value="product-detail.jsp?id=<%= pid %>" />
              <button type="submit" class="btn btn-vera-outline w-100 py-2">
                <i class="bi <%= wished ? "bi-heart-fill" : "bi-heart" %> me-2"></i><%= wished ? "Saved in Wishlist" : "Save to Wishlist" %>
              </button>
            </form>

            <div class="accordion vera-accordion" id="pdpAccordion">
              <div class="accordion-item">
                <h2 class="accordion-header">
                  <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#accComp">Composition &amp; Care</button>
                </h2>
                <div id="accComp" class="accordion-collapse collapse show" data-bs-parent="#pdpAccordion">
                  <div class="accordion-body small text-muted-vera"><%= pComp %></div>
                </div>
              </div>
              <div class="accordion-item">
                <h2 class="accordion-header">
                  <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#accShip">Shipping &amp; Returns (India)</button>
                </h2>
                <div id="accShip" class="accordion-collapse collapse" data-bs-parent="#pdpAccordion">
                  <div class="accordion-body small text-muted-vera">
                    Complimentary express delivery across India on orders above ₹ 5,000.00 (₹ 250.00 flat fee below). 14-day return pickup.
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <% } %>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
