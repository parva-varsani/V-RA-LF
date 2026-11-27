<%@ page import="java.sql.*, java.util.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String sessionKey = session.getAttribute("userEmail") != null ? session.getAttribute("userEmail").toString() : session.getId();
  String promoCode = session.getAttribute("promoCode") != null ? session.getAttribute("promoCode").toString() : "";
  String userName = session.getAttribute("userName") != null ? session.getAttribute("userName").toString() : "";
  String userEmail = session.getAttribute("userEmail") != null ? session.getAttribute("userEmail").toString() : "";
  String userPhone = session.getAttribute("userPhone") != null ? session.getAttribute("userPhone").toString() : "";
  String userCity = session.getAttribute("userCity") != null ? session.getAttribute("userCity").toString() : "";
  String placedOrderCode = request.getParameter("orderCode");

  List<Map<String, Object>> cartItems = new ArrayList<Map<String, Object>>();
  double subtotal = 0;
  int totalQty = 0;

  try {
    Connection con = DBConnection.getConnection();
    PreparedStatement ps = con.prepareStatement(
        "SELECT c.id AS cart_id, c.product_id, c.size, c.quantity, p.name, p.price, p.color_name, p.image_url FROM cart c JOIN products p ON c.product_id = p.id WHERE c.session_key = ?");
    ps.setString(1, sessionKey);
    ResultSet rs = ps.executeQuery();
    while (rs.next()) {
      Map<String, Object> row = new HashMap<String, Object>();
      row.put("cartId", rs.getInt("cart_id"));
      row.put("productId", rs.getInt("product_id"));
      row.put("size", rs.getString("size"));
      row.put("qty", rs.getInt("quantity"));
      row.put("name", rs.getString("name"));
      row.put("price", rs.getDouble("price"));
      row.put("color", rs.getString("color_name"));
      row.put("image", rs.getString("image_url"));
      subtotal += rs.getDouble("price") * rs.getInt("quantity");
      totalQty += rs.getInt("quantity");
      cartItems.add(row);
    }
    con.close();
  } catch (Exception e) {
  }

  double discount = 0;
  if ("VERA10".equals(promoCode)) discount = Math.round(subtotal * 0.10);
  else if ("FIRST15".equals(promoCode)) discount = Math.round(subtotal * 0.15);

  double taxable = Math.max(0, subtotal - discount);
  double gst = Math.round((taxable * 12.0) / 112.0);
  double shipping = (taxable == 0 || taxable >= 5000) ? 0 : 250;
  double total = taxable + shipping;
