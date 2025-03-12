package org.example.demo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;
import DBConnection.DBconnection;
import model.SmsRecord;


@WebServlet("/UserSmsServlet")
public class UserSmsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userId = request.getParameter("user_id");
        HashMap<String, SmsRecord> smsMap = new HashMap<>();

        if (userId != null && !userId.isEmpty()) {
            try (Connection conn = DBconnection.getConnection()) {
                String sql = "SELECT user_id, to_number, from_number, body, sent_date, inbound, status FROM sms WHERE user_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(userId));
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {

                    SmsRecord sms = new SmsRecord();
                    sms.setUserId(rs.getInt("user_id"));
                    sms.setTo(rs.getString("to_number"));
                    sms.setFrom(rs.getString("from_number"));
                    sms.setBody(rs.getString("body"));
                    sms.setDate(rs.getDate("sent_date") != null ? rs.getDate("sent_date").toString() : "N/A");
                    sms.setInbound(rs.getBoolean("inbound"));
                    sms.setStatus(rs.getString("status") != null ? rs.getString("status") : "N/A");

                    // Store in HashMap with user_id as key
                    smsMap.put(userId, sms);
                }

                while (rs.next()) {
                    System.out.println("Fetching SMS record for user_id: " + userId);
                    System.out.println("Message: " + rs.getString("message")); // Debugging
                }
                System.out.println("Received user_id: " + userId);
                System.out.println("SMS Map Size: " + smsMap.size());


                rs.close();
                stmt.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("smsMap", smsMap);
        request.setAttribute("userId", userId);
        request.getRequestDispatcher("list-user-sms.jsp").forward(request, response);
    }
}