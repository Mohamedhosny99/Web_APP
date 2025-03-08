package org.example.demo;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

@WebServlet("/SendSmsServlet")
public class SendSmsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp?error=Please login to send SMS.");
            return;
        }

        String toNumber = request.getParameter("toNumber");
        String messageBody = request.getParameter("message");

        // Fetch Twilio credentials from the session
        String accountSid = (String) session.getAttribute("twilio_account_sid");
        String senderId = (String) session.getAttribute("twilio_sender_id");
        String authToken = (String) session.getAttribute("twilio_auth_token");

        if (accountSid == null || senderId == null || authToken == null) {
            response.sendRedirect("sendSms.jsp?error=Twilio credentials not found. Please verify your phone number.");
            return;
        }

        try (Connection conn = DBConnection.DBconnection.getConnection()) {
            // Insert into sms table
            String smsSql = "INSERT INTO sms (user_id, from_number, to_number, body, sent_date, inbound) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement smsStmt = conn.prepareStatement(smsSql, PreparedStatement.RETURN_GENERATED_KEYS);
            smsStmt.setInt(1, userId);
            smsStmt.setString(2, session.getAttribute("phone").toString());
            smsStmt.setString(3, toNumber);
            smsStmt.setString(4, messageBody);
            smsStmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            smsStmt.setBoolean(6, false); // Outbound message
            smsStmt.executeUpdate();

            // Get the generated sms_id
            ResultSet rs = smsStmt.getGeneratedKeys();
            if (rs.next()) {
                int smsId = rs.getInt(1);

                // Insert into sms_belongs table
                String belongsSql = "INSERT INTO sms_belongs (sms_id, user_id) VALUES (?, ?)";
                PreparedStatement belongsStmt = conn.prepareStatement(belongsSql);
                belongsStmt.setInt(1, smsId);
                belongsStmt.setInt(2, userId);
                belongsStmt.executeUpdate();
            }

            System.out.println("hello");

            // Send SMS via Twilio
            TwilioVerificationServlet.sendTwilioMessage(toNumber, messageBody, authToken, accountSid, senderId);
            response.sendRedirect("SmsHistoryServlet");
        } catch (SQLException e) {
            response.sendRedirect("sendSms.jsp?error=Database error: " + e.getMessage());
        } catch (IOException e) {
            response.sendRedirect("sendSms.jsp?error=Failed to send SMS: " + e.getMessage());
        }
    }
}