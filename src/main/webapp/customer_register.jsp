<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Registration</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        form { width: 300px; margin: auto; }
        input, select { width: 100%; padding: 8px; margin: 5px 0; }
        button { background-color: blue; color: white; padding: 10px; width: 100%; }
    </style>
</head>
<body>
<h2>Registration</h2>
<form action="RegisterUserServlet" method="post">
    <input type="text" name="username" placeholder="Username" required />
    <input type="email" name="email" placeholder="Email" required />
    <input type="password" name="password" placeholder="Password" required />
    <input type="text" name="phone" placeholder="Phone Number" required />
    <select name="role" required>
        <option value="customer">Customer</option>
        <option value="admin">Admin</option>
    </select>
    <button type="submit">Register</button>
</form>
</body>
</html>
