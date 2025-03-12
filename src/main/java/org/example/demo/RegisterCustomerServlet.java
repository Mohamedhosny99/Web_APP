package org.example.demo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterCustomerServlet")
public class RegisterCustomerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String job = request.getParameter("role");
        String birthdayStr = request.getParameter("birthday"); // Get birthday as String
        String address = request.getParameter("address");
        String twilioSID = request.getParameter("twilioSID");
        String twilioToken = request.getParameter("twilioToken");
        String senderID = request.getParameter("senderID");

        // Validate and convert birthday String to java.sql.Date
        Date birthday;
        try {
            birthday = Date.valueOf(birthdayStr); // Convert to java.sql.Date
        } catch (IllegalArgumentException e) {
            // Handle invalid date format
            response.sendRedirect("customer_register.jsp?error=Invalid date format. Use yyyy-MM-dd.");
            return;
        }

        System.out.println("Received values:");
        System.out.println("Full Name: " + username);
        System.out.println("Email: " + email);
        System.out.println("Password: " + password);
        System.out.println("Phone: " + phone);
        System.out.println("Job: " + job);
        System.out.println("Birthday: " + birthday);
        System.out.println("Address: " + address);
        System.out.println("Twilio SID: " + twilioSID);
        System.out.println("Twilio Token: " + twilioToken);
        System.out.println("Sender ID: " + senderID);

        try (Connection conn = DBConnection.DBconnection.getConnection()) {
            String sql = "INSERT INTO customer(email, phone_number, username, address, job, birthday, password, " +
                    "twilio_account_sid, twilio_sender_id, twilio_auth_token) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, phone);
            stmt.setString(3, username);
            stmt.setString(4, address);
            stmt.setString(5, job);
            stmt.setDate(6, birthday); // Use setDate for the birthday field
            stmt.setString(7, password);
            stmt.setString(8, twilioSID);
            stmt.setString(9, senderID);
            stmt.setString(10, twilioToken);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                response.sendRedirect("login.jsp?message=Registration successful");
            } else {
                response.sendRedirect("customer_register.jsp?error=Registration failed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("customer_register.jsp?error=Database error: " + e.getMessage());
        }
    }
}