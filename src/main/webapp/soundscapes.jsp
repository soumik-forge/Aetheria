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
    <title>Soundscapes — Aetheria</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="navbar">
        <span class="logo">🌿 Aetheria</span>
        <nav>
            <a href="dashboard.jsp">Home</a>
            <a href="practices.jsp">Practices</a>
            <a href="daily-dose.jsp">Daily Dose</a>
            <a href="my-routine.jsp">My Routine</a>
            <button class="toggle-switch jelly" onclick="toggleTheme()"><span class="knob"></span></button>
        </nav>
    </div>

    <div class="section">
        <h2>Native Soundscapes & Frequencies</h2>
        <p style="color:var(--slate); margin-bottom:1.5rem;">Ad-free, self-hosted audio. Stream directly or download for offline listening.</p>

        <div class="sound-grid">
            <div class="card sound-card">
                <h3>432Hz Healing Tone</h3>
                <audio controls src="assets/audio/432hz.mp3"></audio>
                <a class="download-link" href="assets/audio/432hz.mp3" download>⬇ Download MP3</a>
            </div>
            <div class="card sound-card">
                <h3>528Hz Transformation</h3>
                <audio controls src="assets/audio/528hz.mp3"></audio>
                <a class="download-link" href="assets/audio/528hz.mp3" download>⬇ Download MP3</a>
            </div>
            <div class="card sound-card">
                <h3>Theta Waves</h3>
                <audio controls src="assets/audio/theta-waves.mp3"></audio>
                <a class="download-link" href="assets/audio/theta-waves.mp3" download>⬇ Download MP3</a>
            </div>
            <div class="card sound-card">
                <h3>Forest Rain</h3>
                <audio controls src="assets/audio/forest-rain.mp3"></audio>
                <a class="download-link" href="assets/audio/forest-rain.mp3" download>⬇ Download MP3</a>
            </div>
            <div class="card sound-card">
                <h3>Deep Ocean</h3>
                <audio controls src="assets/audio/deep-ocean.mp3"></audio>
                <a class="download-link" href="assets/audio/deep-ocean.mp3" download>⬇ Download MP3</a>
            </div>
        </div>
        <p style="color:var(--slate); font-size:0.8rem; margin-top:1rem;">Note: add your own royalty-free .mp3 files to <code>assets/audio/</code> — see README.</p>
    </div>

    <script>window.CONTEXT_PATH = "<%= request.getContextPath() %>";</script>
    <script src="js/app.js"></script>
</body>
</html>
