<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>About — Aetheria</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <span class="logo">🌿 Aetheria</span>
        <nav>
            <a href="dashboard.jsp">Home</a>
            <a href="contact.jsp">Contact</a>
            <button class="toggle-switch jelly" onclick="toggleTheme()"><span class="knob"></span></button>
        </nav>
    </div>

    <div class="section">
        <div class="card">
            <h2>About Aetheria</h2>
            <p style="color:var(--slate); margin-top:1rem;">
                Aetheria is a 100% free online meditation and mindfulness platform, built to make guided
                stillness accessible to everyone — no paywalls, no subscriptions, ever.
            </p>
            <h3 style="margin-top:1.5rem;">Creator</h3>
            <p style="color:var(--slate); margin-top:0.5rem;">
                Soumik Chatterjee — "Boost With Soumik"<br>
                B.Tech CSE (AI & ML), Galgotias University
            </p>
        </div>
    </div>

    <script>window.CONTEXT_PATH = "<%= request.getContextPath() %>";</script>
    <script src="js/app.js"></script>
</body>
</html>
