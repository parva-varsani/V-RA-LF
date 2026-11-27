package servlets;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String city = request.getParameter("city");

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO users (name, email, password, phone, city) VALUES (?, ?, ?, ?, ?)");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, phone);
            ps.setString(5, city);
            ps.executeUpdate();
            con.close();
            response.sendRedirect("account.jsp?registered=1");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("account.jsp?regError=1");
        }
    }
}
