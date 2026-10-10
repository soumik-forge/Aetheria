<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aetheria.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/index.jsp"); return; }

    String[] quotes = {
        "Stillness is where clarity begins.",
        "You don't have to control your thoughts. You just have to stop letting them control you.",
        "The mind is everything. What you think, you become.",
        "Breathing in, I calm body and mind. Breathing out, I smile.",
        "Peace comes from within. Do not seek it without."
    };
    String todayQuote = quotes[(int)(System.currentTimeMillis() / 86400000) % quotes.length];
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Daily Dose — Aetheria</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <span class="logo">🌿 Aetheria</span>
        <nav>
            <a href="dashboard.jsp">Home</a>
            <a href="practices.jsp">Practices</a>
            <a href="soundscapes.jsp">Soundscapes</a>
            <a href="my-routine.jsp">My Routine</a>
            <button class="toggle-switch jelly" onclick="toggleTheme()"><span class="knob"></span></button>
        </nav>
    </div>

    <div class="section" style="text-align:center;">
        <h2>Your Daily Dose of Calm</h2>
        <div class="card" style="max-width:500px; margin:2rem auto;">
            <p class="hero-quote" style="font-size:1.3rem;">"<%= todayQuote %>"</p>
        </div>
        <div class="breathing-wrap"><div class="breathing-ring"></div></div>
        <p class="breathing-label">Take one mindful minute right now — just breathe.</p>
    </div>

    <script>window.CONTEXT_PATH = "<%= request.getContextPath() %>";</script>
    <script src="js/app.js"></script>
</body>
</html>
