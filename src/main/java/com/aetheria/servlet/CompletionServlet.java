package com.aetheria.servlet;

import com.aetheria.dao.SessionDAO;
import com.aetheria.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Logs a completed session (powers the growing-garden streak tracker)
 * and returns the updated streak count as JSON for the frontend to
 * render + use when generating the downloadable completion card.
 */
@WebServlet("/api/complete-session")
public class CompletionServlet extends HttpServlet {

    private final SessionDAO sessionDAO = new SessionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        Integer sessionId = parseIntOrNull(request.getParameter("sessionId"));
        Integer durationObj = parseIntOrNull(request.getParameter("duration"));
        int duration = (durationObj != null && durationObj > 0) ? durationObj : 10;

        int streak = 0;
        if (user != null) {
            sessionDAO.logCompletion(user.getId(), sessionId, duration);
            streak = sessionDAO.getCurrentStreak(user.getId());
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"streak\":" + streak + ",\"duration\":" + duration + "}");
        out.flush();
    }

    private Integer parseIntOrNull(String s) {
        try { return (s == null || s.isEmpty()) ? null : Integer.parseInt(s); } catch (Exception e) { return null; }
    }
}
