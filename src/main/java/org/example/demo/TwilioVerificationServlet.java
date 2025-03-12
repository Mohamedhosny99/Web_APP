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

import com.twilio.Twilio;
import com.twilio.exception.AuthenticationException; // Correct import
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
                System.out.println("Verification code: "+verificationCode);
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

                        // Store Twilio credentials in the session
                        session.setAttribute("twilio_account_sid", accountSid);
                        session.setAttribute("twilio_sender_id", senderId);
                        session.setAttribute("twilio_auth_token", token);

                        // Send the verification code via Twilio
                        String message = "Your verification code is: " + verificationCode;
                        sendTwilioMessage(phone, message, token, accountSid, senderId);
                        response.sendRedirect("verificationCode.jsp?phone=" + phone);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "No Twilio credentials found for this user");
                    }
                }
            } catch (SQLException e) {
                System.err.println("Database error: " + e.getMessage());
                response.sendRedirect("home.jsp?error=Database error: " + e.getMessage());
            } catch (AuthenticationException e) { // Correct exception
                System.err.println("Error sending Twilio message: " + e.getMessage());
                response.sendRedirect("home.jsp?error=Trial ended");
            } catch (Exception e) {
                System.err.println("Error sending verification code: " + e.getMessage());
                response.sendRedirect("home.jsp?error=Failed to send verification code: " + e.getMessage());
            }
        } else if ("verifyCode".equals(action)) {
            String userCode = request.getParameter("code");
            String sessionCode = (String) session.getAttribute("verificationCode");

            if (sessionCode != null && sessionCode.equals(userCode)) {
                try (Connection conn = DBConnection.DBconnection.getConnection()) {
                    String sql = "SELECT twilio_account_sid, twilio_sender_id, twilio_auth_token FROM customer WHERE user_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, userId);
                    ResultSet rs = stmt.executeQuery();

                    if (rs.next()) {
                        String accountSid = rs.getString("twilio_account_sid");
                        String senderId = rs.getString("twilio_sender_id");
                        String token = rs.getString("twilio_auth_token");

                        // Send a confirmation message
                        sendTwilioMessage(phone, "Hello! Your number has been verified. This is your Twilio message.", token, accountSid, senderId);
                        response.sendRedirect("smsSend.jsp");
                    }
                } catch (SQLException e) {
                    System.err.println("Database error: " + e.getMessage());
                    response.sendRedirect("home.jsp?error=Database error: " + e.getMessage());
                } catch (AuthenticationException e) { // Correct exception
                    System.err.println("Error sending Twilio message: " + e.getMessage());
                    response.sendRedirect("home.jsp?error=Failed to send Twilio message: Authentication error");
                } catch (Exception e) {
                    System.err.println("Error sending verification code: " + e.getMessage());
                    response.sendRedirect("home.jsp?error=Failed to send verification code: " + e.getMessage());
                }
            } else {
                response.getWriter().println("Invalid verification code. Please try again.");
            }
        }
    }

    static void sendTwilioMessage(String to, String messageBody, String token, String accountSid, String senderID) throws AuthenticationException {
        try {
            // Initialize Twilio
            Twilio.init(accountSid, token);

            // Send message
            Message message = Message.creator(
                    new PhoneNumber(to),
                    new PhoneNumber(senderID),
                    messageBody
            ).create();

            System.out.println("Message sent successfully with SID: " + message.getSid());
        } catch (AuthenticationException e) {
            System.err.println("Authentication error sending Twilio message: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            System.err.println("Error sending Twilio message: " + e.getMessage());
            throw new RuntimeException("Failed to send Twilio message", e);
        }
    }
}