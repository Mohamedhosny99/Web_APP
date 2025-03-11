<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Twilio SMS Client</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: url('photos/3.jpg') no-repeat center center fixed;
            background-size: cover;
            position: relative;
        }
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5); /* Semi-transparent overlay */
            backdrop-filter: blur(5px); /* Blur effect */
        }
        .login-container {
            background-color: rgba(255, 255, 255, 0.9); /* Semi-transparent white */
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            width: 350px;
            text-align: center;
            animation: fadeIn 0.5s ease-in-out;
            position: relative;
            z-index: 1;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .login-container h2 {
            margin-bottom: 20px;
            color: #333;
            font-size: 24px;
            font-weight: 600;
        }
        .login-container input {
            width: 90%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        .login-container input:focus {
            border-color: #007bff;
            outline: none;
        }
        .login-container button {
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .login-container button:hover {
            background-color: #0056b3;
        }
        .register-link {
            margin-top: 15px;
            display: block;
            color: #007bff;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s ease;
        }
        .register-link:hover {
            color: #0056b3;
            text-decoration: underline;
        }
        .footer {
            margin-top: 20px;
            font-size: 12px;
            color: #666;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h2>Login</h2>
    <form action="LoginServlet" method="POST">
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit">Login</button>
    </form>
    <br>
    <a href="home.jsp">Create an Account</a>

    <div class="footer">&copy; 2025 Twilio SMS Client</div>
</div>
</body>
</html>