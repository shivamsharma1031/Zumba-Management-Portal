<%@ page session="true" %>
            
<div class="header" style="background-color: #2980b9; color: #ecf0f1; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; margin: 0 20px; border-radius: 8px;">
    <h1 style="margin: 0px 20px; font-size: 24px;">Zumba Management Portal</h1>
    <div class="user-session" style="margin:0px 20px;">
        <%
            String userName = (String) session.getAttribute("userName");
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId != null) {
        %>
            <span>Welcome, <%= userName %></span>
            <form method="POST" action="logout.jsp" style="display:inline;">
                <input type="submit" class="action-btn" value="Logout" style="background-color: #27ae60; color: white; padding: 8px 16px; border: none; cursor: pointer; margin-left: 10px; border-radius: 4px;">
            </form>
        <%
            } else {
        %>
            <form method="GET" action="login.jsp" style="display:inline;">
                <input type="submit" class="action-btn" value="Login" style="background-color: #27ae60; color: white; padding: 8px 16px; border: none; cursor: pointer; margin-left: 10px; border-radius: 4px;">
            </form>
        <%
            }
        %>
    </div>
</div>
