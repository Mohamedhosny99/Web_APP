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
        Integer userId = session.getAttribute("userId") != null ? (Integer) session.getAttribute("userId") : null;
        System.out.println(userId);

        System.out.println("Action: " + action);
        System.out.println("Phone: " + phone);
        if ("sendCode".equals(action)) {
            // Generate a 4-digit random verification code
            int verificationCode = (int) (Math.random() * 9000) + 1000;
            session.setAttribute("verificationCode", String.valueOf(verificationCode));
            session.setAttribute("phone", phone);

            // Send verification code via Twilio
            try (Connection conn = DBConnection.DBconnection.getConnection()) {
                String sql = "SELECT twilio_account_sid, twilio_sender_id, twilio_auth_token FROM customer WHERE user_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                if(userId != null) { stmt.setInt(1, userId); }
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String accountSid = rs.getString("twilio_account_sid");
                    String senderId = rs.getString("twilio_sender_id"); 
                    String token = rs.getString("twilio_auth_token");
                    
                    if ("sendCode".equals(action)) {
                        sendTwilioMessage(phone, "Your verification code is: " + verificationCode, token, accountSid, senderId);
                        response.getWriter().println("Verification code sent to " + phone);
                        response.sendRedirect("sendSms.jsp?phone=" + phone);
                    } else if ("verifyCode".equals(action)) {
                        String userCode = request.getParameter("code");
                        String sessionCode = (String) session.getAttribute("verificationCode");

                        if (sessionCode != null && sessionCode.equals(userCode)) {
                            if (!phone.startsWith("+")) {
                                phone = phone.trim();
                                phone = "+".concat(phone);
                            }
                            sendTwilioMessage(phone, "Hello! Your number has been verified. This is your Twilio message.", token, accountSid, senderId);
                            response.getWriter().println("Message sent successfully!");
                        } else {
                            response.getWriter().println("Invalid verification code. Please try again.");
                        }
                    }
                } else {
                    response.getWriter().println("No Twilio credentials found for this user.");
                }
            } catch (SQLException e) {
                response.getWriter().println("Database error: " + e.getMessage());
            }
        }
    }
    static void sendTwilioMessage(String to, String messageBody, String tokin, String accSID, String senderID) {
        // Send SMS via Twilio (using a generic Twilio account)
        Twilio.init(accSID, tokin);

        Message.creator(
                new PhoneNumber(to),
                new PhoneNumber(senderID),
                messageBody
        ).create();
    }


}