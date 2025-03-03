package org.example.demo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterCustomerServlet")
public class RegisterCustomerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String job = request.getParameter("job");
        String birthday = request.getParameter("birthday");
        String address = request.getParameter("address");

        System.out.println("Received values:");
        System.out.println("Full Name: " + username);
        System.out.println("Email: " + email);
        System.out.println("Password: " + password);
        System.out.println("Phone: " + phone);
        System.out.println("Job: " + job);
        System.out.println("Birthday: " + birthday);
        System.out.println("Address: " + address);

        try (Connection conn = DBConnection.DBconnection.getConnection()) {
            String sql = "INSERT INTO customer(username, email, password, phone_number, job, address, birthday) VALUES (?, ?, ?, ?,?,?,?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.setString(3, password);  // Hash passwords in real applications!
            stmt.setString(4, phone);
            stmt.setString(5, job);
            stmt.setString(6, address);
            stmt.setDate(7, java.sql.Date.valueOf(birthday));



            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                response.sendRedirect("login.jsp?message=Registration successful");
            } else {
                response.sendRedirect("customer_register.jsp?error=Registration failed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("customer_register.jsp?error=Database error");
        }
    }
}