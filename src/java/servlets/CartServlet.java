package servlets;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String sessionKey = session.getAttribute("userEmail") != null
                ? session.getAttribute("userEmail").toString()
                : session.getId();

        String action = request.getParameter("action");
        String redirect = request.getParameter("redirect");
        if (redirect == null || redirect.isEmpty()) {
            redirect = "cart.jsp";
        }

        try {
            Connection con = DBConnection.getConnection();

            if ("add".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                String size = request.getParameter("size");
                if (size == null || size.isEmpty()) {
                    size = "M";
                }

                PreparedStatement check = con.prepareStatement(
                        "SELECT id, quantity FROM cart WHERE session_key = ? AND product_id = ? AND size = ?");
                check.setString(1, sessionKey);
                check.setInt(2, productId);
                check.setString(3, size);
                ResultSet rs = check.executeQuery();

                if (rs.next()) {
                    int cartId = rs.getInt("id");
                    int qty = rs.getInt("quantity") + 1;
                    PreparedStatement upd = con.prepareStatement("UPDATE cart SET quantity = ? WHERE id = ?");
                    upd.setInt(1, qty);
                    upd.setInt(2, cartId);
                    upd.executeUpdate();
                } else {
                    PreparedStatement ins = con.prepareStatement(
                            "INSERT INTO cart (session_key, product_id, size, quantity) VALUES (?, ?, ?, 1)");
                    ins.setString(1, sessionKey);
                    ins.setInt(2, productId);
                    ins.setString(3, size);
                    ins.executeUpdate();
                }
            } else if ("increase".equals(action)) {
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                PreparedStatement upd = con.prepareStatement("UPDATE cart SET quantity = quantity + 1 WHERE id = ? AND session_key = ?");
                upd.setInt(1, cartId);
                upd.setString(2, sessionKey);
                upd.executeUpdate();
            } else if ("decrease".equals(action)) {
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                PreparedStatement check = con.prepareStatement("SELECT quantity FROM cart WHERE id = ? AND session_key = ?");
                check.setInt(1, cartId);
                check.setString(2, sessionKey);
                ResultSet rs = check.executeQuery();
                if (rs.next()) {
                    if (rs.getInt("quantity") <= 1) {
                        PreparedStatement del = con.prepareStatement("DELETE FROM cart WHERE id = ? AND session_key = ?");
                        del.setInt(1, cartId);
                        del.setString(2, sessionKey);
                        del.executeUpdate();
                    } else {
                        PreparedStatement upd = con.prepareStatement("UPDATE cart SET quantity = quantity - 1 WHERE id = ? AND session_key = ?");
                        upd.setInt(1, cartId);
                        upd.setString(2, sessionKey);
                        upd.executeUpdate();
                    }
                }
            } else if ("remove".equals(action)) {
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                PreparedStatement del = con.prepareStatement("DELETE FROM cart WHERE id = ? AND session_key = ?");
                del.setInt(1, cartId);
                del.setString(2, sessionKey);
                del.executeUpdate();
            } else if ("promo".equals(action)) {
                String code = request.getParameter("promoCode");
                if (code != null) {
                    code = code.trim().toUpperCase();
                }
                if ("VERA10".equals(code) || "FIRST15".equals(code)) {
                    session.setAttribute("promoCode", code);
                } else {
                    session.removeAttribute("promoCode");
                }
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(redirect);
    }
}
