<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SMS History</title>
    <style>
        /* General Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(rgba(106, 17, 203, 0.8), rgba(37, 117, 252, 0.8));
            background-size: cover;
            background-position: center;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            color: #333;
        }

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
            width: 100%;
            max-width: 1200px;
            animation: fadeIn 1s ease-in-out;
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
            text-align: center;
            text-transform: uppercase;
        }

        .search-bar {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .search-bar input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            background-color: rgba(255, 255, 255, 0.9);
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

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            text-align: left;
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #6a11cb;
            color: #fff;
        }

        tr:hover {
            background-color: rgba(255, 255, 255, 0.8);
        }

        footer {
            width: 100%;
            padding: 15px 0;
            background-color: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            text-align: center;
            font-size: 14px;
            color: #fff;
        }
    </style>
</head>
<body>
<!-- Header -->
<header>
    <h1>SMS History</h1>
    <nav>
        <a href="home.jsp">Home</a>
        <a href="login.jsp">Logout</a>
    </nav>
</header>

<!-- Main Content -->
<div class="container">
    <div class="card">
        <h2>SMS History</h2>

        <!-- Search Bar -->
        <div class="search-bar">
            <input type="text" id="fromInput" placeholder="Search by From...">
            <input type="text" id="toInput" placeholder="Search by To...">
            <input type="date" id="startDate">
            <input type="date" id="endDate">
            <input type="text" id="bodyInput" placeholder="Search by Body...">
            <button id="searchButton">Search</button>
        </div>

        <!-- SMS Table -->
        <table>
            <thead>
            <tr>
                <th>From</th>
                <th>To</th>
                <th>Message</th>
                <th>Date</th>
                <th>Inbound</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody id="smsTableBody">
            <%
                List<Map<String, String>> smsHistory = (List<Map<String, String>>) request.getAttribute("smsHistory");
                if (smsHistory != null && !smsHistory.isEmpty()) {
                    for (Map<String, String> sms : smsHistory) {
            %>
            <tr>
                <td><%= sms.get("fromNumber") %></td>
                <td><%= sms.get("toNumber") %></td>
                <td><%= sms.get("body") %></td>
                <td><%= sms.get("sentDate") %></td>
                <td><%= sms.get("inbound") %></td>
                <td><%= sms.get("status") %></td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="6" style="text-align:center;">No SMS history found.</td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Footer -->
<footer>
    <p>&copy; 2025 Twilio SMS Client. All rights reserved.</p>
</footer>

<script>
    document.getElementById('searchButton').addEventListener('click', function () {
        let fromTerm = document.getElementById('fromInput').value.toLowerCase();
        let toTerm = document.getElementById('toInput').value.toLowerCase();
        let startDate = document.getElementById('startDate').value;
        let endDate = document.getElementById('endDate').value;
        let bodyTerm = document.getElementById('bodyInput').value.toLowerCase();

        document.querySelectorAll("#smsTableBody tr").forEach(row => {
            let from = row.cells[0].textContent.toLowerCase();
            let to = row.cells[1].textContent.toLowerCase();
            let date = row.cells[3].textContent;
            let body = row.cells[2].textContent.toLowerCase();

            let matches = (!fromTerm || from.includes(fromTerm)) &&
                (!toTerm || to.includes(toTerm)) &&
                (!bodyTerm || body.includes(bodyTerm)) &&
                (!startDate || date >= startDate) &&
                (!endDate || date <= endDate);

            row.style.display = matches ? "" : "none";
        });
    });
</script>
</body>
</html>