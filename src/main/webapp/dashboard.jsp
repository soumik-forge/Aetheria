<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.aetheria.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard — Aetheria</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="ambient-bar">
        <span id="ambient-clock">Loading...</span>
        <span>100% Free — No Paywalls, Ever</span>
    </div>

    <div class="navbar">
        <span class="logo">🌿 Aetheria</span>
        <nav>
            <a href="practices.jsp">Practices</a>
            <a href="soundscapes.jsp">Soundscapes</a>
            <a href="daily-dose.jsp">Daily Dose</a>
            <a href="my-routine.jsp">My Routine</a>
            <a href="report">My Week</a>
            <a href="auth/logout">Logout</a>
            <button class="toggle-switch jelly" onclick="toggleTheme()" title="Toggle Dark/Light Mode" style="margin-left:1rem;">
                <span class="knob"></span>
            </button>
        </nav>
    </div>

    <!-- Live Presence Counter -->
    <div class="live-presence" id="live-presence">
        <span class="live-dot"></span>
        <span><span id="live-count">0</span> people meditating right now</span>
    </div>

    <!-- Hero Banner -->
    <div class="hero section">
        <div class="hero-text">
            <h1>Welcome, <%= user.getUsername() %> 🌸</h1>
            <p>Access guided meditations, track your mindfulness journey, and find your stillness — completely free, always.</p>
            <p class="hero-quote">"Stillness is where clarity begins."</p>
        </div>
    </div>

    <!-- Breathing Visualizer -->
    <div class="section">
        <div class="breathing-wrap">
            <div class="breathing-ring"></div>
        </div>
        <p class="breathing-label">Follow the glow — inhale as it grows, exhale as it fades. (60-second cycle)</p>
    </div>

    <!-- Voice + Keyboard Command Bar -->
    <div class="section">
        <div class="command-bar">
            <input type="text" id="command-input" placeholder='Try: "I feel overwhelmed" or "help me sleep"...'
                   onkeypress="if(event.key==='Enter') handleCommand(this.value)">
            <button class="mic-btn jelly" id="mic-btn" title="Voice command">🎙️</button>
        </div>
    </div>

    <!-- Mood Selector -->
    <div class="section">
        <h2 style="text-align:center; margin-bottom:1rem;">How are you feeling right now?</h2>
        <div class="mood-grid">
            <button class="mood-btn jelly" onclick="fetchMoodSessions('OVERWHELMED')">😣 Overwhelmed</button>
            <button class="mood-btn jelly" onclick="fetchMoodSessions('CANT_SLEEP')">😴 Can't Sleep</button>
            <button class="mood-btn jelly" onclick="fetchMoodSessions('LOW_ENERGY')">🪫 Low Energy</button>
            <button class="mood-btn jelly" onclick="fetchMoodSessions('UNFOCUSED')">🌀 Unfocused</button>
        </div>
        <div id="session-results" style="display:grid; grid-template-columns:repeat(auto-fit,minmax(240px,1fr)); gap:1rem; margin-top:1.5rem;"></div>
        <div style="text-align:center; margin-top:1rem;">
            <button class="btn jelly" onclick="completeSession()">✓ Mark Session Complete</button>
            <button class="btn btn-terracotta jelly" onclick="openJournalPopup()">📝 Reflect</button>
        </div>
    </div>

    <!-- Streak Garden Tracker -->
    <div class="section">
        <div class="card garden-wrap">
            <h2>Your Mindfulness Garden</h2>
            <div class="garden-stage" id="garden-stage">🌰</div>
            <p>Current streak: <span class="streak-count" id="streak-count">0</span> days</p>
            <p style="color:var(--slate); font-size:0.85rem; margin-top:0.5rem;">Keep meditating daily to grow your garden from a seed into a tree 🌳</p>
        </div>
    </div>

    <!-- Journal Popup -->
    <div id="journal-popup" class="burnout-widget" style="right:auto; left:24px;">
        <p style="font-weight:600;">What are you letting go of today?</p>
        <textarea id="journal-input" rows="3" style="width:100%; border-radius:10px; border:1px solid var(--border-soft); padding:0.6rem; margin-bottom:0.8rem;"></textarea>
        <div class="burnout-actions">
            <button class="btn jelly" onclick="submitJournal()">Save</button>
            <button class="btn btn-slate jelly" onclick="closeJournalPopup()">Cancel</button>
        </div>
    </div>

    <!-- Burnout Floating Conversational Widget -->
    <div id="burnout-widget" class="burnout-widget">
        <p id="burnout-message" style="font-weight:600;"></p>
        <div class="burnout-actions">
            <button class="btn jelly" onclick="acceptBurnoutSuggestion()">Yes, let's slow down</button>
            <button class="btn btn-slate jelly" onclick="dismissBurnout()">Maybe later</button>
        </div>
    </div>

    <footer>Aetheria — Created by Soumik Chatterjee (Boost With Soumik), Galgotias University, B.Tech CSE AI & ML</footer>

    <script>window.CONTEXT_PATH = "<%= request.getContextPath() %>";</script>
    <script src="js/app.js"></script>
</body>
</html>
