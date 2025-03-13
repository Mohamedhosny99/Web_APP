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

@WebServlet("/DeleteServlet")
public class DeleteServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the SMS ID from the request
        int smsId = Integer.parseInt(request.getParameter("smsId"));

       //  @SuppressWarnings("unchecked")
        // List<SmsRecord> smslist = (List<SmsRecord>) request.getAttribute("listsms");
    
      
        try (Connection conn = DBconnection.getConnection()) {
            String sql = "DELETE FROM sms WHERE sms_id = ?";
            String sql2 = "SELECT user_id FROM sms WHERE sms_id = ?";
            String Sql3 = "select username from customer where user_id = ?" ;
            int userid = 0;
            HttpSession session = request.getSession();
            String username = "";
            // First get the user_id using SELECT
            try (PreparedStatement pstmt2 = conn.prepareStatement(sql2)) {
                pstmt2.setInt(1, smsId);
                ResultSet rs = pstmt2.executeQuery();
                if (rs.next()) {
                    userid = rs.getInt("user_id");
                }
            }

            // Then delete the record
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, smsId);
                int rowsDeleted = pstmt.executeUpdate();
                
                if (rowsDeleted > 0) {
                    request.setAttribute("successMessage", "SMS record deleted successfully");
                    


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
                    response.addIntHeader("Deleted-user-ID", userid);
                    response.sendRedirect("UserSmsServlet");

                } else {
                    response.sendRedirect("ListUserServlet?error=notfound");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ListUserServlet?error=data");
        }
    }
}
