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
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;

@WebServlet("/TwilioVerificationServlet")
public class TwilioVerificationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        String phone = request.getParameter("phone");
        System.out.println("Action: " + action);
        System.out.println("Phone: " + phone);
        if ("sendCode".equals(action)) {
            // Generate a 4-digit random verification code
            int verificationCode = (int) (Math.random() * 9000) + 1000;
            session.setAttribute("verificationCode", String.valueOf(verificationCode));
            session.setAttribute("phone", phone);

            // Send verification code via Twilio
            sendTwilioMessage(phone, "Your verification code is: " + verificationCode);

            response.getWriter().println("Verification code sent to " + phone);
            response.sendRedirect("sendSms.jsp?phone=" + phone);
        } else if ("verifyCode".equals(action)) {
            String userCode = request.getParameter("code");
            String sessionCode = (String) session.getAttribute("verificationCode");

            if (sessionCode != null && sessionCode.equals(userCode)) {
                // Fetch Twilio credentials from database
                try (Connection conn = DBConnection.DBconnection.getConnection()) {
                    String sql = "SELECT twilio_account_sid, twilio_sender_id FROM customer WHERE twilio_sender_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, phone);
                    ResultSet rs = stmt.executeQuery();

                    if (rs.next()) {
                        String accountSid = rs.getString("twilio_account_sid");
                        String senderId = rs.getString("twilio_sender_id");

                        Twilio.init(accountSid, "YOUR_TWILIO_AUTH_TOKEN");

                        // Send the actual message
                        Message message = Message.creator(
                                new PhoneNumber(phone),
                                new PhoneNumber(senderId),
                                "Hello! Your number has been verified. This is your Twilio message."
                        ).create();

                        response.getWriter().println("Message sent successfully! SID: " + message.getSid());
                    } else {
                        response.getWriter().println("No Twilio credentials found for this user.");
                    }
                } catch (SQLException e) {
                    response.getWriter().println("Database error: " + e.getMessage());
                }
            } else {
                response.getWriter().println("Invalid verification code. Please try again.");
            }
        }
    }

    private void sendTwilioMessage(String to, String messageBody) {
        // Send SMS via Twilio (using a generic Twilio account)
        Twilio.init("ACCOUNT_SID", "AUTH_TOKEN");

        Message.creator(
                new PhoneNumber(to),
                new PhoneNumber("TWILIO_PHONE_NUMBER"),
                messageBody
        ).create();
    }
}