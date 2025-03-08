<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="DBConnection.DBconnection" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customer Dashboard - Twilio SMS Client</title>
  <style>
    /* General Styles */
    body {
      font-family: 'Arial', sans-serif;
      margin: 0;
      padding: 0;
      display: flex;
      flex-direction: column;
      min-height: 100vh;
      /*background: url('customerpage.jpg') no-repeat center center fixed;*/
      background-size: cover;
      position: relative;
      overflow: hidden;
    }
    body::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.5); /* Semi-transparent overlay */
      backdrop-filter: blur(8px); /* Blur effect */
      z-index: -1;
    }
    /* Header Styles */
    .header {
      background-color: #000; /* Black header */
      color: #fff;
      padding: 20px;
      text-align: center;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    }
    .header h1 {
      margin: 0;
      font-size: 28px;
      font-weight: 600;
    }
    /* Sidebar Styles */
    .sidebar {
      width: 250px; /* Narrower sidebar */
      background-color: rgba(0, 123, 255, 0.9); /* Semi-transparent blue */
      color: #fff;
      padding: 20px;
      box-shadow: 2px 0 10px rgba(0, 0, 0, 0.2);
      height: 100vh;
      position: fixed;
      top: 0;
      left: 0;
      transition: transform 0.3s ease;
    }
    .sidebar h2 {
      margin-bottom: 20px;
      font-size: 24px;
      text-align: center;
    }
    .sidebar ul {
      list-style: none;
      padding: 0;
    }
    .sidebar ul li {
      margin: 15px 0;
    }
    .sidebar ul li a {
      color: #fff;
      text-decoration: none;
      font-size: 18px;
      display: block;
      padding: 10px;
      border-radius: 6px;
      transition: background-color 0.3s ease, transform 0.3s ease;
    }
    .sidebar ul li a:hover {
      background-color: #0056b3;
      transform: translateX(5px);
    }
    /* Main Content Styles */
    .main-content {
      flex: 1;
      padding: 20px;
      background-color: rgba(255, 255, 255, 0.9); /* Semi-transparent white */
      margin-left: 250px; /* Adjust for sidebar width */
      border-radius: 12px;
      box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
      transition: margin 0.3s ease;
    }
    .welcome-message {
      text-align: center;
      font-size: 28px;
      color: #007bff;
      margin-top: 20%;
      animation: fadeIn 1s ease-in-out;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    /* Search Bar Styles */
    .search-bar {
      display: flex;
      gap: 10px;
      margin-bottom: 20px;
      display: none; /* Hidden by default */
      animation: slideIn 0.5s ease-in-out;
    }
    @keyframes slideIn {
      from { opacity: 0; transform: translateY(-20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .search-bar input, .search-bar select, .search-bar button {
      padding: 12px;
      border: 1px solid #ddd;
      border-radius: 8px;
      font-size: 14px;
      transition: border-color 0.3s ease;
    }
    .search-bar input:focus, .search-bar select:focus {
      border-color: #007bff;
      outline: none;
    }
    .search-bar button {
      background-color: #007bff;
      color: #fff;
      border: none;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }
    .search-bar button:hover {
      background-color: #0056b3;
    }
    /* SMS History Table Styles */
    .sms-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
      display: none; /* Hidden by default */
      animation: fadeIn 0.5s ease-in-out;
    }
    .sms-table th, .sms-table td {
      padding: 12px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }
    .sms-table th {
      background-color: #007bff;
      color: #fff;
    }
    .sms-table tr:hover {
      background-color: #f1f1f1;
    }
    /* Footer Styles */
    .footer {
      background-color: #000; /* Black footer */
      color: #fff;
      text-align: center;
      padding: 15px;
      box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.2);
      margin-top: auto;
    }
    .footer p {
      margin: 0;
      font-size: 14px;
    }
    /* Responsive Design */
    @media (max-width: 768px) {
      .sidebar {
        transform: translateX(-100%);
      }
      .sidebar.active {
        transform: translateX(0);
      }
      .main-content {
        margin-left: 0;
      }
      .welcome-message {
        margin-top: 50px;
      }
    }
  </style>
</head>
<body>
<!-- Header -->
<div class="header">
  <h1>Twilio SMS Client</h1>
</div>

<!-- Sidebar -->
<div class="sidebar" id="sidebar">
  <h2>Dashboard</h2>
  <ul>
    <li><a href="#" onclick="showWelcome()">Home</a></li>
    <li><a href="smsHistory.jsp" onclick="showSMSHistory()">View SMS History</a></li>
    <li><a href="verificationCode.jsp">Send SMS</a></li>
    <li><a href="LogoutServlet">Logout</a></li>
  </ul>
</div>

<!-- Main Content -->
<div class="main-content">
  <!-- Welcome Message (Default) -->
  <div id="welcome-message" class="welcome-message">
    Welcome to Your Twilio SMS Client Dashboard!
  </div>

  <!-- Search Bar (Hidden by Default) -->
  <div id="search-bar" class="search-bar">
    <input type="text" id="search-from" placeholder="Search by From...">
    <input type="text" id="search-to" placeholder="Search by To...">
    <input type="text" id="search-body" placeholder="Search by Body...">
    <input type="date" id="search-date" placeholder="Search by Date...">
    <button onclick="searchSMS()">Search</button>
  </div>

  <!-- SMS History Table (Hidden by Default) -->
  <table id="sms-table" class="sms-table">
    <thead>
    <tr>
      <th>From</th>
      <th>To</th>
      <th>Body</th>
      <th>Date</th>
    </tr>
    </thead>
    <tbody id="sms-history">
    <%
      HttpSession sessionObj = request.getSession();
      Integer userId = (Integer) sessionObj.getAttribute("userId");

      if (userId == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
      }

      try (Connection conn = DBconnection.getConnection()) {
        String smsSql = "SELECT from_number, to_number, body, sent_date FROM sms WHERE user_id = ?";
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
    </tbody>
  </table>
</div>

<!-- Footer -->
<div class="footer">
  <p>&copy; 2025 Twilio SMS Client. All rights reserved.</p>
</div>

<script>
  // Function to show the welcome message and hide SMS history
  function showWelcome() {
    document.getElementById('welcome-message').style.display = 'block';
    document.getElementById('search-bar').style.display = 'none';
    document.getElementById('sms-table').style.display = 'none';
  }

  // Function to show the SMS history and search bar
  function showSMSHistory() {
    document.getElementById('welcome-message').style.display = 'none';
    document.getElementById('search-bar').style.display = 'flex';
    document.getElementById('sms-table').style.display = 'table';
  }

  // Example function to handle search
  function searchSMS() {
    const from = document.getElementById('search-from').value.toLowerCase();
    const to = document.getElementById('search-to').value.toLowerCase();
    const body = document.getElementById('search-body').value.toLowerCase();
    const date = document.getElementById('search-date').value;

    const rows = document.querySelectorAll('#sms-history tr');
    rows.forEach(row => {
      const fromCell = row.cells[0].textContent.toLowerCase();
      const toCell = row.cells[1].textContent.toLowerCase();
      const bodyCell = row.cells[2].textContent.toLowerCase();
      const dateCell = row.cells[3].textContent;

      const matchesFrom = fromCell.includes(from);
      const matchesTo = toCell.includes(to);
      const matchesBody = bodyCell.includes(body);
      const matchesDate = date === '' || dateCell === date;

      if (matchesFrom && matchesTo && matchesBody && matchesDate) {
        row.style.display = '';
      } else {
        row.style.display = 'none';
      }
    });
  }

  // Show welcome message by default
  showWelcome();
</script>
</body>
</html>