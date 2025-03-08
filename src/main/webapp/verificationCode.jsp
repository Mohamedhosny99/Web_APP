<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Verification Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f0f2f5;
        }
        .container {
            max-width: 400px;
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
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
        }
        input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 16px;
        }
        .verify-btn, .send-code-btn {
            width: 100%;
            padding: 12px;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
            margin-bottom: 10px; /* Add spacing between buttons */
        }
        .verify-btn {
            background-color: #1a73e8;
        }
        .verify-btn:hover {
            background-color: #1557b0;
        }
        .verify-btn:active {
            background-color: #104080;
        }
        .send-code-btn {
            background-color: #28a745; /* Green color for the Send Code button */
        }
        .send-code-btn:hover {
            background-color: #218838;
        }
        .send-code-btn:active {
            background-color: #1e7e34;
        }
        .message {
            text-align: center;
            margin-top: 10px;
            color: #666;
        }
        .message a {
            color: #1a73e8;
            text-decoration: none;
        }
        .message a:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        function sendCode() {
            // Submit the form to the
            document.getElementById("verificationForm").action = "/VerifyPhoneServlet";
            document.getElementById("verificationForm").method = "POST";
            document.getElementById("verificationForm").submit();
        }
    </script>
</head>
<body>
<div class="container">
    <h2>Verification</h2>
    <form id="verificationForm" action="/TwilioVerificationServlet" method="POST">
        <div class="form-group">
            <label for="verificationCode">Enter Verification Code:</label>
            <input type="text" id="verificationCode" name="verificationCode"
                   placeholder="Enter your code" required>
            <input type="hidden" name="phone" value="<%= session.getAttribute("phone") %>">
        </div>
        <button type="submit" name="action" value="verifyCode" >Verify</button>
        <button type="submit" name="action" value="sendCode">Send Code</button>
    </form>
    <p class="message">
        Didn't receive the code?
        <a href="resendCode">Resend Code</a>
    </p>
</div>
</body>
</html>