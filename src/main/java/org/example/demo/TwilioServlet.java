package org.example.demo;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;

@WebServlet(name = "twilio-servlet", urlPatterns = {"/TwilioServlet"})
public class TwilioServlet extends HttpServlet {
    private static final String ACCOUNT_SID = "AC832a67b88671f52f026207b9e4d5b21d";
    private static final String AUTH_TOKEN = "ed8babd5ddc2c3be665d503d1ac688df";
    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Twilio.init(ACCOUNT_SID, AUTH_TOKEN);

        try {
            Message message = Message.creator(
                    new PhoneNumber("+201142555080"),  // To number (recipient)
                    new PhoneNumber("+19792716307"), // From (Twilio number)
                    "Hello! This is a test message from your Java servlet."
            ).create();

            response.getWriter().println("Message sent successfully! SID: " + message.getSid());
        } catch (Exception e) {
            response.getWriter().println("Error sending message: " + e.getMessage());
        }

        System.out.println("Test Twilio message sent.");
    }
}
