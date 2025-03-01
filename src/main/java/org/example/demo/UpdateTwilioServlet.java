package org.example.demo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import DBConnection.DBconnection;

@WebServlet("/UpdateTwilioServlet")
public class UpdateTwilioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String twilioSID = request.getParameter("twilioSid");
        String twilioToken = request.getParameter("twilioToken");

        if (twilioSID == null || twilioToken == null ||
                twilioSID.isEmpty() || twilioToken.isEmpty()) {
            response.getWriter().write("All fields are required.");
            return;
        }

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("UPDATE customers SET twilio_sid = ?, twilio_token = ? WHERE user_id = ?")) {

            stmt.setString(1, twilioSID);
            stmt.setString(2, twilioToken);
            stmt.setInt(3, userId);  // Correct index

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                session.setAttribute("twilioSID", twilioSID);
                session.setAttribute("twilioToken", twilioToken);
                response.getWriter().write("Added successfully");
            } else {
                response.getWriter().write("Failed to update Twilio credentials.");
            }
        } catch (Exception e) {
            response.getWriter().write("Database error: " + e.getMessage());
        }
    }
}
