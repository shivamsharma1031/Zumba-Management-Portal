<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<html>
<head>
    <title>All Zumba Sessions</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .header {
            background-color: #2c3e50;
            color: #ecf0f1;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            width:100%;
        }
        .back-button {
            display: block;
            margin: 20px auto;
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            width: 200px;
        }
        .back-button:hover {
            background-color: #2980b9;
        }
        .session-heading {
            margin-top: 20px;
            font-size: 20px;
            color: #333;
            text-align: left;
            width: 80%;
        }
        .session-table {
            width: 80%;
            margin: 20px 0;
            border-collapse: collapse;
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .session-table, .session-table th, .session-table td {
            border: 1px solid #ddd;
        }
        .session-table th, .session-table td {
            padding: 12px;
            text-align: center;
        }
        .session-table th {
            background-color: #f2f2f2;
        }
        .no-privilege-message {
            margin: 20px;
            color: red;
            font-weight: bold;
            text-align: center;
        }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />
    <a href="index.jsp" class="back-button">Back to Home</a>
    
    <%
    Boolean isAllowed = (Boolean) session.getAttribute("isAdmin");
    if (isAllowed == null || !isAllowed) {
    %>
        <div class="no-privilege-message">No privilege to view this page.</div>
    <%
    } else {
        // Database connection setup
        String url = "jdbc:mysql://localhost:3306/zumba_management_portal";
        String username = "root"; // replace with your MySQL username
        String password = "Password"; // replace with your MySQL password

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rsSlots = null;
        ResultSet rsParticipants = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, username, password);

            // Query to get all slots
            String slotsQuery = "SELECT id, slot_date, slot_time FROM zumba_slots";
            pstmt = conn.prepareStatement(slotsQuery);
            rsSlots = pstmt.executeQuery();

            while (rsSlots.next()) {
                int slotId = rsSlots.getInt("id");
                String slotDate = rsSlots.getString("slot_date");
                String slotTime = rsSlots.getString("slot_time");

    %>
    <!-- Display the slot date and time as a heading -->
    <div class="session-heading">Zumba Slot: <%= slotDate %> at <%= slotTime %></div>

    <!-- Table for participants under each slot -->
    <table class="session-table">
        <thead>
            <tr>
                <th>Participant Name</th>
                <th>Email</th>
                <th>Weight (kg)</th>
                <th>Height (cm)</th>
            </tr>
        </thead>
        <tbody>
        <%
            // Query to get participants registered for this slot
            String participantsQuery = "SELECT u.name, u.email, u.weight, u.height " +
                                       "FROM zumba_registrations r " +
                                       "JOIN users u ON r.user_id = u.id " +
                                       "WHERE r.slot_id = ?";
            PreparedStatement psParticipants = conn.prepareStatement(participantsQuery);
            psParticipants.setInt(1, slotId);
            rsParticipants = psParticipants.executeQuery();

            boolean hasParticipants = false;
            while (rsParticipants.next()) {
                hasParticipants = true;
                String participantName = rsParticipants.getString("name");
                String email = rsParticipants.getString("email");
                double weight = rsParticipants.getDouble("weight");
                double height = rsParticipants.getDouble("height");
        %>
        <tr>
            <td><%= participantName %></td>
            <td><%= email %></td>
            <td><%= weight %></td>
            <td><%= height %></td>
        </tr>
        <%
            }

            if (!hasParticipants) {
        %>
        <!-- Message when there are no participants for a slot -->
        <tr>
            <td colspan="4">No participants registered for this slot.</td>
        </tr>
        <%
            }

            // Close participants result set and statement
            rsParticipants.close();
            psParticipants.close();
        %>
        </tbody>
    </table>

    <%
            }

        } catch (Exception e) {
            out.println("<p class='error'>Database connection failed: " + e.getMessage() + "</p>");
        } finally {
            if (rsSlots != null) rsSlots.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    } 
    %>

</body>
</html>
