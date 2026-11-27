package servlets;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AddressServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("userId") == null) {
            response.sendRedirect("account.jsp");
            return;
        }

        int userId = Integer.parseInt(session.getAttribute("userId").toString());
        String action = request.getParameter("action");

        try {
            Connection con = DBConnection.getConnection();
            if ("delete".equals(action)) {
                int addrId = Integer.parseInt(request.getParameter("addressId"));
                PreparedStatement del = con.prepareStatement("DELETE FROM addresses WHERE id = ? AND user_id = ?");
                del.setInt(1, addrId);
                del.setInt(2, userId);
                del.executeUpdate();
            } else {
                String label = request.getParameter("label");
                String line1 = request.getParameter("line1");
                String city = request.getParameter("city");
                String state = request.getParameter("state");
                String pinCode = request.getParameter("pinCode");
                String phone = request.getParameter("phone");

                PreparedStatement ins = con.prepareStatement(
                        "INSERT INTO addresses (user_id, label, line1, city, state, pin_code, phone) VALUES (?, ?, ?, ?, ?, ?, ?)");
                ins.setInt(1, userId);
                ins.setString(2, label);
                ins.setString(3, line1);
                ins.setString(4, city);
                ins.setString(5, state);
                ins.setString(6, pinCode);
                ins.setString(7, phone);
                ins.executeUpdate();
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("account.jsp?tab=addresses");
    }
}
