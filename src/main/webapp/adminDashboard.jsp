<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard</title>
  <style>
    /* General Reset */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Arial', sans-serif;
      background: linear-gradient(rgba(106, 17, 203, 0.8), rgba(37, 117, 252, 0.8)), url('background.jpg'); /* Gradient overlay on background image */
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
      padding: 40px;
      border-radius: 15px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.1);
      animation: fadeIn 1s ease-in-out;
      width: 100%;
      max-width: 600px;
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
      font-size: 36px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 2px;
    }

    p {
      color: #555;
      font-size: 18px;
      line-height: 1.6;
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
        font-size: 28px;
      }

      p {
        font-size: 16px;
      }
    }
  </style>
</head>
<body>
<!-- Header -->
<header>
  <h1>Admin Dashboard</h1>
  <nav>
    <a href="#">Home</a>
    <a href="login.jsp">Logout</a>
    <a href="list-user.jsp">List Users</a>
  </nav>
</header>

<!-- Main Content -->
<div class="container">
  <div class="card">
    <h2>Welcome to Admin Dashboard</h2>
    <p>
      You are now in the admin dashboard. From here, you can manage users and perform administrative tasks.
    </p>
  </div>
</div>

<!-- Footer -->
<footer>
  <p>&copy; 2025 Twilio sms Client. All rights reserved. | <a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a></p>
</footer>
</body>
</html>