<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <title>Send SMS with Verification</title>--%>
<%--    <style>--%>
<%--        body { font-family: Arial, sans-serif; text-align: center; }--%>
<%--        form { margin: auto; width: 50%; padding: 20px; }--%>
<%--        input, button { padding: 10px; width: 90%; margin-top: 10px; }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>

<%--<h2>Send SMS with Twilio</h2>--%>

<%--<form action="TwilioVerificationServlet" method="post">--%>
<%--    <label for="phone">Enter Phone Number:</label>--%>
<%--    <input type="text" id="phone" name="phone" required>--%>

<%--    <button type="submit" name="action" value="sendCode" style="background-color: blue; color: white;">--%>
<%--        Send Verification Code--%>
<%--    </button>--%>
<%--</form>--%>

<%--<%--%>
<%--    String sentCode = (String) session.getAttribute("verificationCode");--%>
<%--    if (sentCode != null) {--%>
<%--%>--%>
<%--<h3>Verify Code</h3>--%>
<%--<form action="TwilioVerificationServlet" method="post">--%>
<%--    <label for="code">Enter Verification Code:</label>--%>
<%--    <input type="text" id="code" name="code" required>--%>

<%--    <input type="hidden" name="phone" value="<%= request.getParameter("phone") %>">--%>
<%--    <button type="submit" name="action" value="verifyCode" style="background-color: green; color: white;">--%>
<%--        Verify & Send SMS--%>
<%--    </button>--%>
<%--</form>--%>
<%--<% } %>--%>

<%--</body>--%>
<%--</html>--%>

<%--<!DOCTYPE html>--%>
<%--<html lang="en">--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1.0">--%>
<%--    <title>Send Verification Code</title>--%>
<%--    <style>--%>
<%--        /* General Reset */--%>
<%--        * {--%>
<%--            margin: 0;--%>
<%--            padding: 0;--%>
<%--            box-sizing: border-box;--%>
<%--        }--%>

<%--        body {--%>
<%--            font-family: 'Arial', sans-serif;--%>
<%--            background: linear-gradient(rgba(106, 17, 203, 0.8), rgba(37, 117, 252, 0.8)), url('1.jpg'); /* Gradient overlay on background image */--%>
<%--            background-size: cover;--%>
<%--            background-position: center;--%>
<%--            display: flex;--%>
<%--            flex-direction: column;--%>
<%--            min-height: 100vh;--%>
<%--            color: #fff;--%>
<%--        }--%>

<%--        .container {--%>
<%--            flex: 1;--%>
<%--            display: flex;--%>
<%--            justify-content: center;--%>
<%--            align-items: center;--%>
<%--            padding: 20px;--%>
<%--        }--%>

<%--        .card {--%>
<%--            background-color: rgba(255, 255, 255, 0.9);--%>
<%--            padding: 30px;--%>
<%--            border-radius: 15px;--%>
<%--            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);--%>
<%--            text-align: center;--%>
<%--            backdrop-filter: blur(10px);--%>
<%--            border: 1px solid rgba(255, 255, 255, 0.1);--%>
<%--            animation: fadeIn 1s ease-in-out;--%>
<%--            width: 100%;--%>
<%--            max-width: 400px;--%>
<%--        }--%>

<%--        @keyframes fadeIn {--%>
<%--            from {--%>
<%--                opacity: 0;--%>
<%--                transform: translateY(-20px);--%>
<%--            }--%>
<%--            to {--%>
<%--                opacity: 1;--%>
<%--                transform: translateY(0);--%>
<%--            }--%>
<%--        }--%>

<%--        h2 {--%>
<%--            margin-bottom: 20px;--%>
<%--            color: #333;--%>
<%--            font-size: 24px;--%>
<%--            font-weight: 600;--%>
<%--        }--%>

<%--        .form-group {--%>
<%--            margin-bottom: 20px;--%>
<%--            text-align: left;--%>
<%--        }--%>

<%--        label {--%>
<%--            display: block;--%>
<%--            margin-bottom: 5px;--%>
<%--            color: #555;--%>
<%--            font-size: 14px;--%>
<%--            font-weight: 500;--%>
<%--        }--%>

<%--        input[type="tel"] {--%>
<%--            width: 100%;--%>
<%--            padding: 12px;--%>
<%--            border: 1px solid #ddd;--%>
<%--            border-radius: 8px;--%>
<%--            font-size: 16px;--%>
<%--            background-color: rgba(255, 255, 255, 0.8);--%>
<%--            transition: border-color 0.3s ease;--%>
<%--        }--%>

<%--        input[type="tel"]:focus {--%>
<%--            border-color: #6a11cb;--%>
<%--            outline: none;--%>
<%--        }--%>

