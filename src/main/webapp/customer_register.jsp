<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Twilio SMS Client</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: url('photos/3.jpg') no-repeat center center fixed;
            background-size: cover;
            position: relative;
            overflow: hidden; /* Prevent scrolling */
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
        .register-container {
            background-color: rgba(255, 255, 255, 0.9); /* Semi-transparent white */
            padding: 15px; /* Further reduced padding */
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            width: 350px; /* Smaller width for the form */
            text-align: center;
            animation: fadeIn 0.5s ease-in-out;
            position: relative;
            z-index: 1;
            margin: 20px; /* Add some margin for smaller screens */
            max-height: 90vh; /* Limit height to 90% of viewport height */
            overflow-y: auto; /* Allow scrolling inside the form if needed */
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .register-container h2 {
            margin-bottom: 10px; /* Further reduced margin */
            color: #333;
            font-size: 20px; /* Slightly smaller font size */
            font-weight: 600;
        }
        .progress-bar {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px; /* Further reduced margin */
        }
        .progress-step {
            flex: 1;
            height: 6px; /* Thinner progress bar */
            background-color: #ddd;
            margin: 0 5px;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }
        .progress-step.active {
            background-color: #007bff;
        }
        .register-container input {
            width: 80%;
            padding: 8px; /* Reduced padding */
            margin: 5px 0; /* Further reduced margin */
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 13px; /* Slightly smaller font size */
            transition: all 0.3s ease;
        }
        .register-container input:focus {
            border-color: #007bff;
            outline: none;
            transform: scale(1.02);
        }
        .register-container button {
            width: 100%;
            padding: 10px; /* Reduced padding */
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 14px; /* Slightly smaller font size */
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .register-container button:hover {
            background-color: #0056b3;
        }
        .login-link {
            margin-top: 10px; /* Reduced margin */
            display: block;
            color: #007bff;
            text-decoration: none;
            font-size: 13px; /* Slightly smaller font size */
            transition: color 0.3s ease;
        }
        .login-link:hover {
            color: #0056b3;
            text-decoration: underline;
        }
        .footer {
            margin-top: 10px; /* Reduced margin */
            font-size: 11px; /* Slightly smaller font size */
            color: #666;
            position: sticky; /* Stick to the bottom of the form */
            bottom: 0;
            background-color: rgba(255, 255, 255, 0.9); /* Match form background */
            padding: 5px 0; /* Add some padding */
            border-top: 1px solid #ddd; /* Add a border to separate from the form */
        }
    </style>
</head>
<body>
<div class="register-container">
    <h2>Register</h2>
    <form action="RegisterCustomerServlet" method="POST">
        <input type="text" name="name" placeholder="Name" required>
        <input type="date" name="birthday" placeholder="Birthday" required>
        <input type="password" name="password" placeholder="Password" required>
        <input type="text" name="phone" placeholder="Phone Number (MSISDN)" required>
        <input type="text" name="role" placeholder="Job" required>
        <input type="email" name="email" placeholder="Email" required>
        <input type="text" name="address" placeholder="Address" required>
        <input type="Password" name="twilioSID" placeholder="Twilio Account SID" required>
        <input type="Password" name="twilioToken" placeholder="Twilio Token" required>
        <input type="text" name="senderID" placeholder="Twilio Allowed SenderID" required>
        <button type="submit">Register</button>
    </form>
    <a href="login.jsp" class="login-link">Already have an account? Login here</a>
    <div class="footer">&copy; 2025 Twilio SMS Client</div>
</div>
</body>
</html>