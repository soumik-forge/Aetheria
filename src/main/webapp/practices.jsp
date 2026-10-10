<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%@ page import="com.aetheria.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/index.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Practices — Aetheria</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <span class="logo">🌿 Aetheria</span>
        <nav>
            <a href="dashboard.jsp">Home</a>
            <a href="soundscapes.jsp">Soundscapes</a>
            <a href="daily-dose.jsp">Daily Dose</a>
            <a href="my-routine.jsp">My Routine</a>
            <button class="toggle-switch jelly" onclick="toggleTheme()"><span class="knob"></span></button>
        </nav>
    </div>

    <div class="section">
        <div class="card">
            <h2>Body & Time Guide</h2>
            <p style="color:var(--slate); margin-bottom:1rem;">Tell us about yourself and how much time you have — we'll build a session breakdown just for you.</p>
            <form id="profiler-form" onsubmit="return false;">
                <input type="number" id="age" placeholder="Age" required style="width:100%; padding:0.6rem; margin-bottom:0.6rem; border-radius:10px; border:1px solid var(--border-soft);">
                <input type="number" id="height" placeholder="Height (cm)" required style="width:100%; padding:0.6rem; margin-bottom:0.6rem; border-radius:10px; border:1px solid var(--border-soft);">
                <input type="number" id="weight" placeholder="Weight (kg)" required style="width:100%; padding:0.6rem; margin-bottom:0.6rem; border-radius:10px; border:1px solid var(--border-soft);">
                <select id="goalMinutes" style="width:100%; padding:0.6rem; margin-bottom:0.8rem; border-radius:10px; border:1px solid var(--border-soft);">
                    <option value="15">15 minutes</option>
                    <option value="30">30 minutes</option>
                    <option value="60">1 hour</option>
                </select>
                <button class="btn jelly" onclick="generatePlan()">Generate My Plan</button>
            </form>
        </div>
        <div id="plan-result"></div>
    </div>

    <script>window.CONTEXT_PATH = "<%= request.getContextPath() %>";</script>
    <script src="js/app.js"></script>
    <script>
        async function generatePlan() {
            const body = `age=${document.getElementById('age').value}&height=${document.getElementById('height').value}&weight=${document.getElementById('weight').value}&goalMinutes=${document.getElementById('goalMinutes').value}`;
            const res = await fetch(`${window.CONTEXT_PATH}/api/profiler`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body
            });
            const data = await res.json();
            document.getElementById('plan-result').innerHTML = `
                <div class="card">
                    <h3>Your Personalized ${data.totalMinutes}-Minute Plan</h3>
                    <p>🌬️ Breathing: ${data.breathingMinutes} min</p>
                    <p>🧘 Body Scan: ${data.bodyScanMinutes} min</p>
                    <p>🌙 Deep Stillness: ${data.stillnessMinutes} min</p>
                    <p>✨ Closing: ${data.closingMinutes} min</p>
                </div>`;
        }
    </script>
</body>
</html>
