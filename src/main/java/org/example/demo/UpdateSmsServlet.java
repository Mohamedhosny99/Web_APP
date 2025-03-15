package org.example.demo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import DBConnection.DBconnection;

@WebServlet("/UpdateSmsServlet")
public class UpdateSmsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters from request
        int smsId = Integer.parseInt(request.getParameter("smsId"));
        String newBody = request.getParameter("messageBody");

        // Validate input
        if (newBody == null || newBody.trim().isEmpty()) {
            response.sendRedirect("edit.jsp?error=emptybody&smsId=" + smsId);
            return;
        }

        try (Connection conn = DBconnection.getConnection()) {
           
            String sql = "UPDATE sms SET body = ? WHERE sms_id = ?";
            String sql2 = "SELECT user_id FROM sms WHERE sms_id = ?";
            String Sql3 = "select username from customer where user_id = ?" ;
            String updateDateSql = "UPDATE sms SET sent_date = NOW() WHERE sms_id = ?";
            try (PreparedStatement pstmtDate = conn.prepareStatement(updateDateSql)) {
                pstmtDate.setInt(1, smsId);
                pstmtDate.executeUpdate();
            }
            int  userid = 0;
            String username = null;
            HttpSession session = request.getSession();

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, newBody);
                pstmt.setInt(2, smsId);
                
                int rowsUpdated = pstmt.executeUpdate();
                
                if (rowsUpdated > 0) {
                    // Redirect with success message

                    try (PreparedStatement pstmt2 = conn.prepareStatement(sql2)) {
                        pstmt2.setInt(1, smsId);
                        ResultSet rs = pstmt2.executeQuery();
                        if (rs.next()) {
                          userid = rs.getInt("user_id");
                        }
                    }
                    
                    try (PreparedStatement pstmt3 = conn.prepareStatement(Sql3)) {
                        pstmt3.setInt(1, userid);
                        ResultSet rs = pstmt3.executeQuery();
                        if (rs.next()) {
                            username = rs.getString("username");
                        }
                    }


                    

                    System.out.println("userId = " +  userid );
                    System.out.println("username = " +  username );
                    System.out.println("smsid = " +  smsId );
                    session.setAttribute("userId", userid);
                    session.setAttribute("username", username);
                    session.setAttribute("smsid" ,smsId);
                    response.sendRedirect("UserSmsServlet");
                } else {
                    response.sendRedirect("edit.jsp?error=notfound&smsId=" + smsId);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("edit.jsp?error=database&smsId=" + smsId);
        }
    }
} 