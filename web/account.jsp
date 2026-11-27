<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Integer userId = (Integer) session.getAttribute("userId");
  String userName = (String) session.getAttribute("userName");
  String userEmail = (String) session.getAttribute("userEmail");
  String userPhone = (String) session.getAttribute("userPhone");
  String userCity = (String) session.getAttribute("userCity");
  String sessionKey = userEmail != null ? userEmail : session.getId();
  String activeTab = request.getParameter("tab");
  if (activeTab == null) activeTab = "profile";

  int cartCount = 0;
  try {
    Connection cCon = DBConnection.getConnection();
    PreparedStatement cPs = cCon.prepareStatement("SELECT COALESCE(SUM(quantity), 0) AS total_qty FROM cart WHERE session_key = ?");
    cPs.setString(1, sessionKey);
    ResultSet cRs = cPs.executeQuery();
    if (cRs.next()) cartCount = cRs.getInt("total_qty");
    cCon.close();
  } catch (Exception e) {
  }
%>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA — Account &amp; Orders</title>
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
      <div class="border-bottom border-vera pb-3 mb-4 d-flex flex-wrap justify-content-between align-items-end gap-2">
        <div>
          <div class="font-display ls-wide text-muted-vera" style="font-size:10px;">Client Portal</div>
          <h1 class="font-display ls-editorial fs-4 fw-normal mb-0 mt-1">My Account</h1>
        </div>
        <% if (userName != null) { %>
          <div class="d-flex align-items-center gap-3">
            <span class="small text-muted-vera">Signed in as <strong class="text-black"><%= userName %></strong></span>
            <a href="LogoutServlet" class="btn btn-vera-subtle">Sign Out</a>
          </div>
        <% } %>
      </div>

      <% if ("1".equals(request.getParameter("error"))) { %>
        <div class="alert alert-danger small mb-4">Invalid email or password.</div>
      <% } %>
      <% if ("1".equals(request.getParameter("registered"))) { %>
        <div class="alert alert-success small mb-4">Account created. Please sign in below.</div>
      <% } %>

      <ul class="nav nav-tabs vera-tabs mb-4">
        <li class="nav-item"><a class="nav-link <%= "profile".equals(activeTab) ? "active" : "" %>" href="account.jsp?tab=profile">Profile / Access</a></li>
        <li class="nav-item"><a class="nav-link <%= "orders".equals(activeTab) ? "active" : "" %>" href="account.jsp?tab=orders">Order History</a></li>
        <li class="nav-item"><a class="nav-link <%= "addresses".equals(activeTab) ? "active" : "" %>" href="account.jsp?tab=addresses">Saved Addresses</a></li>
        <li class="nav-item"><a class="nav-link <%= "wishlist".equals(activeTab) ? "active" : "" %>" href="account.jsp?tab=wishlist">Wishlist</a></li>
      </ul>

      <% if ("profile".equals(activeTab)) { %>
        <% if (userId != null) { %>
          <div class="border border-vera p-4" style="max-width:520px;">
            <div class="font-display ls-wide text-muted-vera mb-2" style="font-size:10px;">Client Profile</div>
            <h2 class="font-display ls-editorial fs-5 fw-normal mb-3"><%= userName %></h2>
            <div class="small text-muted-vera mb-1">Email: <span class="text-black"><%= userEmail %></span></div>
            <div class="small text-muted-vera mb-1">Mobile: <span class="text-black font-mono-num"><%= userPhone %></span></div>
            <div class="small text-muted-vera">City: <span class="text-black"><%= userCity %></span></div>
          </div>
        <% } else { %>
          <div class="row g-5">
            <div class="col-lg-5">
              <div class="border border-vera p-4">
                <h2 class="font-display ls-editorial fs-6 mb-3">Sign In</h2>
                <form action="LoginServlet" method="post">
                  <div class="mb-3">
                    <label class="form-label font-display ls-editorial small">Email</label>
                    <input type="email" name="email" class="form-control" value="ananya.sharma@example.in" required />
                  </div>
                  <div class="mb-3">
                    <label class="form-label font-display ls-editorial small">Password</label>
                    <input type="password" name="password" class="form-control" value="vera2026" required />
                  </div>
                  <button type="submit" class="btn btn-vera-primary w-100">Sign In</button>
                </form>
              </div>
            </div>

            <div class="col-lg-6">
              <div class="border border-vera p-4">
                <h2 class="font-display ls-editorial fs-6 mb-3">Create Client Account</h2>
                <form action="RegisterServlet" method="post">
                  <div class="row g-3">
                    <div class="col-md-6"><label class="form-label font-display ls-editorial small">Full Name</label><input type="text" name="name" class="form-control" required /></div>
                    <div class="col-md-6"><label class="form-label font-display ls-editorial small">City</label><input type="text" name="city" class="form-control" required /></div>
                    <div class="col-md-6"><label class="form-label font-display ls-editorial small">Email</label><input type="email" name="email" class="form-control" required /></div>
                    <div class="col-md-6"><label class="form-label font-display ls-editorial small">Mobile (+91)</label><input type="text" name="phone" class="form-control font-mono-num" required /></div>
                    <div class="col-12"><label class="form-label font-display ls-editorial small">Password</label><input type="password" name="password" class="form-control" required /></div>
                  </div>
                  <button type="submit" class="btn btn-vera-outline w-100 mt-4">Register Account</button>
                </form>
              </div>
            </div>
          </div>
        <% } %>
      <% } else if ("orders".equals(activeTab)) { %>
        <%
          try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps;
            if (userEmail != null) {
              ps = con.prepareStatement("SELECT * FROM orders WHERE customer_email = ? ORDER BY id DESC");
              ps.setString(1, userEmail);
            } else {
              ps = con.prepareStatement("SELECT * FROM orders ORDER BY id DESC LIMIT 10");
            }
            ResultSet rs = ps.executeQuery();
            boolean any = false;
            while (rs.next()) {
              any = true;
              int oid = rs.getInt("id");
              String st = rs.getString("status");
        %>
        <div class="border border-vera p-4 mb-3">
          <div class="d-flex flex-wrap justify-content-between align-items-center border-bottom border-vera pb-3 mb-3">
            <div>
              <span class="font-mono-num fw-medium me-3"><%= rs.getString("order_code") %></span>
              <span class="small text-muted-vera"><%= rs.getString("created_at") %> · <%= rs.getString("payment_method") %></span>
            </div>
            <div class="d-flex align-items-center gap-4">
              <span class="status-label status-<%= st.toLowerCase() %>"><%= st %></span>
              <span class="font-mono-num fw-medium">₹ <%= String.format("%,.2f", rs.getDouble("total_amount")) %></span>
            </div>
          </div>
          <%
            PreparedStatement ips = con.prepareStatement("SELECT * FROM order_items WHERE order_id = ?");
            ips.setInt(1, oid);
            ResultSet irs = ips.executeQuery();
            while (irs.next()) {
          %>
          <div class="d-flex justify-content-between small py-1">
            <span><%= irs.getString("product_name") %> (<%= irs.getString("size") %>) × <%= irs.getInt("quantity") %></span>
            <span class="font-mono-num">₹ <%= String.format("%,.2f", irs.getDouble("price") * irs.getInt("quantity")) %></span>
          </div>
          <% } %>
          <div class="small text-muted-vera mt-3 pt-2 border-top border-vera">
            Deliver to: <%= rs.getString("customer_name") %>, <%= rs.getString("address") %>, <%= rs.getString("city") %> — <%= rs.getString("pin_code") %>
          </div>
        </div>
        <%
            }
            if (!any) {
        %>
          <div class="border border-vera p-5 text-center small text-muted-vera">No orders found yet.</div>
        <%
            }
            con.close();
          } catch (Exception e) {
        %>
          <div class="alert alert-danger small">Database error: <%= e.getMessage() %></div>
        <%
          }
        %>
      <% } else if ("addresses".equals(activeTab)) { %>
        <% if (userId == null) { %>
          <div class="border border-vera p-4 small text-muted-vera">Please sign in to manage your saved Indian addresses.</div>
        <% } else { %>
          <div class="row g-4 mb-4">
            <%
              try {
                Connection con = DBConnection.getConnection();
                PreparedStatement aps = con.prepareStatement("SELECT * FROM addresses WHERE user_id = ?");
                aps.setInt(1, userId);
                ResultSet ars = aps.executeQuery();
                while (ars.next()) {
            %>
            <div class="col-md-6">
              <div class="border border-vera p-4">
                <div class="font-display ls-editorial small fw-medium mb-2"><%= ars.getString("label") %></div>
                <div class="small text-muted-vera"><%= ars.getString("line1") %></div>
                <div class="small text-muted-vera"><%= ars.getString("city") %>, <%= ars.getString("state") %> — <span class="font-mono-num"><%= ars.getString("pin_code") %></span></div>
                <div class="small text-muted-vera font-mono-num mt-1"><%= ars.getString("phone") %></div>
                <form action="AddressServlet" method="post" class="mt-3 pt-2 border-top border-vera">
                  <input type="hidden" name="action" value="delete" />
                  <input type="hidden" name="addressId" value="<%= ars.getInt("id") %>" />
                  <button type="submit" class="btn btn-link text-danger p-0 small text-decoration-underline">Remove Address</button>
                </form>
              </div>
            </div>
            <%
                }
                con.close();
              } catch (Exception e) {}
            %>
          </div>

          <div class="border border-vera p-4" style="max-width:640px;">
            <h3 class="font-display ls-editorial fs-6 mb-3">Add New Indian Address</h3>
            <form action="AddressServlet" method="post" class="row g-3">
              <div class="col-md-6"><input type="text" name="label" class="form-control" placeholder="Label (e.g. Home)" required /></div>
              <div class="col-md-6"><input type="text" name="phone" class="form-control font-mono-num" placeholder="+91 98201 00000" required /></div>
              <div class="col-12"><input type="text" name="line1" class="form-control" placeholder="Street Address / Landmark" required /></div>
              <div class="col-md-4"><input type="text" name="city" class="form-control" placeholder="City" required /></div>
              <div class="col-md-4"><input type="text" name="state" class="form-control" placeholder="State" required /></div>
              <div class="col-md-4"><input type="text" name="pinCode" maxlength="6" class="form-control font-mono-num" placeholder="PIN (6 digits)" required /></div>
              <div class="col-12"><button type="submit" class="btn btn-vera-primary">Save Address</button></div>
            </form>
          </div>
        <% } %>
      <% } else if ("wishlist".equals(activeTab)) { %>
        <div class="row g-4">
          <%
            try {
              Connection con = DBConnection.getConnection();
              PreparedStatement wps = con.prepareStatement(
                  "SELECT p.* FROM wishlist w JOIN products p ON w.product_id = p.id WHERE w.session_key = ?");
              wps.setString(1, sessionKey);
              ResultSet wrs = wps.executeQuery();
              boolean any = false;
              while (wrs.next()) {
                any = true;
                int pid = wrs.getInt("id");
          %>
          <div class="col-6 col-md-3">
            <article class="vera-product-card">
              <div class="vera-product-media">
                <a href="product-detail.jsp?id=<%= pid %>" class="d-block w-100 h-100"><img src="<%= wrs.getString("image_url") %>" alt="<%= wrs.getString("name") %>" /></a>
              </div>
              <div class="vera-product-meta">
                <div class="vera-product-kicker"><%= wrs.getString("category") %></div>
                <a href="product-detail.jsp?id=<%= pid %>" class="vera-product-title"><%= wrs.getString("name") %></a>
                <div class="vera-product-price">₹ <%= String.format("%,.2f", wrs.getDouble("price")) %></div>
                <form action="WishlistServlet" method="post" class="mt-2">
                  <input type="hidden" name="productId" value="<%= pid %>" />
                  <input type="hidden" name="redirect" value="account.jsp?tab=wishlist" />
                  <button type="submit" class="btn btn-vera-subtle py-1 px-2">Remove</button>
                </form>
              </div>
            </article>
          </div>
          <%
              }
              if (!any) {
          %>
            <div class="col-12"><div class="border border-vera p-5 text-center small text-muted-vera">Your wishlist is empty.</div></div>
          <%
              }
              con.close();
            } catch (Exception e) {}
          %>
        </div>
      <% } %>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
