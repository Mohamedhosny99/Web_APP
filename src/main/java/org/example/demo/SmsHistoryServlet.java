package org.example.demo;

import DBConnection.DBconnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/smsHistory")
public class SmsHistoryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in.");
            return;
        }

        int userId = (int) session.getAttribute("user_id"); // Get logged-in user ID
        String fromNumber = request.getParameter("from");
        String toNumber = request.getParameter("to");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String body = request.getParameter("body");

        try (Connection conn = DBconnection.getConnection()) {
            StringBuilder query = new StringBuilder("SELECT sms_id, from_number, to_number, body, sent_date, inbound, status FROM sms WHERE user_id = ?");
            if (fromNumber != null && !fromNumber.isEmpty()) query.append(" AND from_number ILIKE ?");
            if (toNumber != null && !toNumber.isEmpty()) query.append(" AND to_number ILIKE ?");
            if (startDate != null && !startDate.isEmpty()) query.append(" AND sent_date >= ?");
            if (endDate != null && !endDate.isEmpty()) query.append(" AND sent_date <= ?");
            if (body != null && !body.isEmpty()) query.append(" AND body ILIKE ?");

            try (PreparedStatement stmt = conn.prepareStatement(query.toString())) {
                int paramIndex = 1;
                stmt.setInt(paramIndex++, userId);
                if (fromNumber != null && !fromNumber.isEmpty()) stmt.setString(paramIndex++, "%" + fromNumber + "%");
                if (toNumber != null && !toNumber.isEmpty()) stmt.setString(paramIndex++, "%" + toNumber + "%");
                if (startDate != null && !startDate.isEmpty()) stmt.setString(paramIndex++, startDate);
                if (endDate != null && !endDate.isEmpty()) stmt.setString(paramIndex++, endDate);
                if (body != null && !body.isEmpty()) stmt.setString(paramIndex++, "%" + body + "%");

                ResultSet rs = stmt.executeQuery();
                JSONArray smsArray = new JSONArray();

                while (rs.next()) {
                    JSONObject sms = new JSONObject();
                    sms.put("sms_id", rs.getInt("sms_id"));
                    sms.put("from_number", rs.getString("from_number"));
                    sms.put("to_number", rs.getString("to_number"));
                    sms.put("body", rs.getString("body"));
                    sms.put("sent_date", rs.getString("sent_date"));
                    sms.put("inbound", rs.getBoolean("inbound") ? "Yes" : "No");
                    sms.put("status", rs.getString("status"));
                    smsArray.put(sms);
                }

                PrintWriter out = response.getWriter();
                out.print(smsArray);
                out.flush();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
}
