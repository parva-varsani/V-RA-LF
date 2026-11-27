package servlets;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class PlaceOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String sessionKey = session.getAttribute("userEmail") != null
                ? session.getAttribute("userEmail").toString()
                : session.getId();

        String customerName = request.getParameter("customerName");
        String customerEmail = request.getParameter("customerEmail");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pinCode = request.getParameter("pinCode");
        String paymentMethod = request.getParameter("paymentMethod");
        String promoCode = session.getAttribute("promoCode") != null ? session.getAttribute("promoCode").toString() : "";

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement cartPs = con.prepareStatement(
                    "SELECT c.product_id, c.size, c.quantity, p.name, p.price FROM cart c JOIN products p ON c.product_id = p.id WHERE c.session_key = ?");
            cartPs.setString(1, sessionKey);
            ResultSet rs = cartPs.executeQuery();

            double subtotal = 0;
            while (rs.next()) {
                subtotal += rs.getDouble("price") * rs.getInt("quantity");
            }

            if (subtotal <= 0) {
                con.close();
                response.sendRedirect("cart.jsp");
                return;
            }

            double discount = 0;
            if ("VERA10".equals(promoCode)) {
                discount = Math.round(subtotal * 0.10);
            } else if ("FIRST15".equals(promoCode)) {
                discount = Math.round(subtotal * 0.15);
            }

            double taxable = subtotal - discount;
            double gstAmount = Math.round((taxable * 12.0) / 112.0);
            double shippingFee = taxable >= 5000 ? 0.0 : 250.0;
            double totalAmount = taxable + shippingFee;
            String orderCode = "VR-2026-" + (1000 + (int) (Math.random() * 9000));

            PreparedStatement orderPs = con.prepareStatement(
                    "INSERT INTO orders (order_code, customer_name, customer_email, phone, address, city, state, pin_code, payment_method, promo_code, subtotal, discount, gst_amount, shipping_fee, total_amount, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Processing')",
                    Statement.RETURN_GENERATED_KEYS);
            orderPs.setString(1, orderCode);
            orderPs.setString(2, customerName);
            orderPs.setString(3, customerEmail);
            orderPs.setString(4, phone);
            orderPs.setString(5, address);
            orderPs.setString(6, city);
            orderPs.setString(7, state);
            orderPs.setString(8, pinCode);
            orderPs.setString(9, paymentMethod);
            orderPs.setString(10, promoCode);
            orderPs.setDouble(11, subtotal);
            orderPs.setDouble(12, discount);
            orderPs.setDouble(13, gstAmount);
            orderPs.setDouble(14, shippingFee);
            orderPs.setDouble(15, totalAmount);
            orderPs.executeUpdate();

            ResultSet keys = orderPs.getGeneratedKeys();
            int orderId = 0;
            if (keys.next()) {
                orderId = keys.getInt(1);
            }

            PreparedStatement itemsRead = con.prepareStatement(
                    "SELECT c.product_id, c.size, c.quantity, p.name, p.price FROM cart c JOIN products p ON c.product_id = p.id WHERE c.session_key = ?");
            itemsRead.setString(1, sessionKey);
            ResultSet itemRs = itemsRead.executeQuery();

            while (itemRs.next()) {
                int pid = itemRs.getInt("product_id");
                int qty = itemRs.getInt("quantity");

                PreparedStatement itemIns = con.prepareStatement(
                        "INSERT INTO order_items (order_id, product_id, product_name, size, price, quantity) VALUES (?, ?, ?, ?, ?, ?)");
                itemIns.setInt(1, orderId);
                itemIns.setInt(2, pid);
                itemIns.setString(3, itemRs.getString("name"));
                itemIns.setString(4, itemRs.getString("size"));
                itemIns.setDouble(5, itemRs.getDouble("price"));
                itemIns.setInt(6, qty);
                itemIns.executeUpdate();

                PreparedStatement stockUpd = con.prepareStatement(
                        "UPDATE products SET stock = GREATEST(0, stock - ?) WHERE id = ?");
                stockUpd.setInt(1, qty);
                stockUpd.setInt(2, pid);
                stockUpd.executeUpdate();
            }

            PreparedStatement clearCart = con.prepareStatement("DELETE FROM cart WHERE session_key = ?");
            clearCart.setString(1, sessionKey);
            clearCart.executeUpdate();

            session.removeAttribute("promoCode");
            con.close();
            response.sendRedirect("cart.jsp?orderCode=" + orderCode);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp?error=1");
        }
    }
}