<%--        .btn {--%>
<%--            width: 100%;--%>
<%--            padding: 12px;--%>
<%--            background-color: #6a11cb;--%>
<%--            color: #fff;--%>
<%--            border: none;--%>
<%--            border-radius: 8px;--%>
<%--            font-size: 16px;--%>
<%--            font-weight: 600;--%>
<%--            cursor: pointer;--%>
<%--            transition: background-color 0.3s ease, transform 0.2s ease;--%>
<%--        }--%>

<%--        .btn:hover {--%>
<%--            background-color: #2575fc;--%>
<%--            transform: translateY(-2px);--%>
<%--        }--%>

<%--        .btn:active {--%>
<%--            transform: translateY(0);--%>
<%--        }--%>

<%--        .message {--%>
<%--            margin-top: 20px;--%>
<%--            color: #28a745;--%>
<%--            font-size: 14px;--%>
<%--            font-weight: 500;--%>
<%--        }--%>

<%--        /* Footer Styles */--%>
<%--        footer {--%>
<%--            width: 100%;--%>
<%--            padding: 15px 0;--%>
<%--            background-color: rgba(255, 255, 255, 0.2);--%>
<%--            backdrop-filter: blur(10px);--%>
<%--            text-align: center;--%>
<%--            font-size: 14px;--%>
<%--            color: #fff;--%>
<%--            border-top: 1px solid rgba(255, 255, 255, 0.1);--%>
<%--        }--%>

<%--        footer a {--%>
<%--            color: #fff;--%>
<%--            text-decoration: none;--%>
<%--            transition: color 0.3s ease;--%>
<%--        }--%>

<%--        footer a:hover {--%>
<%--            color: #6a11cb;--%>
<%--        }--%>

<%--        /* Responsive Design */--%>
<%--        @media (max-width: 480px) {--%>
<%--            .card {--%>
<%--                padding: 20px;--%>
<%--            }--%>

<%--            h2 {--%>
<%--                font-size: 20px;--%>
<%--            }--%>

<%--            input[type="tel"] {--%>
<%--                padding: 10px;--%>
<%--                font-size: 14px;--%>
<%--            }--%>

<%--            .btn {--%>
<%--                padding: 10px;--%>
<%--                font-size: 14px;--%>
<%--            }--%>

<%--            footer {--%>
<%--                font-size: 12px;--%>
<%--            }--%>
<%--        }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="container">--%>
<%--    <div class="card">--%>
<%--        <h2>Send Verification Code</h2>--%>
<%--        <form id="verificationForm" action="TwilioVerificationServlet">--%>
<%--            <div class="form-group">--%>
<%--                <label for="phoneNumber">Phone Number</label>--%>
<%--                <input type="tel" id="phoneNumber" name="phoneNumber" placeholder="Enter your phone number" required>--%>
<%--            </div>--%>
<%--            <button type="submit" class="btn">Send Code</button>--%>
<%--        </form>--%>
<%--        <div id="message" class="message"></div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- Footer -->--%>
<%--<footer>--%>
<%--    <p>&copy; 2025 Twilio sms client. All rights reserved. | <a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a></p>--%>
<%--</footer>--%>

<%--<script>--%>
<%--    document.getElementById('verificationForm').addEventListener('submit', function(event) {--%>
<%--        event.preventDefault();--%>
<%--        const phoneNumber = document.getElementById('phoneNumber').value;--%>
<%--        // Here you would typically send the phone number to your backend to send the verification code--%>
<%--        document.getElementById('message').textContent = `Verification code sent to ${phoneNumber}`;--%>
<%--    });--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>

<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <title>Send SMS with Verification</title>--%>
<%--    <style>--%>
<%--        body { font-family: Arial, sans-serif; text-align: center; }--%>
<%--        form { margin: auto; width: 50%; padding: 20px; }--%>
<%--        input, button { padding: 10px; width: 90%; margin-top: 10px; }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>

<%--<h2>Send SMS with Twilio</h2>--%>

<%--<form action="TwilioVerificationServlet" method="post">--%>
<%--    <label for="phone">Enter Phone Number:</label>--%>
<%--    <input type="text" id="phone" name="phone" required>--%>

<%--    <button type="submit" name="action" value="sendCode" style="background-color: blue; color: white;">--%>
<%--        Send Verification Code--%>
<%--    </button>--%>
<%--</form>--%>

<%--<%--%>
<%--    String sentCode = (String) session.getAttribute("verificationCode");--%>
<%--    if (sentCode != null) {--%>
<%--%>--%>
<%--<h3>Verify Code</h3>--%>
<%--<form action="TwilioVerificationServlet" method="post">--%>
<%--    <label for="code">Enter Verification Code:</label>--%>
<%--    <input type="text" id="code" name="code" required>--%>

<%--    <input type="hidden" name="phone" value="<%= request.getParameter("phone") %>">--%>
<%--    <button type="submit" name="action" value="verifyCode" style="background-color: green; color: white;">--%>
<%--        Verify & Send SMS--%>
<%--    </button>--%>
<%--</form>--%>
<%--<% } %>--%>

<%--</body>--%>
<%--</html>--%>