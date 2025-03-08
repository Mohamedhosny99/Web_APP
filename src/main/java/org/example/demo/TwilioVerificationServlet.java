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

import javax.servlet.ServletException;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;

@WebServlet("/TwilioVerificationServlet")
public class TwilioVerificationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        String phone = request.getParameter("phone");
        Integer userId = session.getAttribute("userId") != null ? (Integer) session.getAttribute("userId") : null;
        
        System.out.println("Action: " + action);
        System.out.println("Phone: " + phone);
        System.out.println("UserID: " + userId);

        if (action == null || phone == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action and phone parameters are required");
            return;
        }

        if ("sendCode".equals(action)) {
            try {
                // Generate a 4-digit random verification code
                int verificationCode = (int) (Math.random() * 9000) + 1000;
                session.setAttribute("verificationCode", String.valueOf(verificationCode));
                session.setAttribute("phone", phone);

                // Send verification code via Twilio
                try (Connection conn = DBConnection.DBconnection.getConnection()) {
                    if (userId == null) {
                        throw new SQLException("User ID is required");
                    }

                    String sql = "SELECT twilio_account_sid, twilio_sender_id, twilio_auth_token FROM customer WHERE user_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, userId);
                    ResultSet rs = stmt.executeQuery();

                    if (rs.next()) {
                        String accountSid = rs.getString("twilio_account_sid");
                        String senderId = rs.getString("twilio_sender_id");
                        String token = rs.getString("twilio_auth_token");

                        // Validate Twilio credentials
                        if (accountSid == null || senderId == null || token == null) {
                            throw new SQLException("Invalid Twilio credentials in database");
                        }

                        String message = "Your verification code is: " + verificationCode;
                        sendTwilioMessage(phone, message, token, accountSid, senderId);
                        response.sendRedirect("verificationCode.jsp?phone=" + phone);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "No Twilio credentials found for this user");
                    }
                }
            } catch (SQLException e) {
                System.err.println("Database error: " + e.getMessage());
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
            } catch (Exception e) {
                System.err.println("Error sending verification code: " + e.getMessage());
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error sending verification code: " + e.getMessage());
            }
        } else if ("verifyCode".equals(action)) {
            String userCode = request.getParameter("code");
            String sessionCode = (String) session.getAttribute("verificationCode");
            System.out.println("Code: " + sessionCode);
            if (sessionCode != null && sessionCode.equals(userCode)) {
                if (!phone.startsWith("+")) {
                    phone = phone.trim();
                    phone = "+".concat(phone);
                }
                try (Connection conn = DBConnection.DBconnection.getConnection()) {
                    String sql = "SELECT twilio_account_sid, twilio_sender_id, twilio_auth_token FROM customer WHERE user_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, userId);
                    ResultSet rs = stmt.executeQuery();

                    if (rs.next()) {
                        String accountSid = rs.getString("twilio_account_sid");
                        String senderId = rs.getString("twilio_sender_id");
                        String token = rs.getString("twilio_auth_token");
                        sendTwilioMessage(phone, "Hello! Your number has been verified. This is your Twilio message.", token, accountSid, senderId);
                        response.getWriter().println("Message sent successfully!");
                    }
                } catch (SQLException e) {
                    System.err.println("Database error: " + e.getMessage());
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
                }
            } else {
                response.getWriter().println("Invalid verification code. Please try again.");
            }
        }
    }

    void sendTwilioMessage(String to, String messageBody, String tokin, String accSID, String senderID) {
        try {
            // Validate all required parameters
            if (to == null || messageBody == null || tokin == null || accSID == null || senderID == null) {
                throw new IllegalArgumentException("All parameters must not be null. Values: " +
                    "to=" + to + ", messageBody=" + messageBody + 
                    ", token=" + (tokin != null ? "[PRESENT]" : "null") + 
                    ", accountSID=" + (accSID != null ? "[PRESENT]" : "null") + 
                    ", senderID=" + senderID);
            }

            // Ensure phone number format
            if (!to.startsWith("+")) {
                to = "+" + to.trim();
            }

            // Initialize Twilio
            Twilio.init(accSID, tokin);

            // Send message
            Message message = Message.creator(
                    new PhoneNumber(to),
                    new PhoneNumber(senderID),
                    messageBody
            ).create();

            System.out.println("Message sent successfully with SID: " + message.getSid());
        } catch (Exception e) {
            System.err.println("Error sending Twilio message: " + e.getMessage());
            throw e; // Re-throw to be handled by caller
        }
    }
}