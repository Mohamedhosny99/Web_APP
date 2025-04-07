package org.example.demo;

import com.twilio.exception.AuthenticationException;
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
        System.out.println(accountSid+" this is sid Line 32");
        if (accountSid == null || senderId == null || authToken == null) {
            response.sendRedirect("smsSend.jsp?error=Twilio credentials not found. Please verify your phone number.");
            return;
        }

        int smsId = -1; // Variable to store the generated SMS ID

        try (Connection conn = DBConnection.DBconnection.getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            String smsSql = "INSERT INTO sms (user_id, from_number, to_number, body, sent_date, inbound, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement smsStmt = conn.prepareStatement(smsSql, Statement.RETURN_GENERATED_KEYS);
            smsStmt.setInt(1, userId);
            smsStmt.setString(2, senderId);
            smsStmt.setString(3, toNumber);
            smsStmt.setString(4, messageBody);
            smsStmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            smsStmt.setBoolean(6, false);
            smsStmt.setString(7, "failed");
            smsStmt.executeUpdate();

            // Get the generated sms_id
            ResultSet rs = smsStmt.getGeneratedKeys();
            if (rs.next()) {
                smsId = rs.getInt(1);
                System.out.println("Generated SMS ID: " + smsId);

                // Insert into sms_belongs table
                String belongsSql = "INSERT INTO sms_belongs (sms_id, user_id) VALUES (?, ?)";
                PreparedStatement belongsStmt = conn.prepareStatement(belongsSql);
                belongsStmt.setInt(1, smsId);
                belongsStmt.setInt(2, userId);
                belongsStmt.executeUpdate();
            } else {
                throw new SQLException("Failed to get generated SMS ID.");
            }

            // Send SMS via Twilio
           TwilioVerificationServlet.sendTwilioMessage(toNumber, messageBody, authToken, accountSid, senderId);

            // Update the SMS status to "success"
            updateSmsStatus(conn, smsId, "success", messageBody);

            conn.commit(); // Commit transaction
            response.sendRedirect("home.jsp");

        } catch (AuthenticationException e) {
            System.err.println("Twilio Authentication Error: " + e.getMessage());

            // **NO database update happens here anymore**
            response.sendRedirect("smsSend.jsp?error=Failed to send SMS: Authentication error");

        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());

            // Update status to "failed" only if it's a database-related issue
            if (smsId != -1) {
                try (Connection conn = DBConnection.DBconnection.getConnection()) {
                    updateSmsStatus(conn, smsId, "failed", "Database error");
                    conn.commit();
                } catch (SQLException sqlEx) {
                    System.err.println("Failed to update SMS status: " + sqlEx.getMessage());
                }
            }

            response.sendRedirect("smsSend.jsp?error=Database error: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("General error: " + e.getMessage());

            // Update status to "failed" for any other errors (except AuthenticationException)
            if (smsId != -1) {
                try (Connection conn = DBConnection.DBconnection.getConnection()) {
                    updateSmsStatus(conn, smsId, "failed", "Sending failed due to error");
                    conn.commit();
                } catch (SQLException sqlEx) {
                    System.err.println("Failed to update SMS status: " + sqlEx.getMessage());
                }
            }

            response.sendRedirect("smsSend.jsp?error=Failed to send SMS: " + e.getMessage());
        }
    }

    private void updateSmsStatus(Connection conn, int smsId, String status, String body) throws SQLException {
        String updateSql = "UPDATE sms SET status = ?, body = ? WHERE sms_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
            stmt.setString(1, status);
            stmt.setString(2, body);
            stmt.setInt(3, smsId);
            stmt.executeUpdate();
            System.out.println("Updated SMS ID " + smsId + " to status: " + status);
        }
    }
}
