<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.SmsRecord" %>
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
        <a href="ListUserServlet"><< Back</a>
        <a href="adminDashboard.jsp">Home</a>
        <a href="login.jsp">Logout</a>
    </nav>
</header>
<div class="container">
    <div class="card">
        <h2>SMS History</h2>
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
                <th>Edit</th>
                <th>Delete</th>

            </tr>
            </thead>
            <tbody>
            <%
                List<SmsRecord> smsList = (List<SmsRecord>) request.getAttribute("smsList");
                if (smsList != null && !smsList.isEmpty()) {
                    for (SmsRecord sms : smsList) {
            %>
            <tr>
                <td><%= sms.getUserId() %></td>
                <td><%= sms.getTo() %></td>
                <td><%= sms.getFrom() %></td>
                <td><%= sms.getBody() %></td>
                <td><%= sms.getDate() %></td>
                <td><%= sms.isInbound() ? "Yes" : "No" %></td>
                <td><%= sms.getStatus() %></td>
                <td  class="actions">
                    <form>
                        <button type="submit" class="edit">Edit</button>
                    </form>
                </td>




            </tr>
            <%
                }
            } else {
            %>
            <tr><td colspan="7" style="text-align: center; color: red;">No SMS records found.</td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>
<footer>
    <p>&copy; 2025 SMS Application</p>
</footer>
</body>
</html>
