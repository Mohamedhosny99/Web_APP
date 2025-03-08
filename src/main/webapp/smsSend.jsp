<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Send SMS</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(rgba(106, 17, 203, 0.8), rgba(37, 117, 252, 0.8));
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 300px;
            text-align: center;
        }
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        input, textarea, button {
            width: 80%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        button {
            background-color: #6a11cb;
            color: white;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #2575fc;
        }
        .message {
            margin-top: 10px;
            color: green;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Send SMS</h2>
    <h2>SEND SMS NOW !</h2>
    <form action="/SendSmsServlet" method="POST">
        <input type="text" name="toNumber" placeholder="Enter phone number" required>
        <textarea name="message" placeholder="Enter your message" rows="4" required></textarea>
        <button type="submit">Send SMS</button>
    </form>
    <div class="message">
        <%= request.getParameter("message") != null ? request.getParameter("message") : "" %>
    </div>
</div>
</body>
</html>