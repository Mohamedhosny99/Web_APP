<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verification Code</title>
    <style>
        /* General Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(rgba(106, 17, 203, 0.8), rgba(37, 117, 252, 0.8)); /* Gradient overlay on background image */
            background-size: cover;
            background-position: center;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            color: #333;
        }

        /* Header Styles */
        header {
            background-color: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        header h1 {
            font-size: 24px;
            font-weight: 600;
            color: #fff;
        }

        header nav {
            display: flex;
            gap: 20px;
        }

        header nav a {
            color: #fff;
            text-decoration: none;
            font-size: 16px;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        header nav a:hover {
            color: #6a11cb;
        }

        /* Main Content Styles */
        .container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .card {
            background-color: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            animation: fadeIn 1s ease-in-out;
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        h2 {
            margin-bottom: 20px;
            color: #6a11cb;
            font-size: 28px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-size: 14px;
            font-weight: 500;
        }

        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            background-color: rgba(255, 255, 255, 0.9);
            transition: border-color 0.3s ease;
        }

        .form-group input:focus {
            border-color: #6a11cb;
            outline: none;
        }

        .buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .buttons button {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .buttons button.verify {
            background-color: #6a11cb;
            color: #fff;
        }

        .buttons button.resend {
            background-color: #28a745;
            color: #fff;
        }

        .buttons button:hover {
            opacity: 0.9;
        }

        /* Footer Styles */
        footer {
            width: 100%;
            padding: 15px 0;
            background-color: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            text-align: center;
            font-size: 14px;
            color: #fff;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        footer a {
            color: #fff;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        footer a:hover {
            color: #6a11cb;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            header {
                flex-direction: column;
                gap: 10px;
            }

            header nav {
                gap: 10px;
            }

            .card {
                padding: 20px;
            }

            h2 {
                font-size: 24px;
            }

            .buttons {
                flex-direction: column;
            }

            .buttons button {
                width: 100%;
            }
        }
    </style>
    <script>
        function resendCode() {
            const form = document.getElementById("verificationForm");
            form.action = "/TwilioVerificationServlet";
            form.method = "POST";

            // Add hidden input for action
            const actionInput = document.createElement("input");
            actionInput.type = "hidden";
            actionInput.name = "action";
            actionInput.value = "sendCode";
            form.appendChild(actionInput);

            // Add hidden input for phone
            const phoneInput = document.createElement("input");
            phoneInput.type = "hidden";
            phoneInput.name = "phone";
            phoneInput.value = "<%= session.getAttribute("phone") %>";
            form.appendChild(phoneInput);

            form.submit();
        }
    </script>
</head>
<body>
<!-- Header -->
<header>
    <h1>Verification Code</h1>
    <nav>
        <a href="home.jsp">Home</a>
        <a href="login.jsp">Logout</a>
    </nav>
</header>

<!-- Main Content -->
<div class="container">
    <div class="card">
        <h2>Enter Verification Code</h2>
        <form id="verificationForm" action="/TwilioVerificationServlet" method="POST">
            <div class="form-group">
                <label for="codeInput">Verification Code</label>
                <input type="text" id="codeInput" name="code" placeholder="Enter verification code" required>
            </div>
            <!-- Add hidden input for phone -->
            <input type="hidden" name="phone" value="<%= session.getAttribute("phone") %>">
            <input type="hidden" name="action" value="verifyCode"> <!-- Hidden input for action -->
            <div class="buttons">
                <button type="submit" class="verify">Verify</button>
                <button type="button" class="resend" onclick="resendCode()">Resend Code</button>
            </div>
        </form>
    </div>
</div>

<!-- Footer -->
<footer>
    <p>&copy; 2025 Twilio sms client. All rights reserved. | <a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a></p>
</footer>
</body>
</html>