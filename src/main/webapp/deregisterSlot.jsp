<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    int slotId = Integer.parseInt(request.getParameter("slotId"));

    if (userId != null) {
        String url = "jdbc:mysql://localhost:3306/zumba_management_portal";
        String username = "root"; // replace with your MySQL username
        String password = "Password"; // replace with your MySQL password

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, username, password);

            // Remove registration entry
            String deleteQuery = "DELETE FROM zumba_registrations WHERE user_id = ? AND slot_id = ?";
            ps = conn.prepareStatement(deleteQuery);
            ps.setInt(1, userId);
            ps.setInt(2, slotId);
            ps.executeUpdate();

            // Update available slots
            String updateSlots = "UPDATE zumba_slots SET available_slots = available_slots + 1 WHERE id = ?";
            ps = conn.prepareStatement(updateSlots);
            ps.setInt(1, slotId);
            ps.executeUpdate();

            response.sendRedirect("index.jsp");

        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    } else {
        response.sendRedirect("login.jsp");
    }
%>
