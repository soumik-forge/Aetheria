<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aetheria.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    if (request.getAttribute("sessionCount") == null) {
        response.sendRedirect(request.getContextPath() + "/report");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Weekly Report — Aetheria</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <span class="logo">🌿 Aetheria</span>
        <nav>
            <a href="dashboard.jsp">Home</a>
            <button class="toggle-switch jelly" onclick="toggleTheme()"><span class="knob"></span></button>
        </nav>
    </div>

    <div class="section">
        <div class="card" style="text-align:center;">
            <h2>Your Week in Mindfulness</h2>
            <div style="margin:1.5rem 0;">
                <div class="report-stat"><div class="num"><%= request.getAttribute("sessionCount") %></div><div>Sessions</div></div>
                <div class="report-stat"><div class="num"><%= request.getAttribute("totalMinutes") %></div><div>Minutes</div></div>
                <div class="report-stat"><div class="num"><%= request.getAttribute("streak") %></div><div>Day Streak</div></div>
                <div class="report-stat"><div class="num"><%= request.getAttribute("journalCount") %></div><div>Reflections</div></div>
            </div>
        </div>

        <div class="report-grid">
            <div class="card">
                <h3>✅ Advantage</h3>
                <p style="color:var(--slate); margin-top:0.5rem;"><%= request.getAttribute("advantage") %></p>
            </div>
            <div class="card">
                <h3>⚠️ Watch Out For</h3>
                <p style="color:var(--slate); margin-top:0.5rem;"><%= request.getAttribute("disadvantage") %></p>
            </div>
            <div class="card">
                <h3>🎯 Your Next Move</h3>
                <p style="color:var(--slate); margin-top:0.5rem;"><%= request.getAttribute("nextMove") %></p>
            </div>
            <div class="card">
                <h3>🗺️ Next Week's Blueprint</h3>
                <p style="color:var(--slate); margin-top:0.5rem;"><%= request.getAttribute("blueprint") %></p>
            </div>
        </div>
    </div>

    <script>window.CONTEXT_PATH = "<%= request.getContextPath() %>";</script>
    <script src="js/app.js"></script>
</body>
</html>
