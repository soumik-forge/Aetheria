package com.aetheria.servlet;

import com.aetheria.dao.MoodDAO;
import com.aetheria.dao.SessionDAO;
import com.aetheria.model.Session;
import com.aetheria.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Powers the Mood-Based Dynamic Selector (Fetch API, JSON response)
 * and logs the mood for the Burnout Detector widget.
 */
@WebServlet("/api/sessions")
public class SessionServlet extends HttpServlet {

    private final SessionDAO sessionDAO = new SessionDAO();
    private final MoodDAO moodDAO = new MoodDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String mood = request.getParameter("mood"); // OVERWHELMED, CANT_SLEEP, LOW_ENERGY, UNFOCUSED
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Log the mood (only for the 4 trackable moods, not RECOVERY/GENERAL)
        boolean burnoutFlag = false;
        if (user != null && isTrackableMood(mood)) {
            moodDAO.logMood(user.getId(), mood);
            int recentCount = moodDAO.countRecentMood(user.getId(), mood);
            burnoutFlag = recentCount >= 3;
        }

        List<Session> sessions = (burnoutFlag || "RECOVERY".equalsIgnoreCase(mood) || "RECOVERY_DIRECT".equalsIgnoreCase(mood))
                ? sessionDAO.getByMood("RECOVERY")
                : sessionDAO.getByMood(mood);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        StringBuilder json = new StringBuilder();
        json.append("{\"burnoutDetected\":").append(burnoutFlag).append(",\"sessions\":[");
        for (int i = 0; i < sessions.size(); i++) {
            Session s = sessions.get(i);
            if (i > 0) json.append(",");
            json.append("{")
                .append("\"id\":").append(s.getId()).append(",")
                .append("\"title\":\"").append(escape(s.getTitle())).append("\",")
                .append("\"duration\":").append(s.getDurationMinutes()).append(",")
                .append("\"audioUrl\":\"").append(escape(s.getAudioUrl())).append("\",")
                .append("\"imageUrl\":\"").append(escape(s.getImageUrl())).append("\",")
                .append("\"description\":\"").append(escape(s.getDescription())).append("\"")
                .append("}");
        }
        json.append("]}");
        out.print(json);
        out.flush();
    }

    private boolean isTrackableMood(String mood) {
        return mood != null && (mood.equals("OVERWHELMED") || mood.equals("CANT_SLEEP")
                || mood.equals("LOW_ENERGY") || mood.equals("UNFOCUSED"));
    }

    private String escape(String s) {
        return s == null ? "" : s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
