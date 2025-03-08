<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Send SMS with Verification</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        form { margin: auto; width: 50%; padding: 20px; }
        input, button { padding: 10px; width: 90%; margin-top: 10px; }
    </style>
</head>
<body>

<h2>Send SMS with Twilio</h2>

<form action="TwilioVerificationServlet" method="post"> <!-- Ensure this matches the servlet URL -->
    <label for="phone">Enter Phone Number:</label>
    <input type="text" id="phone" name="phone" required>

    <button type="submit" name="action" value="sendCode" style="background-color: blue; color: white;">
        Send Verification Code
    </button>
</form>

<%
    String sentCode = (String) session.getAttribute("verificationCode");
    if (sentCode != null) {
%>
<h3>Verify Code</h3>
<form action="TwilioVerificationServlet" method="post"> <!-- Ensure this matches the servlet URL -->
    <label for="code">Enter Verification Code:</label>
    <input type="text" id="code" name="code" required>

    <input type="hidden" name="phone" value="<%= request.getParameter("phone") %>">
    <button type="submit" name="action" value="verifyCode" style="background-color: green; color: white;">
        Verify & Send SMS
    </button>
</form>
<% } %>

</body>
</html>