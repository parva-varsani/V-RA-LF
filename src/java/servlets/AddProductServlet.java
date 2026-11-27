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

        String idParam = request.getParameter("id");
        String sku = request.getParameter("sku");
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String colorName = request.getParameter("colorName");
        String colorHex = request.getParameter("colorHex");
        String[] sizeValues = request.getParameterValues("sizes");
        String sizes = "ONE SIZE";
        if (sizeValues != null && sizeValues.length > 0) {
            sizes = String.join(",", sizeValues);
        }
        String imageUrl = request.getParameter("imageUrl");
        String description = request.getParameter("description");
        String composition = request.getParameter("composition");

        try {
            Connection con = DBConnection.getConnection();
            if (idParam != null && !idParam.trim().isEmpty()) {
                int id = Integer.parseInt(idParam);
                PreparedStatement ps = con.prepareStatement(
                        "UPDATE products SET sku=?, name=?, category=?, price=?, stock=?, color_name=?, color_hex=?, sizes=?, image_url=?, description=?, composition=? WHERE id=?");
                ps.setString(1, sku);
                ps.setString(2, name);
                ps.setString(3, category);
                ps.setDouble(4, price);
                ps.setInt(5, stock);
                ps.setString(6, colorName);
                ps.setString(7, colorHex);
                ps.setString(8, sizes);
                ps.setString(9, imageUrl);
                ps.setString(10, description);
                ps.setString(11, composition);
                ps.setInt(12, id);
                ps.executeUpdate();
            } else {
                PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO products (sku, name, category, price, stock, color_name, color_hex, sizes, image_url, description, composition) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                ps.setString(1, sku);
                ps.setString(2, name);
                ps.setString(3, category);
                ps.setDouble(4, price);
                ps.setInt(5, stock);
                ps.setString(6, colorName);
                ps.setString(7, colorHex);
                ps.setString(8, sizes);
                ps.setString(9, imageUrl);
                ps.setString(10, description);
                ps.setString(11, composition);
                ps.executeUpdate();
            }
            con.close();
            response.sendRedirect("admin-products.jsp?saved=1");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-add-product.jsp?error=1");
        }
    }
}
