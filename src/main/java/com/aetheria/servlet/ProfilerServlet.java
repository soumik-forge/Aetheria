package com.aetheria.servlet;

import com.aetheria.dao.UserDAO;
import com.aetheria.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Personalized Meditation Profiler ("Body & Time Guide").
 * Takes age/height/weight/goal time and returns a tailored
 * step-by-step breakdown (rule-based, no external API).
 */
@WebServlet("/api/profiler")
public class ProfilerServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        Integer age = parseIntOrNull(request.getParameter("age"));
        Double height = parseDoubleOrNull(request.getParameter("height"));
        Double weight = parseDoubleOrNull(request.getParameter("weight"));
        Integer goalMinutesObj = parseIntOrNull(request.getParameter("goalMinutes"));
        int goalMinutes = (goalMinutesObj != null && goalMinutesObj > 0) ? goalMinutesObj : 15;

        if (user != null && (age != null || height != null || weight != null)) {
            userDAO.updateProfile(user.getId(), age, height, weight);
        }

        // Rule-based breakdown generation
        int breathing = Math.max(2, (int) (goalMinutes * 0.2));
        int bodyScan = Math.max(2, (int) (goalMinutes * 0.3));
        int stillness = Math.max(2, (int) (goalMinutes * 0.35));
        int closing = Math.max(1, goalMinutes - breathing - bodyScan - stillness);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{"
                + "\"breathingMinutes\":" + breathing + ","
                + "\"bodyScanMinutes\":" + bodyScan + ","
                + "\"stillnessMinutes\":" + stillness + ","
                + "\"closingMinutes\":" + closing + ","
                + "\"totalMinutes\":" + goalMinutes
                + "}");
        out.flush();
    }

    private Integer parseIntOrNull(String s) {
        try { return (s == null || s.trim().isEmpty()) ? null : Integer.parseInt(s.trim()); } catch (Exception e) { return null; }
    }

    private Double parseDoubleOrNull(String s) {
        try { return (s == null || s.trim().isEmpty()) ? null : Double.parseDouble(s.trim()); } catch (Exception e) { return null; }
    }
}
