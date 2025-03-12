package org.example.demo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import DBConnection.DBconnection;
import model.SmsRecord;

@WebServlet("/SmsHistoryServlet")
public class SmsHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        List<SmsRecord> smsList = new ArrayList<>();

        // Retrieve search parameters from request
        String fromNumber = request.getParameter("from");
        String toNumber = request.getParameter("to");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String body = request.getParameter("body");

        // Convert date strings to java.sql.Date
        java.sql.Date startDate = null;
        java.sql.Date endDate = null;

        try {
            if (startDateStr != null && !startDateStr.isEmpty()) {
                startDate = java.sql.Date.valueOf(startDateStr);
            }
            if (endDateStr != null && !endDateStr.isEmpty()) {
                endDate = java.sql.Date.valueOf(endDateStr);
            }
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid date format.");
            request.getRequestDispatcher("smsHistory.jsp").forward(request, response);
            return;
        }

        // Construct the dynamic SQL query
        StringBuilder query = new StringBuilder("SELECT user_id, to_number, from_number, body, sent_date, inbound, status FROM sms WHERE user_id = ?");
        List<Object> parameters = new ArrayList<>();
        parameters.add(userId);

        if (fromNumber != null && !fromNumber.trim().isEmpty()) {
            query.append(" AND from_number LIKE ?");
            parameters.add("%" + fromNumber.trim() + "%");
        }

        if (toNumber != null && !toNumber.trim().isEmpty()) {
            query.append(" AND to_number LIKE ?");
            parameters.add("%" + toNumber.trim() + "%");
        }

        if (startDate != null) {
            query.append(" AND sent_date >= ?");
            parameters.add(startDate);
        }

        if (endDate != null) {
            query.append(" AND sent_date <= ?");
            parameters.add(endDate);
        }

        if (body != null && !body.trim().isEmpty()) {
            query.append(" AND body ILIKE ?");  // ILIKE makes search case-insensitive
            parameters.add("%" + body.trim() + "%");
        }

        // Execute the query
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {

            // Bind parameters dynamically
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                smsList.add(new SmsRecord(
                        rs.getInt("user_id"),
                        rs.getString("to_number"),
                        rs.getString("from_number"),
                        rs.getString("body"),
                        rs.getString("sent_date"),
                        rs.getBoolean("inbound"),
                        rs.getString("status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Attach the filtered list to the request
        request.setAttribute("smsList", smsList);
        request.getRequestDispatcher("smsHistory.jsp").forward(request, response);
    }
}
