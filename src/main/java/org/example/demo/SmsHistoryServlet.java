package org.example.demo;

import javax.servlet.ServletException;
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
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/SmsHistoryServlet")
public class SmsHistoryServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SmsHistoryServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.jsp?error=Please login to view SMS history.");
            return;
        }

        List<Map<String, String>> smsHistory = new ArrayList<>();

        try (Connection conn = DBConnection.DBconnection.getConnection()) {
            String sql = "SELECT from_number, to_number, body, sent_date, inbound, status " +
                    "FROM sms WHERE user_id = ? ORDER BY sent_date DESC";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    while (rs.next()) {
                        Map<String, String> sms = new HashMap<>();
                        sms.put("fromNumber", rs.getString("from_number"));
                        sms.put("toNumber", rs.getString("to_number"));
                        sms.put("body", rs.getString("body")); // Use "body" instead of "message"
                        sms.put("sentDate", rs.getTimestamp("sent_date") != null
                                ? dateFormat.format(rs.getTimestamp("sent_date"))
                                : "N/A");
                        sms.put("inbound", rs.getBoolean("inbound") ? "Yes" : "No");
                        sms.put("status", rs.getString("status") != null ? rs.getString("status") : "Unknown");
                        smsHistory.add(sms);
                    }
                }
            }

            request.setAttribute("smsHistory", smsHistory);
            request.getRequestDispatcher("smsHistory.jsp").forward(request, response);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while fetching SMS history", e);
            response.sendRedirect("smsHistory.jsp?error=Error retrieving SMS history. Please try again later.");
        } catch (ServletException e) {
            LOGGER.log(Level.SEVERE, "Servlet error while forwarding request", e);
            throw new RuntimeException(e);
        }
    }
}