<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat, java.sql.Date, java.sql.Time"  %>
<%@ page session="true" %>
<html>
<head>
    <title>Zumba Management Portal</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        .header {
            background-color: #2980b9;
            color: #ecf0f1;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h1 {
            margin: 0;
            font-size: 24px;
        }
        .user-session {
            float: right;
        }
        .action-btn {
            background-color: #27ae60;
            color: white;
            padding: 8px 16px;
            border: none;
            cursor: pointer;
            margin-left: 10px;
            border-radius: 4px;
        }
        .action-btn:hover {
            background-color: #218c54;
        }
        .table-container {
            width: 90%;
            margin: 30px auto;
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: #fff;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 0;
            text-align: center;
            height: 50px;
            vertical-align: middle;
        }
        th {
            background-color: #f2f2f2;
        }
        tr {
            height: 50px;
        }
        .cell-content {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
            padding: 0;
        }
        form {
            display: flex; /* Use flexbox to center the form content */
            align-items: center;
            justify-content: center;
            height: 100%;
            margin: 0; /* Remove default margins to fix alignment */
        }
        .btn-register, .btn-deregister {
            background-color: #3498db;
            color: white;
            padding: 8px 12px;
            border: none;
            cursor: pointer;
            border-radius: 4px;
            height: 30px;
            margin: 0; /* Ensure button is centered by removing default margins */
        }
        .btn-deregister {
            background-color: #e74c3c;
        }
        .btn-register:hover {
            background-color: #2980b9;
        }
        .btn-deregister:hover {
            background-color: #c0392b;
        }
        .message {
            color: #e74c3c;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Zumba Management Portal</h1>
        <div class="user-session">
            <%
                String userName = (String) session.getAttribute("userName");
                Integer userId = (Integer) session.getAttribute("userId");
                
                if (userId != null) {
            %>
                <span>Welcome, <%= userName %> !</span>
                <form method="POST" action="logout.jsp" style="display:inline;">
                    <input type="submit" class="action-btn" value="Logout">
                </form>
            <%
                } else {
            %>
                <form method="GET" action="login.jsp" style="display:inline;">
                    <input type="submit" class="action-btn" value="Login">
                </form>
            <%
                }
            %>
        </div>
    </div>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Max Capacity</th>
                    <th>Available Slots</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Database connection setup
                    String url = "jdbc:mysql://localhost:3306/zumba_management_portal";
                    String username = "root"; // replace with your MySQL username
                    String password = "Password"; // replace with your MySQL password

                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(url, username, password);
                        stmt = conn.createStatement();
                        String query = "SELECT * FROM zumba_slots";
                        rs = stmt.executeQuery(query);

                        SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MM-yy");
                        SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm");

                        while (rs.next()) {
                            Date slotDate = rs.getDate("slot_date");
                            Time slotTime = rs.getTime("slot_time");
                            int maxCapacity = rs.getInt("max_capacity");
                            int availableSlots = rs.getInt("available_slots");
                            int slotId = rs.getInt("id");

                            // Check if the user is already registered for this slot
                            boolean alreadyRegistered = false;

                            if (userId != null) {
                                // Query to check if the user has already registered for this slot
                                String checkQuery = "SELECT COUNT(*) FROM zumba_registrations WHERE user_id = ? AND slot_id = ?";
                                PreparedStatement ps = conn.prepareStatement(checkQuery);
                                ps.setInt(1, userId);
                                ps.setInt(2, slotId);
                                ResultSet checkRs = ps.executeQuery();
                                if (checkRs.next() && checkRs.getInt(1) > 0) {
                                    alreadyRegistered = true;
                                }
                                checkRs.close();
                                ps.close();
                            }
                %>
                <tr>
                    <td><div class="cell-content"><%= dateFormatter.format(slotDate) %></div></td>
                    <td><div class="cell-content"><%= timeFormatter.format(slotTime) %></div></td>
                    <td><div class="cell-content"><%= maxCapacity %></div></td>
                    <td><div class="cell-content"><%= availableSlots %></div></td>
                    <td>
                        <div class="cell-content">
                            <% if (userId == null) { %> <!-- No active session -->
                                <form action="login.jsp" method="GET">
                                    <input type="hidden" name="slotId" value="<%= slotId %>">
                                    <input type="submit" class="btn-register" value="Register">
                                </form>
                            <% } else if (alreadyRegistered) { %> <!-- Already registered -->
                                <form action="deregisterSlot.jsp" method="POST">
                                    <input type="hidden" name="slotId" value="<%= slotId %>">
                                    <input type="submit" class="btn-deregister" value="Deregister">
                                </form>
                            <% } else if (availableSlots > 0) { %> <!-- Register user for the slot -->
                                <form action="registerSlot.jsp" method="POST">
                                    <input type="hidden" name="slotId" value="<%= slotId %>">
                                    <input type="submit" class="btn-register" value="Register">
                                </form>
                            <% } else { %>
                                <span class="message">Full</span>
                            <% } %>
                        </div>
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Database connection failed: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </tbody>
        </table>
    </div>

    <%
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin != null && isAdmin) {
    %>
        <form action="admin.jsp" method="GET" style="text-align: center; margin-top: 20px;">
            <input type="submit" class="action-btn" value="Show All Entries">
        </form>
    <%
        }
    %>
</body>
</html>
