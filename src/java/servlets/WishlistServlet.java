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

public class WishlistServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String sessionKey = session.getAttribute("userEmail") != null
                ? session.getAttribute("userEmail").toString()
                : session.getId();

        int productId = Integer.parseInt(request.getParameter("productId"));
        String redirect = request.getParameter("redirect");
        if (redirect == null || redirect.isEmpty()) {
            redirect = "products.jsp";
        }

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement check = con.prepareStatement("SELECT id FROM wishlist WHERE session_key = ? AND product_id = ?");
            check.setString(1, sessionKey);
            check.setInt(2, productId);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                PreparedStatement del = con.prepareStatement("DELETE FROM wishlist WHERE id = ?");
                del.setInt(1, rs.getInt("id"));
                del.executeUpdate();
            } else {
                PreparedStatement ins = con.prepareStatement("INSERT INTO wishlist (session_key, product_id) VALUES (?, ?)");
                ins.setString(1, sessionKey);
                ins.setInt(2, productId);
                ins.executeUpdate();
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(redirect);
    }
}
