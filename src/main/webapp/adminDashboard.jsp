<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="DBConnection.DBconnection" %>
<%--
  HttpSession sessionObj = request.getSession(false);
  if (sessionObj == null || sessionObj.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp?error=Please login first");
    return;
  }
--%>

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

<h2>Admin Dashboard - All Customers and SMS</h2>

<!-- 🔍 Search Form -->
<form method="get" action="adminDashboard.jsp">
  <input type="text" name="search" placeholder="Search by username or user ID..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
  <button type="submit">Search</button>
</form>
<br>
<br>

<!-- Customers Table -->
<h3>Customers</h3>
<table>
  <tr>
    <th>User ID</th>
    <th>Username</th>
    <th>Phone Number</th>
    <th>Twilio Account SID</th>
    <th>Twilio Auth Token</th>
  </tr>

  <%
    String searchQuery = request.getParameter("search");
    String customerSql = "SELECT * FROM customer";

    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
      customerSql += " WHERE CAST(user_id AS TEXT) LIKE ? OR username LIKE ? OR phone_number LIKE ? OR twilio_account_sid LIKE ? OR twilio_auth_token LIKE ?";
    }

    try (Connection conn = DBConnection.DBconnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(customerSql)) {

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
    <td><%= rs.getString("username") %></td>
    <td><%= rs.getString("phone_number") %></td>
    <td><%= rs.getString("twilio_account_sid") %></td>
    <td><%= rs.getString("twilio_auth_token") %></td>
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

<!-- SMS Table -->
<h3>SMS Records</h3>
<table>
  <tr>
    <th>SMS ID</th>
    <th>User ID</th>
    <th>Username</th>
    <th>From Number</th>
    <th>To Number</th>
    <th>Message</th>
    <th>Sent Date</th>
    <th>Status</th>
  </tr>

  <%
    String smsSql = "SELECT sms.sms_id, sms.user_id, customer.username, sms.from_number, sms.to_number, sms.body, sms.sent_date, sms.status " +
            "FROM sms " +
            "JOIN customer ON sms.user_id = customer.user_id";

    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
      smsSql += " WHERE CAST(sms.user_id AS TEXT) LIKE ? OR customer.username LIKE ?";
    }

    try (Connection conn = DBConnection.DBconnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(smsSql)) {

      if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        String wildcardSearch = "%" + searchQuery + "%";
        stmt.setString(1, wildcardSearch);
        stmt.setString(2, wildcardSearch);
      }

      ResultSet rs = stmt.executeQuery();
      while (rs.next()) {
  %>
  <tr>
    <td><%= rs.getInt("sms_id") %></td>
    <td><%= rs.getInt("user_id") %></td>
    <td><%= rs.getString("username") %></td>
    <td><%= rs.getString("from_number") %></td>
    <td><%= rs.getString("to_number") %></td>
    <td><%= rs.getString("body") %></td>
    <td><%= rs.getTimestamp("sent_date") %></td>
    <td><%= rs.getString("status") %></td>
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