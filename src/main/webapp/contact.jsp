<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact & Feedback — Aetheria</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <span class="logo">🌿 Aetheria</span>
        <nav>
            <a href="dashboard.jsp">Home</a>
            <a href="about.jsp">About</a>
            <button class="toggle-switch jelly" onclick="toggleTheme()"><span class="knob"></span></button>
        </nav>
    </div>

    <div class="section">
        <div class="card">
            <h2>We'd Love Your Feedback</h2>
            <% if (request.getAttribute("message") != null) { %>
                <p style="color:var(--sage); margin:0.8rem 0;"><%= request.getAttribute("message") %></p>
            <% } %>
            <form action="feedback" method="post" style="margin-top:1rem;">
                <label>Overall Rating (1-5)</label>
                <input type="number" name="ratingStars" min="1" max="5" required
                       style="width:100%; padding:0.6rem; margin:0.4rem 0 0.8rem; border-radius:10px; border:1px solid var(--border-soft);">
                <label>Ease of Use (1-5)</label>
                <input type="number" name="easeOfUse" min="1" max="5" required
                       style="width:100%; padding:0.6rem; margin:0.4rem 0 0.8rem; border-radius:10px; border:1px solid var(--border-soft);">
                <label>Calmness Level (1-5)</label>
                <input type="number" name="calmnessLevel" min="1" max="5" required
                       style="width:100%; padding:0.6rem; margin:0.4rem 0 0.8rem; border-radius:10px; border:1px solid var(--border-soft);">
                <label>UI Quality (1-5)</label>
                <input type="number" name="uiQuality" min="1" max="5" required
                       style="width:100%; padding:0.6rem; margin:0.4rem 0 0.8rem; border-radius:10px; border:1px solid var(--border-soft);">
                <textarea name="reviewText" placeholder="Tell us more..." rows="4"
                       style="width:100%; padding:0.6rem; margin-bottom:0.8rem; border-radius:10px; border:1px solid var(--border-soft);"></textarea>
                <button type="submit" class="btn jelly">Submit Feedback</button>
            </form>
        </div>
    </div>

    <script>window.CONTEXT_PATH = "<%= request.getContextPath() %>";</script>
    <script src="js/app.js"></script>
</body>
</html>
