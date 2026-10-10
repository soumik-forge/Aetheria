<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aetheria.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/index.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Routine — Aetheria</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <span class="logo">🌿 Aetheria</span>
        <nav>
            <a href="dashboard.jsp">Home</a>
            <a href="practices.jsp">Practices</a>
            <a href="soundscapes.jsp">Soundscapes</a>
            <a href="daily-dose.jsp">Daily Dose</a>
            <button class="toggle-switch jelly" onclick="toggleTheme()"><span class="knob"></span></button>
        </nav>
    </div>

    <div class="section">
        <h2>My Routine</h2>
        <div class="card garden-wrap">
            <div class="garden-stage" id="garden-stage">🌰</div>
            <p>Current streak: <span class="streak-count" id="streak-count">0</span> days</p>
        </div>
        <div class="card" style="text-align:center;">
            <h3>Want a full breakdown of your week?</h3>
            <a href="report" class="btn jelly" style="display:inline-block; margin-top:1rem; text-decoration:none;">View My Weekly Report Card</a>
        </div>
    </div>

    <script>window.CONTEXT_PATH = "<%= request.getContextPath() %>";</script>
    <script src="js/app.js"></script>
</body>
</html>
