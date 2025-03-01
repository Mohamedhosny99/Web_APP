package org.example.demo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterUserServlet")
public class RegisterUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        System.out.println("Received values:");
        System.out.println("Username: " + username);
        System.out.println("Email: " + email);
        System.out.println("Password: " + password);
        System.out.println("Phone: " + phone);
        System.out.println("Role: " + role);

        try (Connection conn = DBConnection.DBconnection.getConnection()) {
            // Insert into users table
            String userSql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?) RETURNING id";
            PreparedStatement userStmt = conn.prepareStatement(userSql);
            userStmt.setString(1, username);
            userStmt.setString(2, password);  // Hash passwords in real applications!
            userStmt.setString(3, role);

            ResultSet rs = userStmt.executeQuery();
            int userId = -1;
            if (rs.next()) {
                userId = rs.getInt("id");
            }

            if (userId > 0 && "customer".equals(role)) {
                // Insert into customers table if the user is a customer
                String customerSql = "INSERT INTO customers (user_id, name, email, phone) VALUES (?, ?, ?, ?)";
                PreparedStatement customerStmt = conn.prepareStatement(customerSql);
                customerStmt.setInt(1, userId);
                customerStmt.setString(2, username);
                customerStmt.setString(3, email);
                customerStmt.setString(4, phone);

                customerStmt.executeUpdate();
            }

            response.sendRedirect("login.jsp?message=Registration successful");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=Database error");
        }
    }
}