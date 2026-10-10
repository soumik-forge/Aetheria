package com.aetheria.servlet;

import com.aetheria.dao.FeedbackDAO;
import com.aetheria.model.Feedback;
import com.aetheria.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {

    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        Feedback fb = new Feedback();
        fb.setUserId(user != null ? user.getId() : 1);
        fb.setRatingStars(parseIntOrDefault(request.getParameter("ratingStars"), 5));
        fb.setEaseOfUse(parseIntOrDefault(request.getParameter("easeOfUse"), 5));
        fb.setCalmnessLevel(parseIntOrDefault(request.getParameter("calmnessLevel"), 5));
        fb.setUiQuality(parseIntOrDefault(request.getParameter("uiQuality"), 5));
        fb.setReviewText(request.getParameter("reviewText"));

        feedbackDAO.submit(fb);

        request.setAttribute("message", "Thank you for your feedback!");
        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }

    private int parseIntOrDefault(String s, int def) {
        try { return (s == null || s.trim().isEmpty()) ? def : Integer.parseInt(s.trim()); } catch (Exception e) { return def; }
    }
}
