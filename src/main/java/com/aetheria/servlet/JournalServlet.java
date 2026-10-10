package com.aetheria.servlet;

import com.aetheria.dao.JournalDAO;
import com.aetheria.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/journal")
public class JournalServlet extends HttpServlet {

    private final JournalDAO journalDAO = new JournalDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String entryText = request.getParameter("entryText");

        boolean ok = false;
        if (user != null && entryText != null && !entryText.trim().isEmpty()) {
            ok = journalDAO.addEntry(user.getId(), entryText.trim());
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\":" + ok + "}");
        out.flush();
    }
}
