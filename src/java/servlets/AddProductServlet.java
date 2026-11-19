package servlets;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AddProductServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sku = request.getParameter("sku");
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String colorName = request.getParameter("colorName");
        String description = request.getParameter("description");

        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO products (sku, name, category, price, stock, color_name, description) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, sku);
            ps.setString(2, name);
            ps.setString(3, category);
            ps.setDouble(4, price);
            ps.setInt(5, stock);
            ps.setString(6, colorName);
            ps.setString(7, description);
            ps.executeUpdate();
            con.close();
            response.sendRedirect("products.jsp?added=1");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add-product.jsp?error=1");
        }
    }
}
