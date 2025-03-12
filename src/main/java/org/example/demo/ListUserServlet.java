package org.example.demo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import DBConnection.DBconnection;
import model.User;

@WebServlet("/ListUserServlet")
public class ListUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<User> userList = new ArrayList<>();

        try {
            conn = DBconnection.getConnection();
            String username = request.getParameter("username");
            String userID = request.getParameter("userID");

            // Base Query
            String userSQL = "SELECT user_id, username FROM customer";

            // Applying Filters Dynamically
            List<String> filters = new ArrayList<>();
            if (username != null && !username.isEmpty()) {
                filters.add("username ILIKE ?");
            }
            if (userID != null && !userID.isEmpty()) {
                filters.add("CAST(user_id AS TEXT) ILIKE ?");
            }

            if (!filters.isEmpty()) {
                userSQL += " WHERE " + String.join(" AND ", filters);
            }

            pstmt = conn.prepareStatement(userSQL);

            int index = 1;
            if (username != null && !username.isEmpty()) {
                pstmt.setString(index++, "%" + username + "%");
            }
            if (userID != null && !userID.isEmpty()) {
                pstmt.setString(index++, "%" + userID + "%");
            }

            rs = pstmt.executeQuery();

            while (rs.next()) {
                userList.add(new User(rs.getInt("user_id"), rs.getString("username")));
            }

            request.setAttribute("userList", userList);
            request.getRequestDispatcher("list-user.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
