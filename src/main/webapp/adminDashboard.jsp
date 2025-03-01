<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="DBConnection.DBconnection" %>
<%
  HttpSession sessionObj = request.getSession(false);
  if (sessionObj == null || sessionObj.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp?error=Please login first");
    return;
  }
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; }
    table { width: 80%; margin: auto; border-collapse: collapse; }
    th, td { border: 1px solid black; padding: 8px; }
    input { padding: 5px; width: 200px; }
    button { padding: 5px 10px; background-color: blue; color: white; }
  </style>
</head>
<body>

<h2>Admin Dashboard - All Customers</h2>

<!-- 🔍 Search Form -->
<form method="get" action="adminDashboard.jsp">
  <input type="text" name="search" placeholder="Search customers..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
  <button type="submit">Search</button>
</form>
<br>
<br>
<table>
  <tr>
    <th>User ID</th>
    <th>Name</th>
    <th>Phone</th>
    <th>Twilio SID</th>
    <th>Twilio Token</th>
  </tr>

  <%
    String searchQuery = request.getParameter("search");
    String sql = "SELECT * FROM customers";

    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
      sql += " WHERE CAST(user_id AS TEXT) LIKE ? OR name LIKE ? OR phone LIKE ? OR twilio_sid LIKE ? OR twilio_token LIKE ?";
    }

    try (Connection conn = DBConnection.DBconnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

      if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        String wildcardSearch = "%" + searchQuery + "%";
        stmt.setString(1, wildcardSearch);
        stmt.setString(2, wildcardSearch);
        stmt.setString(3, wildcardSearch);
        stmt.setString(4, wildcardSearch);
        stmt.setString(5, wildcardSearch);
      }

      ResultSet rs = stmt.executeQuery();
      while (rs.next()) {
  %>
  <tr>
    <td><%= rs.getInt("user_id") %></td>
    <td><%= rs.getString("name") %></td>
    <td><%= rs.getString("phone") %></td>
    <td><%= rs.getString("twilio_sid") %></td>
    <td><%= rs.getString("twilio_token") %></td>
  </tr>
  <%
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
  %>
</table>
<br>
<br>
<!-- Logout Button -->
<form action="LogoutServlet" method="get" style="text-align: right; margin: 10px;">
  <button type="submit" style="background-color: red; color: white; padding: 10px; border: none; cursor: pointer;">
    Logout
  </button>
</form>

</body>
</html>