%>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VÉRA — Shopping Bag &amp; Checkout</title>
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
        <a href="cart.jsp" class="vera-icon-btn"><i class="bi bi-bag"></i><span>Bag (<%= totalQty %>)</span></a>
      </div>
    </header>

    <main class="container-fluid px-3 px-md-5 py-4">
      <div class="border-bottom border-vera pb-3 mb-4 d-flex justify-content-between align-items-end">
        <div>
          <div class="font-display ls-wide text-muted-vera" style="font-size:10px;">India Checkout · INR (₹)</div>
          <h1 class="font-display ls-editorial fs-4 fw-normal mb-0 mt-1">Shopping Bag</h1>
        </div>
        <a href="products.jsp" class="font-display ls-editorial text-black text-decoration-none" style="font-size:11px;">Continue Shopping</a>
      </div>

      <% if (placedOrderCode != null && !placedOrderCode.isEmpty()) { %>
        <div class="border border-vera p-4 p-md-5 mb-5">
          <div class="font-display ls-wide status-delivered small mb-2">Order Confirmed</div>
          <h2 class="font-display ls-editorial fs-4 fw-normal mb-2">Thank You For Your Order</h2>
          <p class="small text-muted-vera mb-4">Order <strong class="font-mono-num text-black"><%= placedOrderCode %></strong> has been saved in MySQL and is now Processing.</p>
          <a href="account.jsp?tab=orders" class="btn btn-vera-primary me-2">View Order History</a>
          <a href="products.jsp" class="btn btn-vera-outline">Continue Shopping</a>
        </div>
      <% } %>

      <div class="row g-5">
        <div class="col-12 col-lg-8">
          <% if (cartItems.isEmpty()) { %>
            <div class="border border-vera p-5 text-center">
              <p class="font-display ls-editorial mb-3">Your Shopping Bag Is Empty</p>
              <a href="products.jsp" class="btn btn-vera-primary">Explore Collections</a>
            </div>
          <% } else { %>
            <div class="mb-5">
              <% for (Map<String, Object> item : cartItems) {
                   int cId = (Integer) item.get("cartId");
                   int pId = (Integer) item.get("productId");
                   int qty = (Integer) item.get("qty");
                   double price = (Double) item.get("price");
              %>
              <div class="border border-vera p-3 mb-3 d-flex gap-3 align-items-center">
                <a href="product-detail.jsp?id=<%= pId %>" style="width:86px;aspect-ratio:3/4;overflow:hidden;border:1px solid #e5e5e5;">
                  <img src="<%= item.get("image") %>" alt="<%= item.get("name") %>" class="w-100 h-100 object-fit-cover" />
                </a>
                <div class="flex-fill">
                  <div class="font-display ls-editorial small mb-1"><%= item.get("name") %></div>
                  <div class="small text-muted-vera mb-2">Size: <%= item.get("size") %> · Colour: <%= item.get("color") %></div>
                  <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
                    <div class="d-inline-flex align-items-center border border-vera">
                      <form action="CartServlet" method="post" class="d-inline">
                        <input type="hidden" name="action" value="decrease" />
                        <input type="hidden" name="cartId" value="<%= cId %>" />
                        <button type="submit" class="btn btn-sm px-3">−</button>
                      </form>
                      <span class="font-mono-num px-2"><%= qty %></span>
                      <form action="CartServlet" method="post" class="d-inline">
                        <input type="hidden" name="action" value="increase" />
                        <input type="hidden" name="cartId" value="<%= cId %>" />
                        <button type="submit" class="btn btn-sm px-3">+</button>
                      </form>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                      <span class="font-mono-num small">₹ <%= String.format("%,.2f", price * qty) %></span>
                      <form action="CartServlet" method="post" class="d-inline">
                        <input type="hidden" name="action" value="remove" />
                        <input type="hidden" name="cartId" value="<%= cId %>" />
                        <button type="submit" class="btn btn-link text-muted-vera p-0 small text-decoration-underline">Remove</button>
                      </form>
                    </div>
                  </div>
                </div>
              </div>
              <% } %>
            </div>

            <div class="border border-vera p-4">
              <h2 class="font-display ls-editorial fs-6 fw-normal border-bottom border-vera pb-3 mb-4">Delivery &amp; Payment (India)</h2>
              <form action="PlaceOrderServlet" method="post">
                <div class="row g-3">
                  <div class="col-md-6">
                    <label class="form-label font-display ls-editorial small">Full Name</label>
                    <input type="text" name="customerName" class="form-control" value="<%= userName %>" required />
                  </div>
                  <div class="col-md-6">
                    <label class="form-label font-display ls-editorial small">Email</label>
                    <input type="email" name="customerEmail" class="form-control" value="<%= userEmail %>" required />
                  </div>
                  <div class="col-md-6">
                    <label class="form-label font-display ls-editorial small">Mobile (+91)</label>
                    <input type="text" name="phone" class="form-control font-mono-num" value="<%= userPhone %>" required />
                  </div>
                  <div class="col-md-6">
                    <label class="form-label font-display ls-editorial small">PIN Code (6 Digits)</label>
                    <input type="text" name="pinCode" maxlength="6" class="form-control font-mono-num" required placeholder="400026" />
                  </div>
                  <div class="col-12">
                    <label class="form-label font-display ls-editorial small">Street Address</label>
                    <input type="text" name="address" class="form-control" required />
                  </div>
                  <div class="col-md-4">
                    <label class="form-label font-display ls-editorial small">City</label>
                    <input type="text" name="city" class="form-control" value="<%= userCity %>" required />
                  </div>
                  <div class="col-md-4">
                    <label class="form-label font-display ls-editorial small">State</label>
                    <select name="state" class="form-select">
                      <option value="Maharashtra">Maharashtra</option>
                      <option value="Delhi">Delhi</option>
                      <option value="Karnataka">Karnataka</option>
                      <option value="Gujarat">Gujarat</option>
                      <option value="Telangana">Telangana</option>
                      <option value="Tamil Nadu">Tamil Nadu</option>
                      <option value="West Bengal">West Bengal</option>
                    </select>
                  </div>
                  <div class="col-md-4">
                    <label class="form-label font-display ls-editorial small">Payment Method</label>
                    <select name="paymentMethod" class="form-select">
                      <option value="UPI">UPI</option>
                      <option value="Card">Credit / Debit Card</option>
                      <option value="COD">Cash on Delivery (COD)</option>
                    </select>
                  </div>
                </div>
                <div class="mt-4 text-end">
                  <button type="submit" class="btn btn-vera-primary px-5">Place Order</button>
                </div>
              </form>
            </div>
          <% } %>
        </div>

        <div class="col-12 col-lg-4">
          <div class="border border-vera p-4">
            <div class="font-display ls-editorial fs-6 border-bottom border-vera pb-3 mb-3">Order Summary</div>

            <form action="CartServlet" method="post" class="mb-4">
              <input type="hidden" name="action" value="promo" />
              <label class="form-label font-display ls-editorial text-muted-vera" style="font-size:10px;">Promo Code (VERA10 or FIRST15)</label>
              <div class="input-group">
                <input type="text" name="promoCode" value="<%= promoCode %>" class="form-control text-uppercase" placeholder="ENTER CODE" />
                <button type="submit" class="btn btn-vera-outline">Apply</button>
              </div>
            </form>

            <div class="d-flex flex-column gap-2 small pb-3 border-bottom border-vera">
              <div class="d-flex justify-content-between"><span class="text-muted-vera">Subtotal</span><span class="font-mono-num">₹ <%= String.format("%,.2f", subtotal) %></span></div>
              <% if (discount > 0) { %>
                <div class="d-flex justify-content-between text-success"><span>Discount (<%= promoCode %>)</span><span class="font-mono-num">- ₹ <%= String.format("%,.2f", discount) %></span></div>
              <% } %>
              <div class="d-flex justify-content-between"><span class="text-muted-vera">GST (12% incl.)</span><span class="font-mono-num">₹ <%= String.format("%,.2f", gst) %></span></div>
              <div class="d-flex justify-content-between"><span class="text-muted-vera">Delivery</span><span class="font-mono-num"><%= shipping == 0 ? "COMPLIMENTARY" : "₹ " + String.format("%,.2f", shipping) %></span></div>
            </div>

            <div class="d-flex justify-content-between align-items-center pt-3">
              <span class="font-display ls-editorial">Total</span>
              <span class="font-mono-num fs-5 fw-medium">₹ <%= String.format("%,.2f", total) %></span>
            </div>
          </div>
        </div>
      </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
