package org.example.demo;
import java.io.IOException;
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
import DBConnection.DBconnection.*;
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path1 = "/login.jsp";
        response.sendRedirect(path1);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.DBconnection.getConnection()) {
            String sql = "SELECT user_id, username, type FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);  // In real-world apps, hash passwords!

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("user_id");
                String type = rs.getString("type");
                System.err.println(userId);
                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);
                session.setAttribute("username", username);
              
                session.setAttribute("type", type);

                if ("admin".equals(type)) {
                    response.sendRedirect("adminDashboard.jsp");
                } else {

                    String sql2 = "SELECT phone_number FROM customer  WHERE  user_id = ? ";
                    PreparedStatement stmt2 = conn.prepareStatement(sql2);
                    stmt2.setInt(1, userId);
                     ResultSet rs2 = stmt2.executeQuery();
                     if (rs2.next()){
                       String  phone = rs2.getString(1) ;
                       session.setAttribute("phone", phone);

                     }

                    session.setAttribute("phone", rs2.getString("phone_number"));
                    response.sendRedirect("home.jsp");
                }
            } else {
                response.sendRedirect("login.jsp?error=Invalid credentials");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database error");
        }


    }
}
