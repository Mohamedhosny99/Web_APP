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
    }
    input[type="text"] {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
        box-sizing: border-box;
    }
    .verify-btn {
        width: 100%;
        padding: 10px;
        background-color: #1a73e8;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    .verify-btn:hover {
        background-color: #1557b0;
    }
    .message {
        text-align: center;
        margin-top: 10px;
        color: #666;
    }
</style>
</head>
<body>
<div class="container">
    <h2>Verification</h2>
    <form action="verify" method="POST">
        <div class="form-group">
            <label for="verificationCode">Enter Verification Code:</label>
            <input type="text" id="verificationCode" name="verificationCode" 
                   placeholder="Enter your code" required>
        </div>
        <button type="submit" class="verify-btn">Verify</button>
    </form>
    <p class="message">
        Didn't receive the code? 
        <a href="resendCode">Resend Code</a>
    </p>
</div>
</body>
</html