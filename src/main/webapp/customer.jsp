<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="DBConnection.DBconnection" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Customer Dashboard</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; }
    table { width: 80%; margin: auto; border-collapse: collapse; }
    th, td { border: 1px solid black; padding: 8px; }
    form { margin: auto; width: 50%; padding: 20px; }
    input, button { padding: 10px; width: 90%; margin-top: 10px; }
  </style>
</head>
<body>
<h2>Customer Dashboard</h2>

<%
  HttpSession sessionObj = request.getSession();
  Integer userId = (Integer) sessionObj.getAttribute("userId");

  if (userId == null) {
    response.sendRedirect("login.jsp?error=Please login first");
    return;
  }

  String twilioSid = "", twilioToken = "";

  try (Connection conn = DBconnection.getConnection()) {
    String sql = "SELECT twilio_sid, twilio_token, name, email, phone FROM customers WHERE user_id = ?";
    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setInt(1, userId);
    ResultSet rs = stmt.executeQuery();

    if (rs.next()) {
      twilioSid = rs.getString("twilio_sid");
      twilioToken = rs.getString("twilio_token");
%>

<h3>Your Details</h3>
<p>Name: <%= rs.getString("name") %></p>
<p>Email: <%= rs.getString("email") %></p>
<p>Phone: <%= rs.getString("phone") %></p>

<%
    }
  } catch (SQLException e) {
    e.printStackTrace();
  }
%>

<!-- Twilio Credentials Form -->
<h3>Update Twilio Credentials</h3>
<form action="UpdateTwilioServlet" method="post">
  <label for="twilioSid">Twilio SID:</label>
  <input type="text" id="twilioSid" name="twilioSid" value="<%= twilioSid != null ? twilioSid : "" %>" required>

  <label for="twilioToken">Twilio Token:</label>
  <input type="text" id="twilioToken" name="twilioToken" value="<%= twilioToken != null ? twilioToken : "" %>" required>

  <button type="submit" style="background-color: green; color: white;">Save Twilio Credentials</button>
</form>

<h3>Your SMS Messages</h3>
<table>
  <tr>
    <th>From</th>
    <th>To</th>
    <th>Body</th>
    <th>Sent Date</th>
  </tr>
  <%
    try (Connection conn = DBconnection.getConnection()) {
      String smsSql = "SELECT from_number, to_number, body, sent_date FROM sms WHERE customer_id = ?";
      PreparedStatement smsStmt = conn.prepareStatement(smsSql);
      smsStmt.setInt(1, userId);
      ResultSet smsRs = smsStmt.executeQuery();

      while (smsRs.next()) {
  %>
  <tr>
    <td><%= smsRs.getString("from_number") %></td>
    <td><%= smsRs.getString("to_number") %></td>
    <td><%= smsRs.getString("body") %></td>
    <td><%= smsRs.getTimestamp("sent_date") %></td>
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
  <button type="submit" style="background-color: red; color: white;">Logout</button>
</form>

</body>
</html>
