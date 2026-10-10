<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Aetheria — Online Meditation & Mindfulness</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="ambient-bar">
        <span id="ambient-clock">Loading...</span>
        <span>100% Free — No Paywalls, Ever</span>
    </div>

    <div style="display:flex; min-height:85vh; align-items:center; justify-content:center; padding:2rem;">
        <div class="card" style="max-width:420px; width:100%; text-align:center;">
            <h1 style="color:var(--sage); margin-bottom:0.3rem;">🌿 Aetheria</h1>
            <p style="color:var(--slate); margin-bottom:1.5rem;">Online Meditation and Mindfulness Platform</p>

            <% if (request.getAttribute("error") != null) { %>
                <p style="color:#C25450; margin-bottom:1rem;"><%= request.getAttribute("error") %></p>
            <% } %>
            <% if (request.getAttribute("message") != null) { %>
                <p style="color:var(--sage); margin-bottom:1rem;"><%= request.getAttribute("message") %></p>
            <% } %>

            <!-- Login Form -->
            <form action="<%= request.getContextPath() %>/auth/login" method="post" style="margin-bottom:1.5rem;">
                <input type="text" name="userIdStr" placeholder="User ID (e.g. Soumik@2007)" required
                       style="width:100%; padding:0.7rem; margin-bottom:0.7rem; border-radius:10px; border:1px solid var(--border-soft);">
                <input type="password" name="password" placeholder="Password (your birth year)" required
                       style="width:100%; padding:0.7rem; margin-bottom:0.7rem; border-radius:10px; border:1px solid var(--border-soft);">
                <button type="submit" class="btn jelly" style="width:100%;">Start Meditating</button>
            </form>

            <hr style="border:none; border-top:1px solid var(--border-soft); margin:1.2rem 0;">

            <!-- Register Form -->
            <details>
                <summary style="cursor:pointer; color:var(--terracotta);">New here? Create a free account</summary>
                <form action="<%= request.getContextPath() %>/auth/register" method="post" style="margin-top:1rem; text-align:left;">
                    <input type="text" name="username" placeholder="Your Name" required
                           style="width:100%; padding:0.6rem; margin-bottom:0.6rem; border-radius:10px; border:1px solid var(--border-soft);">
                    <input type="number" name="birthYear" placeholder="Birth Year (e.g. 2007)" required
                           style="width:100%; padding:0.6rem; margin-bottom:0.6rem; border-radius:10px; border:1px solid var(--border-soft);">
                    <input type="number" name="age" placeholder="Age (optional)"
                           style="width:100%; padding:0.6rem; margin-bottom:0.6rem; border-radius:10px; border:1px solid var(--border-soft);">
                    <button type="submit" class="btn btn-terracotta jelly" style="width:100%;">Create Account</button>
                </form>
            </details>

            <p class="hero-quote" style="margin-top:1.5rem; font-size:0.85rem;">"Stillness is where clarity begins."</p>
        </div>
    </div>

    <script>window.CONTEXT_PATH = "<%= request.getContextPath() %>";</script>
    <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
