<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>SMS History</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f0f2f5;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #1a73e8;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f8f9fa;
            color: #333;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .message {
            text-align: center;
            margin-top: 10px;
            color: #666;
        }
        .error {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>SMS History</h2>
    <table>
        <tr>
            <th>From</th>
            <th>To</th>
            <th>Message</th>
            <th>Date</th>
        </tr>
        <%
            List<Map<String, String>> smsHistory = (List<Map<String, String>>) request.getAttribute("smsHistory");
            if (smsHistory != null) {
                for (Map<String, String> sms : smsHistory) {
        %>
        <tr>
            <td><%= sms.get("fromNumber") %></td>
            <td><%= sms.get("toNumber") %></td>
            <td><%= sms.get("message") %></td>
            <td><%= sms.get("sentDate") %></td>
        </tr>
        <%
                }
            }
        %>
    </table>
    <p class="message">
        <%
            String error = request.getParameter("error");
            if (error != null) {
                out.println("<div class='error'>" + error + "</div>");
            }
        %>
    </p>
</div>
</body>
</html>