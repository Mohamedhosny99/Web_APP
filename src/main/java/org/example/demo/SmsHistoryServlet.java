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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/SmsHistoryServlet")
public class SmsHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp?error=Please login to view SMS history.");
            return;
        }

        try (Connection conn = DBConnection.DBconnection.getConnection()) {
            // Fetch SMS history for the logged-in user
            String sql = "SELECT s.from_number, s.to_number, s.body, s.sent_date " +
                    "FROM sms s " +
                    "JOIN sms_belongs sb ON s.sms_id = sb.sms_id " +
                    "WHERE sb.user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            List<Map<String, String>> smsHistory = new ArrayList<>();
            while (rs.next()) {
                Map<String, String> sms = new HashMap<>();
                sms.put("fromNumber", rs.getString("from_number"));
                sms.put("toNumber", rs.getString("to_number"));
                sms.put("message", rs.getString("body"));
                sms.put("sentDate", rs.getTimestamp("sent_date").toString());
                smsHistory.add(sms);
            }

            // Set SMS history as a request attribute
            request.setAttribute("smsHistory", smsHistory);
            request.getRequestDispatcher("smsHistory.jsp").forward(request, response);
        } catch (SQLException e) {
            response.sendRedirect("smsHistory.jsp?error=Database error: " + e.getMessage());
        } catch (ServletException e) {
            throw new RuntimeException(e);
        }
    }
}