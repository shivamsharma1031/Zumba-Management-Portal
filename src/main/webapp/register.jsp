<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String errorMessage = "";
    String name = request.getParameter("name") != null ? request.getParameter("name") : "";
    String phone = request.getParameter("phone") != null ? request.getParameter("phone") : "";
    String email = request.getParameter("email") != null ? request.getParameter("email") : "";
    String password = request.getParameter("password") != null ? request.getParameter("password") : "";
    String confirmPassword = request.getParameter("confirmPassword") != null ? request.getParameter("confirmPassword") : "";
    String weightStr = request.getParameter("weight") != null ? request.getParameter("weight") : "";
    String heightStr = request.getParameter("height") != null ? request.getParameter("height") : "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        double weight = 0;
        double height = 0;
        try {
            weight = Double.parseDouble(weightStr);
            height = Double.parseDouble(heightStr);
        } catch (NumberFormatException e) {
            errorMessage = "Please enter valid numbers for weight and height.";
        }

        if (!password.equals(confirmPassword)) {
            errorMessage = "Passwords do not match!";
        } else if (errorMessage.isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/zumba_management_portal", "root", "Password");
                String query = "INSERT INTO users (name, phone, email, password, weight, height, isAdmin) VALUES (?, ?, ?, ?, ?, ?, false)";
                PreparedStatement stmt = con.prepareStatement(query);
                stmt.setString(1, name);
                stmt.setString(2, phone);
                stmt.setString(3, email);
                stmt.setString(4, password);
                stmt.setDouble(5, weight);
                stmt.setDouble(6, height);

                stmt.executeUpdate();
                stmt.close();
                con.close();

                // Redirect to login page after successful registration
                response.sendRedirect("login.jsp");
                return;
            } catch (Exception e) {
                errorMessage = "Error: Unable to register. Please try again later.";
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
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
            max-width: 400px; /* Match with the form width */
            text-align: center;
            border-radius: 8px 8px 0 0;
            box-sizing: border-box;
            text-decoration: none;
        }
        .register-container {
            width: 100%;
            max-width: 400px;
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
            margin-bottom: 10px;
        }
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #3498db;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        function validateForm() {
            let phone = document.forms["registerForm"]["phone"].value;
            let weight = document.forms["registerForm"]["weight"].value;
            let height = document.forms["registerForm"]["height"].value;
            let phonePattern = /^[0-9]{10}$/;

            if (!phonePattern.test(phone)) {
                alert("Please enter a valid 10-digit phone number.");
                return false;
            }

            if (weight <= 0 || height <= 0) {
                alert("Weight and height must be positive numbers.");
                return false;
            }

            return true;
        }
    </script>
</head>
<body>

<a href="index.jsp" class="header">
    Zumba Management Portal
</a>

<div class="register-container">
    <h2>Register</h2>

    <form name="registerForm" method="post" action="register.jsp" onsubmit="return validateForm()">
        <% if (!errorMessage.isEmpty()) { %>
            <div class="error"><%= errorMessage %></div>
        <% } %>
        <input class="input-field" type="text" name="name" placeholder="Full Name" value="<%= name %>" required />
        <input class="input-field" type="text" name="phone" placeholder="Phone Number" value="<%= phone %>" required pattern="[0-9]{10}" title="Please enter a valid 10-digit phone number." />
        <input class="input-field" type="email" name="email" placeholder="Email" value="<%= email %>" required />
        <input class="input-field" type="password" name="password" placeholder="Password" required />
        <input class="input-field" type="password" name="confirmPassword" placeholder="Confirm Password" required />
        <input class="input-field" type="number" name="weight" placeholder="Weight (kg)" value="<%= weightStr %>" step="0.1" required min="0" />
        <input class="input-field" type="number" name="height" placeholder="Height (cm)" value="<%= heightStr %>" required min="0" />
        <button class="submit-btn" type="submit">Register</button>
    </form>

    <a href="login.jsp" class="back-link">Back to Login</a>

</div>

</body>
</html>
