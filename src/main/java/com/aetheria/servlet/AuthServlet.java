package com.aetheria.servlet;

import com.aetheria.dao.UserDAO;
import com.aetheria.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet({"/auth/login", "/auth/register", "/auth/logout"})
public class AuthServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if (path.equals("/auth/login")) {
            String userIdStr = request.getParameter("userIdStr"); // e.g. Soumik@2007
            String password = request.getParameter("password");

            User user = userDAO.login(userIdStr, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid User ID or Password. Format: name@birthyear");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            }

        } else if (path.equals("/auth/register")) {
            String username = request.getParameter("username");
            int birthYear = Integer.parseInt(request.getParameter("birthYear"));
            Integer age = parseIntOrNull(request.getParameter("age"));
            Double height = parseDoubleOrNull(request.getParameter("height"));
            Double weight = parseDoubleOrNull(request.getParameter("weight"));

            boolean ok = userDAO.register(username, birthYear, age, height, weight);
            if (ok) {
                request.setAttribute("message", "Account created! Your User ID is " + username + "@" + birthYear);
            } else {
                request.setAttribute("error", "Registration failed. That User ID may already exist.");
            }
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getServletPath().equals("/auth/logout")) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private Integer parseIntOrNull(String s) {
        try { return (s == null || s.isEmpty()) ? null : Integer.parseInt(s); } catch (Exception e) { return null; }
    }

    private Double parseDoubleOrNull(String s) {
        try { return (s == null || s.isEmpty()) ? null : Double.parseDouble(s); } catch (Exception e) { return null; }
    }
}
