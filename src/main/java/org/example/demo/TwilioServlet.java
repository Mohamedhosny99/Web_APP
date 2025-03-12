package org.example.demo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Random;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;

import DBConnection.DBconnection;

@WebServlet(name = "twilio-servlet", urlPatterns = {"/TwilioServlet"})
public class TwilioServlet extends HttpServlet {




    
    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws IOException {

        


        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (int) session.getAttribute("userId");
        String twilioSID = null;
        String twilioToken = null;
        
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT twilio_sid, twilio_token FROM customers WHERE user_id = ?")) {
            
            stmt.setInt(1, userId);
            try (var rs = stmt.executeQuery()) {
                if (rs.next()) {
                    twilioSID = rs.getString("twilio_sid");
                    twilioToken = rs.getString("twilio_token");
                }
            }
        } catch (Exception e) {
            response.getWriter().println("Database Error: " + e.getMessage());
            return;
        }
        
        if (twilioSID == null || twilioToken == null) {
            response.sendRedirect("twilioSetup.jsp");
            return;
        }
        
        Twilio.init(twilioSID, twilioToken);
        String action = request.getParameter("action");
        String phoneNumber = request.getParameter("phone");
        
        try {
            if ("sendCode".equals(action)) {
                // Generate a random 6-digit verification code
                String verificationCode = String.format("%06d", new Random().nextInt(999999));
                session.setAttribute("verificationCode", verificationCode);
                
                // Send verification code via SMS
                Message message = Message.creator(
                        new PhoneNumber(phoneNumber),
                        new PhoneNumber("+19792716307"),
                        "Your verification code is: " + verificationCode
                ).create();
                
//                response.sendRedirect("twilio.jsp");
                
            } else if ("verifyCode".equals(action)) {
                String submittedCode = request.getParameter("code");
                String storedCode = (String) session.getAttribute("verificationCode");
                
                if (storedCode != null && storedCode.equals(submittedCode)) {
                    // Code verified, send the actual message
                    Message message = Message.creator(
                            new PhoneNumber(phoneNumber),
                            new PhoneNumber("+19792716307"),
                            "Verification successful! Welcome to our service."
                    ).create();
                    
                    session.removeAttribute("verificationCode");
                    response.getWriter().println("Verification successful! Message sent.");
                    response.sendRedirect("home.jsp");
                } else {
                    response.getWriter().println("Invalid verification code. Please try again.");
                }
            }
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
