<%@ page import="java.util.List" %>
<%@ page import="com.zumba.dao.SlotDAO, com.zumba.dao.ParticipantDAO" %>
<%@ page import="com.zumba.pojo.Slot, com.zumba.pojo.Participant" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
        SlotDAO slotDAO = new SlotDAO();
        ParticipantDAO participantDAO = new ParticipantDAO();

        // Fetch all slots
        List<Slot> slots = slotDAO.getAllSlots();

        // Define date and time formatters
        SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MM-yy");
        SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm");

        for (Slot slot : slots) {
            // Format slot date and time
            String slotDate = dateFormatter.format(slot.getSlotDate());
            String slotTime = timeFormatter.format(slot.getSlotTime());
            int slotId = slot.getId();
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
            // Fetch participants registered for this slot
            List<Participant> participants = participantDAO.getParticipantsBySlotId(slotId);

            if (participants.isEmpty()) {
        %>
        <!-- Message when there are no participants for a slot -->
        <tr>
            <td colspan="4">No participants registered for this slot.</td>
        </tr>
        <%
            } else {
                for (Participant participant : participants) {
        %>
        <tr>
            <td><%= participant.getName() %></td>
            <td><%= participant.getEmail() %></td>
            <td><%= participant.getWeight() %></td>
            <td><%= participant.getHeight() %></td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>
<%
        }
    }
%>

</body>
</html>
