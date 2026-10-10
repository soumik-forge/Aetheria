package com.aetheria.servlet;

import com.aetheria.dao.JournalDAO;
import com.aetheria.dao.SessionDAO;
import com.aetheria.model.CompletedSession;
import com.aetheria.model.Journal;
import com.aetheria.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Builds the Weekly Reflection Report Card: pulls the last 7 days of
 * completed sessions + journal entries, computes simple stats, and
 * forwards to report.jsp with rule-based advice text (no AI/API).
 */
@WebServlet("/report")
public class ReportServlet extends HttpServlet {

    private final SessionDAO sessionDAO = new SessionDAO();
    private final JournalDAO journalDAO = new JournalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        List<CompletedSession> sessions = sessionDAO.getLast7Days(user.getId());
        List<Journal> journals = journalDAO.getLast7Days(user.getId());

        int totalMinutes = sessions.stream().mapToInt(CompletedSession::getDurationMinutes).sum();
        int sessionCount = sessions.size();
        int streak = sessionDAO.getCurrentStreak(user.getId());

        String advantage, disadvantage, nextMove, blueprint;

        if (sessionCount >= 5) {
            advantage = "Excellent consistency this week — your mind is building real resilience.";
            disadvantage = "Watch for fatigue; even dedicated practitioners need rest days.";
            nextMove = "Try extending one session to 20+ minutes for deeper stillness.";
            blueprint = "3x Focus sessions, 2x Recovery sessions, 2x rest days.";
        } else if (sessionCount >= 2) {
            advantage = "You're building a habit — every session compounds over time.";
            disadvantage = "Inconsistency can slow progress; try anchoring sessions to a fixed time of day.";
            nextMove = "Aim for one more session than last week.";
            blueprint = "Alternate between Focus and General sessions, same time daily.";
        } else {
            advantage = "You took the first step by showing up at all — that matters.";
            disadvantage = "Low frequency makes it harder to build lasting calm.";
            nextMove = "Start small: just 5 minutes a day, same time, for the next 7 days.";
            blueprint = "Daily 5-minute Morning Stillness sessions to build the habit loop.";
        }

        request.setAttribute("sessionCount", sessionCount);
        request.setAttribute("totalMinutes", totalMinutes);
        request.setAttribute("streak", streak);
        request.setAttribute("journalCount", journals.size());
        request.setAttribute("advantage", advantage);
        request.setAttribute("disadvantage", disadvantage);
        request.setAttribute("nextMove", nextMove);
        request.setAttribute("blueprint", blueprint);

        request.getRequestDispatcher("/report.jsp").forward(request, response);
    }
}
