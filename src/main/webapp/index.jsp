<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Date, java.sql.Time" %>
<%@ page import="com.zumba.dao.SlotDAO, com.zumba.dao.ParticipantDAO" %>
<%@ page import="com.zumba.pojo.Slot" %>
<%@ page session="true" %>
<html>
<head>
    <title>Zumba Management Portal</title>
    <link rel="stylesheet" href="resources/css/styles.css">
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
                <span>Welcome, <%= userName %></span>
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
                    SlotDAO slotDAO = new SlotDAO();
                    ParticipantDAO participantDAO = new ParticipantDAO();
                    List<Slot> slots = slotDAO.getAllSlots();
                    SimpleDateFormat dateFormatter = new SimpleDateFormat("dd-MM-yy");
                    SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm");

                    for (Slot slot : slots) {
                        boolean alreadyRegistered = userId != null && participantDAO.isRegistered(userId, slot.getId());
                %>
                <tr>
                    <td><div class="cell-content"><%= dateFormatter.format(slot.getSlotDate()) %></div></td>
                    <td><div class="cell-content"><%= timeFormatter.format(slot.getSlotTime()) %></div></td>
                    <td><div class="cell-content"><%= slot.getMaxCapacity() %></div></td>
                    <td><div class="cell-content"><%= slot.getAvailableSlots() %></div></td>
                    <td>
                        <div class="cell-content">
                            <% if (userId == null) { %> <!-- No active session -->
                                <form action="login.jsp" method="GET">
                                    <input type="hidden" name="slotId" value="<%= slot.getId() %>">
                                    <input type="submit" class="btn-register" value="Register">
                                </form>
                            <% } else if (alreadyRegistered) { %> <!-- Already registered -->
                                <form action="deregisterSlot.jsp" method="POST">
                                    <input type="hidden" name="slotId" value="<%= slot.getId() %>">
                                    <input type="submit" class="btn-deregister" value="Deregister">
                                </form>
                            <% } else if (slot.getAvailableSlots() > 0) { %> <!-- Register user for the slot -->
                                <form action="registerSlot.jsp" method="POST">
                                    <input type="hidden" name="slotId" value="<%= slot.getId() %>">
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