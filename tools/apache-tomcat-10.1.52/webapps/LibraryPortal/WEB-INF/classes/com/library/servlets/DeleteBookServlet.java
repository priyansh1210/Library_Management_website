package com.library.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/DeleteBookServlet")
public class DeleteBookServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession().getAttribute("adminId") == null) {
            response.sendRedirect("login.jsp?error=Unauthorized access");
            return;
        }

        String id = request.getParameter("id");
        if (id == null) {
            response.sendRedirect("adminBooks.jsp?msg=Book ID is required");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            int bookId = Integer.parseInt(id);

            PreparedStatement active = conn.prepareStatement(
                "SELECT COUNT(*) FROM borrow_history WHERE book_id=? AND status='BORROWED'");
            active.setInt(1, bookId);
            ResultSet ar = active.executeQuery();
            ar.next();
            int activeCount = ar.getInt(1);
            active.close();

            if (activeCount > 0) {
                response.sendRedirect("adminBooks.jsp?msg=Cannot delete: " + activeCount + " copy(ies) currently borrowed. Wait for return before removing.");
                return;
            }

            PreparedStatement hist = conn.prepareStatement(
                "SELECT COUNT(*) FROM borrow_history WHERE book_id=?");
            hist.setInt(1, bookId);
            ResultSet hr = hist.executeQuery();
            hr.next();
            int histCount = hr.getInt(1);
            hist.close();

            if (histCount > 0) {
                response.sendRedirect("adminBooks.jsp?msg=Cannot delete: book has borrow history. Preserving records for audit.");
                return;
            }

            PreparedStatement ps = conn.prepareStatement("DELETE FROM books WHERE id=?");
            ps.setInt(1, bookId);
            ps.executeUpdate();
            ps.close();
            response.sendRedirect("adminBooks.jsp?msg=Book deleted successfully");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminBooks.jsp?msg=Delete failed: " + e.getMessage());
        }
    }
}
