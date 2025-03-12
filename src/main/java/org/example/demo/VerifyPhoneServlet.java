package org.example.demo;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/VerifyPhoneServlet")
public class VerifyPhoneServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp?error=Please login to verify your phone number.");
            return;
        }

        try (Connection conn = DBConnection.DBconnection.getConnection()) {
            // Fetch the user's phone number and Twilio credentials
            String sql = "SELECT phone_number, twilio_account_sid, twilio_sender_id, twilio_auth_token FROM customer WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String phone = rs.getString("phone_number");
                String accountSid = rs.getString("twilio_account_sid");
                String senderId = rs.getString("twilio_sender_id");
                String authToken = rs.getString("twilio_auth_token");

                // Store Twilio credentials and phone in the session
                session.setAttribute("twilio_account_sid", accountSid);
                session.setAttribute("twilio_sender_id", senderId);
                session.setAttribute("twilio_auth_token", authToken);
                session.setAttribute("phone", phone);

                // Generate a 4-digit random verification code
                int verificationCode = (int) (Math.random() * 9000) + 1000;
                System.out.println("Verification code: "+verificationCode);
                session.setAttribute("verificationCode", String.valueOf(verificationCode));

                // Send verification code via Twilio
                TwilioVerificationServlet.sendTwilioMessage(phone, "Your verification code is: " + verificationCode, authToken, accountSid, senderId);
                response.sendRedirect("verificationCode.jsp");
            } else {
                response.sendRedirect("enterPhone.jsp?error=User not found in the database.");
            }
        } catch (SQLException e) {
            response.sendRedirect("enterPhone.jsp?error=Database error: " + e.getMessage());
        } catch (Exception e) {
            response.sendRedirect("enterPhone.jsp?error=Failed to send verification code: " + e.getMessage());
        }
    }
}