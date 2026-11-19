package servlets;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class PlaceOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String customerName = request.getParameter("customerName");
        String customerEmail = request.getParameter("customerEmail");
        String productName = request.getParameter("productName");
        String size = request.getParameter("size");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        double unitPrice = Double.parseDouble(request.getParameter("unitPrice"));
        double totalAmount = unitPrice * quantity;
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String pinCode = request.getParameter("pinCode");
        String paymentMethod = request.getParameter("paymentMethod");

        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO orders (customer_name, customer_email, product_name, size, quantity, total_amount, address, city, pin_code, payment_method, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, customerName);
            ps.setString(2, customerEmail);
            ps.setString(3, productName);
            ps.setString(4, size);
            ps.setInt(5, quantity);
            ps.setDouble(6, totalAmount);
            ps.setString(7, address);
            ps.setString(8, city);
            ps.setString(9, pinCode);
            ps.setString(10, paymentMethod);
            ps.setString(11, "Processing");
            ps.executeUpdate();
            con.close();
            response.sendRedirect("orders.jsp?placed=1");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("checkout.jsp?error=1");
        }
    }
}
