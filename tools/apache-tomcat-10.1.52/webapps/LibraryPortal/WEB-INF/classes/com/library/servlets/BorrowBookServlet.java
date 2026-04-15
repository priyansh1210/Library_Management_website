package com.library.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/BorrowBookServlet")
public class BorrowBookServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("memberId") == null) {
            response.sendRedirect("login.jsp?role=member&error=Please login first");
            return;
        }

        int memberId = (int) session.getAttribute("memberId");
        String bookIdStr = request.getParameter("bookId");
        String daysStr = request.getParameter("days");

        if (bookIdStr == null) {
            response.sendRedirect("memberBooks.jsp?msg=Book ID is required");
            return;
        }

        int bookId = Integer.parseInt(bookIdStr);
        int days = 14;
        try {
            if (daysStr != null && !daysStr.trim().isEmpty()) {
                days = Integer.parseInt(daysStr.trim());
            }
        } catch (NumberFormatException e) { days = 14; }
        if (days < 1) days = 1;
        if (days > 30) days = 30;

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement checkPs = conn.prepareStatement("SELECT available FROM books WHERE id=?");
            checkPs.setInt(1, bookId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next() && rs.getInt("available") > 0) {
                PreparedStatement borrowPs = conn.prepareStatement(
                    "INSERT INTO borrow_history (member_id, book_id, borrow_date, due_date, status) " +
                    "VALUES (?,?,NOW(), DATE_ADD(NOW(), INTERVAL ? DAY), 'BORROWED')"
                );
                borrowPs.setInt(1, memberId);
                borrowPs.setInt(2, bookId);
                borrowPs.setInt(3, days);
                borrowPs.executeUpdate();
                borrowPs.close();

                PreparedStatement updatePs = conn.prepareStatement(
                    "UPDATE books SET available = available - 1 WHERE id=?"
                );
                updatePs.setInt(1, bookId);
                updatePs.executeUpdate();
                updatePs.close();

                response.sendRedirect("memberBooks.jsp?msg=Book borrowed for " + days + " day(s). Return by due date to avoid overdue.");
            } else {
                response.sendRedirect("memberBooks.jsp?msg=Book not available");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("memberBooks.jsp?msg=Borrow failed: " + e.getMessage());
        }
    }
}
