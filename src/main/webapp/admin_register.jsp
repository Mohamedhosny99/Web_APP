<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Administrator Registration</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        form { width: 300px; margin: auto; }
        input { width: 100%; padding: 8px; margin: 5px 0; }
        button { background-color: darkred; color: white; padding: 10px; width: 100%; }
    </style>
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
