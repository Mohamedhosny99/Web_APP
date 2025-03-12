<%@ page import="java.sql.Connection" %>
<%@ page import="DBConnection.DBconnection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>List Users</title>
  <style>
    /* General Reset */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Arial', sans-serif;
      background: linear-gradient(rgba(106, 17, 203, 0.8), rgba(37, 117, 252, 0.8)); /* Gradient overlay on background image */
      background-size: cover;
      background-position: center;
      display: flex;
      flex-direction: column;
      min-height: 100vh;
      color: #333;
    }

    /* Header Styles */
    header {
      background-color: rgba(255, 255, 255, 0.2);
      backdrop-filter: blur(10px);
      padding: 15px 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    header h1 {
      font-size: 24px;
      font-weight: 600;
      color: #fff;
    }

    header nav {
      display: flex;
      gap: 20px;
    }

    header nav a {
      color: #fff;
      text-decoration: none;
      font-size: 16px;
      font-weight: 500;
      transition: color 0.3s ease;
    }

    header nav a:hover {
      color: #6a11cb;
    }

    /* Main Content Styles */
    .container {
      flex: 1;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 20px;
    }

    .card {
      background-color: rgba(255, 255, 255, 0.95);
      padding: 30px;
      border-radius: 15px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.1);
      animation: fadeIn 1s ease-in-out;
      width: 100%;
      max-width: 1000px;
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: translateY(-20px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    h2 {
      margin-bottom: 20px;
      color: #6a11cb;
      font-size: 28px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 2px;
      text-align: center;
    }

    /* Table Styles */
    table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0 10px; /* Spacing between rows */
      margin-top: 20px;
    }

    th, td {
      padding: 15px;
      text-align: left;
      background-color: rgba(255, 255, 255, 0.9);
    }

    th {
      background-color: #6a11cb;
      color: #fff;
      font-weight: 600;
      position: sticky;
      top: 0;
      z-index: 1;
    }

    tr {
      background-color: rgba(255, 255, 255, 0.9);
      border-radius: 10px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    tr:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    }

    td {
      color: #555;
    }

    .actions button {
      padding: 8px 12px;
      border: none;
      border-radius: 5px;
      background-color: #007bff;
      color: #fff;
      font-size: 14px;
      font-weight: 500;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }

    .actions button:hover {
      background-color: #0056b3;
    }

    /* Footer Styles */
    footer {
      width: 100%;
      padding: 15px 0;
      background-color: rgba(255, 255, 255, 0.2);
      backdrop-filter: blur(10px);
      text-align: center;
      font-size: 14px;
      color: #fff;
      border-top: 1px solid rgba(255, 255, 255, 0.1);
    }

    footer a {
      color: #fff;
      text-decoration: none;
      transition: color 0.3s ease;
    }

    footer a:hover {
      color: #6a11cb;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      header {
        flex-direction: column;
        gap: 10px;
      }

      header nav {
        gap: 10px;
      }

      .card {
        padding: 20px;
      }

      table {
        display: block;
        overflow-x: auto;
        white-space: nowrap;
      }

      th, td {
        padding: 10px;
      }
    }
  </style>

</head>
<body>
<header>
  <h1>List Users</h1>
  <nav>
    <a href="adminDashboard.jsp">Home</a>
    <a href="login.jsp">Logout</a>
  </nav>
</header>
<div class="container">
  <div class="card">
    <h2>Users List</h2>
    <table>
      <thead>
      <tr>
        <th>User ID</th>
        <th>Name</th>
        <th>Type</th>
        <th>Action</th>
      </tr>
      </thead>
      <tbody>

      <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
          conn = DBconnection.getConnection();
          String userSQL = "SELECT user_id, type, username FROM users WHERE type = 'customer'";

          pstmt = conn.prepareStatement(userSQL);
          rs = pstmt.executeQuery();

          while (rs.next()) {
            int userId = rs.getInt("user_id");

            String userType = rs.getString("type");
            String username = rs.getString("username");
      %>
      <tr>
        <td><%= userId %></td>
        <td><%= username %></td>
        <td><%= userType %></td>
        <td class="actions">
          <script>
            function setUserAndRedirect(userId, username, userType) {
                // Encode parameters to handle special characters
                const encodedUsername = encodeURIComponent(username);
                const encodedUserType = encodeURIComponent(userType);
                
                // Redirect with parameters in URL
                window.location.href = `list-user-sms.jsp?userId=${userId}&username=${encodedUsername}&userType=${encodedUserType}`;
            }
          </script>
          <button onclick="setUserAndRedirect(<%= userId %>, '<%= username %>', '<%= userType %>')">View SMS History</button>
        </td>
      </tr>
      <%
          }
        } catch (Exception e) {
          e.printStackTrace();
        } finally {
          if (rs != null) rs.close();
          if (pstmt != null) pstmt.close();
          if (conn != null) conn.close();
        }
      %>
      </tbody>
    </table>
  </div>
</div>
<footer>
  <p>&copy; 2025 Twilio SMS Client. All rights reserved.</p>
</footer>

</body>
</html>
