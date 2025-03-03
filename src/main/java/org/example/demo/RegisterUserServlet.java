package org.example.demo;

import java.io.IOException;
import java.sql.*;
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
        //customer
        String job = request.getParameter("job");
        String birthday = request.getParameter("birthday");
        String address = request.getParameter("address");
        String userId = request.getParameter("user_id");


        System.out.println("Received values:");
        System.out.println("Username: " + username);
        System.out.println("Email: " + email);
        System.out.println("Password: " + password);
        System.out.println("Phone: " + phone);
        System.out.println("Job: " + job);
        System.out.println("Birthday: " + birthday);
        System.out.println("Address: " + address);
        System.out.println("User ID: " + userId);

        try (Connection conn = DBConnection.DBconnection.getConnection()) {

                // Insert into customers table if the user is a customer
                String customerSql = "INSERT INTO customer (user_id, phone_number, job, birthday, address, username) VALUES (?, ?, ?, ?, ?,?)";
                PreparedStatement customerStmt = conn.prepareStatement(customerSql);
                customerStmt.setInt(1, Integer.parseInt(userId));
                customerStmt.setString(2, phone);
                customerStmt.setString(3, job);
                customerStmt.setDate(4, Date.valueOf(birthday));
                customerStmt.setString(5, address);
                customerStmt.setString(6, username);



                customerStmt.executeUpdate();

            response.sendRedirect("login.jsp?message=Registration successful");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("customer_register.jsp?error=Database error");
        }
    }
}