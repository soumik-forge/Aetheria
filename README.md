# 🌿 Aetheria — Online Meditation and Mindfulness Platform

A 100% free, enterprise-grade meditation platform built with Java Servlets + JSP + JDBC + MySQL, featuring an ASMR-inspired "Jelly UI" design system and several rule-based smart features — all with zero paid APIs.

---

## ✨ Features

- **Custom Auth System** — User ID format `name@birthyear` (e.g. `Soumik@2007`), password = birth year
- **Personalized Hero Banner** with dynamic greeting
- **Body & Time Guide Profiler** — generates a custom session breakdown from age/height/weight/goal time
- **Mood-Based Dynamic Selector** — async session fetch via Fetch API
- **60-Second Breathing Visualizer** — glowing expanding/contracting ring
- **Native Soundscape Player** — self-hosted audio, no ads, downloadable MP3s
- **Micro-Journaling** — one-line reflection popup saved to DB
- **5-Star Feedback System**
- **🌱 Streak Garden Tracker** — visual seed → sprout → tree progression tied to real completed sessions
- **🤖 Burnout Detector** — floating conversational widget; if a mood is logged 3+ times in 7 days, it proactively suggests a longer Recovery session (pure rule-based SQL logic, no AI/API)
- **🌗 Light/Dark Mode Toggle** — one switch, persisted via localStorage
- **🖼️ Downloadable Completion Card** — HTML5 Canvas-generated PNG, no external image service
- **🔴 Live Presence Counter** — simulated "X people meditating now" with a pulsing dot, shown only during an active session
- **🎙️ Voice + Keyboard Command Bar** — Web Speech API (free, browser-native) alongside normal text input
- **📊 Weekly Reflection Report Card** — auto-generated after activity: stats, advantages, disadvantages, next move, and next week's blueprint

---

## 📂 Project Structure

```
Aetheria/
├── database/schema.sql
├── src/main/java/com/aetheria/
│   ├── util/DBConnection.java
│   ├── model/ (User, Session, Journal, MoodLog, CompletedSession, Feedback)
│   ├── dao/ (UserDAO, SessionDAO, MoodDAO, JournalDAO, FeedbackDAO)
│   └── servlet/ (AuthServlet, SessionServlet, ProfilerServlet, JournalServlet,
│                 FeedbackServlet, CompletionServlet, ReportServlet)
└── src/main/webapp/
    ├── index.jsp, dashboard.jsp, practices.jsp, soundscapes.jsp,
    │   daily-dose.jsp, my-routine.jsp, report.jsp, about.jsp, contact.jsp
    ├── css/style.css
    ├── js/app.js
    ├── assets/audio/ (add your own royalty-free .mp3 files here)
    └── WEB-INF/web.xml
```

---

## ⚙️ Requirements

- Java JDK 11+
- Apache Tomcat 9+
- MySQL 8.0+
- MySQL Connector/J (place in `WEB-INF/lib/`)

## 🚀 Setup

1. Run `database/schema.sql` in MySQL to create `aetheria_db`
2. Update `DBConnection.java` with your MySQL password
3. Add MySQL Connector/J jar to `WEB-INF/lib/`
4. (Optional) Drop royalty-free `.mp3` files into `assets/audio/` matching the filenames referenced in `soundscapes.jsp` and `schema.sql`
5. Build + deploy as a WAR to Tomcat
6. Visit `http://localhost:8080/Aetheria/`

## 🔑 Default Login
- **User ID:** `Soumik@2007`
- **Password:** `2007`

## 🎵 Note on Audio Files
The audio files under `src/main/webapp/assets/audio/` are not included in this repository (kept out to keep the repo lightweight). To run the Soundscapes and mood-session features locally, add your own royalty-free `.mp3` files to that folder, matching these filenames:
`432hz.mp3`, `528hz.mp3`, `theta-waves.mp3`, `forest-rain.mp3`, `deep-ocean.mp3`, `calm-storm.mp3`, `deep-recovery.mp3`, `drift-sleep.mp3`, `energy-rise.mp3`, `laser-focus.mp3`, `morning-stillness.mp3`

## 📝 Note on Security
Passwords are stored as plain birth years for this project's intentionally simple demo auth scheme. For production use, replace with proper hashing (e.g. BCrypt).
