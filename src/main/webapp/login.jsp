<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String errorMessage = "";
    String email = request.getParameter("email") != null ? request.getParameter("email") : "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String password = request.getParameter("password");

        // Database connection
        String url = "jdbc:mysql://localhost:3306/zumba_management_portal";
        String dbUsername = "root"; // replace with your MySQL username
        String dbPassword = "Password"; // replace with your MySQL password

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);

            // Validate user credentials
            String query = "SELECT * FROM users WHERE email = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                if (rs.getString("password").equals(password)) {
                    // Valid login, set session attributes
                    session.setAttribute("userName", rs.getString("name"));
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("isAdmin", rs.getBoolean("isAdmin"));

                    response.sendRedirect("index.jsp"); // Redirect to main page after login
                    return;
                } else {
                    errorMessage = "Invalid password! Please try again.";
                }
            } else {
                errorMessage = "Invalid email or password!";
            }

        } catch (Exception e) {
            errorMessage = "Error: " + e.getMessage();
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .header {
            background-color: #2980b9;
            color: white;
            font-size: 20px;
            padding: 10px 20px;
            width: 100%;
            max-width: 360px; /* Match with the form width */
            text-align: center;
            border-radius: 8px 8px 0 0;
            box-sizing: border-box;
            text-decoration: none;
        }
        .login-container {
            width: 100%;
            max-width: 360px; /* Match with the header width */
            padding: 20px 30px;
            background-color: #fff;
            border-radius: 0 0 10px 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            box-sizing: border-box;
        }
        h2 {
            text-align: center;
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
        }
        .input-field {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
            outline: none;
            transition: border-color 0.3s;
        }
        .input-field:focus {
            border-color: #3498db;
        }
        .password-container {
            position: relative;
        }
        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #888;
            font-size: 18px;
        }
        .submit-btn {
            width: 100%;
            padding: 12px;
            background-color: #3498db;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s;
            margin-top: 10px;
        }
        .submit-btn:hover {
            background-color: #2980b9;
        }
        .error {
            color: red;
            text-align: center;
            margin-top: 10px;
        }
        .register-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #3498db;
            text-decoration: none;
        }
        .register-link:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        function togglePassword() {
            var passwordField = document.getElementById("password");
            var toggleIcon = document.getElementById("togglePassword");
            if (passwordField.type === "password") {
                passwordField.type = "text";
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordField.type = "password";
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
    </script>
    <!-- Link to Font Awesome for eye icon -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

<a href="index.jsp" class="header">
    Zumba Management Portal
</a>

<div class="login-container">
    <h2>Login</h2>

    <form method="POST" action="login.jsp">
        <input type="email" name="email" class="input-field" placeholder="Email" value="<%= email %>" required>
        <div class="password-container">
            <input type="password" name="password" id="password" class="input-field" placeholder="Password" required>
            <i id="togglePassword" class="fas fa-eye password-toggle" onclick="togglePassword()"></i>
        </div>
        <input type="submit" class="submit-btn" value="Login">
    </form>

    <a href="register.jsp" class="register-link">New User? Register here</a>

    <% if (!errorMessage.isEmpty()) { %>
        <div class="error"><%= errorMessage %></div>
    <% } %>

</div>

</body>
</html>
