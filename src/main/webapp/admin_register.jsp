<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Administrator Registration</title>
    <link rel="stylesheet" type="text/css" href="Stylesheet/RegStyle.css">
</head>
<body>
<h2>Administrator Registration</h2>
<form action="RegisterAdminServlet" method="post">
    <input type="text" name="adminName" placeholder="Full Name" required />
    <input type="email" name="adminEmail" placeholder="Email" required />
    <input type="password" name="adminPassword" placeholder="Password" required />
    <input type="text" name="adminCode" placeholder="Admin Code" required />
    <button type="submit">Register</button>
</form>
</body>
</html>
