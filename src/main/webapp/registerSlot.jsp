<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<html>
<body>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    int slotId = Integer.parseInt(request.getParameter("slotId"));

    if (userId != null) {
        try {
            String url = "jdbc:mysql://localhost:3306/zumba_management_portal";
            String username = "root"; // replace with your MySQL username
            String password = "Password"; // replace with your MySQL password

            Connection conn = DriverManager.getConnection(url, username, password);
            conn.setAutoCommit(false);

            // Insert the registration
            String insertQuery = "INSERT INTO zumba_registrations (user_id, slot_id) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(insertQuery);
            ps.setInt(1, userId);
            ps.setInt(2, slotId);
            ps.executeUpdate();

            // Decrease the slot availability
            String updateSlotQuery = "UPDATE zumba_slots SET available_slots = available_slots - 1 WHERE id = ?";
            PreparedStatement psUpdate = conn.prepareStatement(updateSlotQuery);
            psUpdate.setInt(1, slotId);
            psUpdate.executeUpdate();

            conn.commit();
            ps.close();
            psUpdate.close();
            conn.close();

            response.sendRedirect("index.jsp"); // Redirect back to the main page

        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
%>
</body>
</html>