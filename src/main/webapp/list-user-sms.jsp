<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="DBConnection.DBconnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>List SMS</title>
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
            max-width: 1200px;
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

        /* Search Bar Styles */
        .search-bar {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .search-bar input,
        .search-bar input[type="date"] {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            background-color: rgba(255, 255, 255, 0.9);
            transition: border-color 0.3s ease;
        }

        .search-bar input:focus,
        .search-bar input[type="date"]:focus {
            border-color: #6a11cb;
            outline: none;
        }

        .search-bar button {
            padding: 10px 20px;
            background-color: #6a11cb;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .search-bar button:hover {
            background-color: #2575fc;
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

        .actions {
            display: flex;
            gap: 10px;
        }

        .actions button {
            padding: 8px 12px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .actions button.edit {
            background-color: #28a745;
            color: #fff;
        }

        .actions button.delete {
            background-color: #dc3545;
            color: #fff;
        }

        .actions button:hover {
            opacity: 0.9;
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

            .search-bar {
                flex-direction: column;
            }

            .search-bar input,
            .search-bar input[type="date"] {
                width: 100%;
            }

            .search-bar button {
                width: 100%;
            }

            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }

            th, td {
                padding: 10px;
            }

            .actions {
                flex-direction: column;
                gap: 5px;
            }

            .actions button {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<header>
    <h1>List SMS</h1>
    <nav>
        <a href="list-user.jsp"><<</a>
        <a href="adminDashboard.jsp">Home</a>
        <a href="login.jsp">Logout</a>
    </nav>
</header>
<div class="container">
    <div class="card">
        <h2>SMS History</h2>
        <div class="search-bar">
            <input type="text" id="fromInput" placeholder="Search by From...">
            <input type="text" id="toInput" placeholder="Search by To...">
            <input type="date" id="startDate">
            <input type="date" id="endDate">
            <input type="text" id="bodyInput" placeholder="Search by Body...">
            <button id="searchButton">Search</button>
        </div>
        <table>
            <thead>
            <tr>
                <th>User ID</th>
                <th>To</th>
                <th>From</th>
                <th>Body</th>
                <th>Date</th>
                <th>Inbound</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody id="smsTableBody">
            <%
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;
                try {
                    Integer userId = Integer.parseInt(request.getParameter("userId"));
                    if (userId == null) {
                        out.println("<tr><td colspan='7' style='text-align: center; color: red;'>User not logged in</td></tr>");
                    } else {
                        conn = DBconnection.getConnection();
                        if (conn != null) {
                            String sql = "SELECT user_id, to_number, from_number, body, sent_date, inbound, status FROM sms WHERE user_id = ?";
                            stmt = conn.prepareStatement(sql);
                            stmt.setInt(1, userId);
                            rs = stmt.executeQuery();
                            boolean hasData = false;
                            while (rs.next()) {
                                hasData = true;
//                                 session.setAttribute("user_id",userId);
            %>
            <tr>
                <td id="user-id"><%= rs.getInt("user_id") %></td>
                <td><%= rs.getString("to_number") %></td>
                <td><%= rs.getString("from_number") %></td>
                <td><%= rs.getString("body") %></td>
                <td><%= rs.getString("sent_date") %></td>
                <td><%= rs.getBoolean("inbound") ? "Yes" : "No" %></td>
                <td><%= rs.getString("status") %></td>
            </tr>
            <%
                            }
                            if (!hasData) {
                                out.println("<tr><td colspan='7' style='text-align: center; color: gray;'>No SMS records found</td></tr>");
                            }
                        } else {
                            out.println("<tr><td colspan='7' style='text-align: center; color: red;'>Database connection failed</td></tr>");
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<tr><td colspan='7' style='text-align: center; color: red;'>Error fetching data</td></tr>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
                    try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
                    try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
                }
            %>
            </tbody>
        </table>
    </div>
</div>
<footer>
    <p>&copy; 2025 Twilio SMS Client. All rights reserved. | <a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a></p>
</footer>
<script>
    document.getElementById('searchButton').addEventListener('click', () => {
        const fromTerm = document.getElementById('fromInput').value.toLowerCase();
        const toTerm = document.getElementById('toInput').value.toLowerCase();
        const startDateTerm = document.getElementById('startDate').value;
        const endDateTerm = document.getElementById('endDate').value;
        const bodyTerm = document.getElementById('bodyInput').value.toLowerCase();
        const rows = document.getElementById('smsTableBody').getElementsByTagName('tr');
        for (let row of rows) {
            const from = row.cells[2].textContent.toLowerCase();
            const to = row.cells[1].textContent.toLowerCase();
            const date = row.cells[4].textContent;
            const body = row.cells[3].textContent.toLowerCase();
            const matchesFrom = from.includes(fromTerm);
            const matchesTo = to.includes(toTerm);
            const matchesBody = body.includes(bodyTerm);
            const matchesDate = (!startDateTerm || date >= startDateTerm) && (!endDateTerm || date <= endDateTerm);
            row.style.display = matchesFrom && matchesTo && matchesBody && matchesDate ? '' : 'none';
        }
    });

    // Fetch user ID dynamically from the table
    const userIdElement = document.getElementById("user-id");
    if (userIdElement) {
        const userId = userIdElement.textContent.trim();
        console.log("User ID:", userId);
    }
</script>
</body>
</html>
