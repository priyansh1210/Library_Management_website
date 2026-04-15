package com.library.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/DeleteMemberServlet")
public class DeleteMemberServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handle(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("adminUsers.jsp?msg=Deletion requires a reason. Use the form.");
    }

    private void handle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("adminId") == null) {
            response.sendRedirect("login.jsp?role=admin&error=Unauthorized access");
            return;
        }

        String id = request.getParameter("id");
        String reason = request.getParameter("reason");

        if (id == null) {
            response.sendRedirect("adminUsers.jsp?msg=Member ID is required");
            return;
        }
        if (reason == null || reason.trim().length() < 5) {
            response.sendRedirect("adminUsers.jsp?msg=A reason (min 5 chars) is required to delete a member");
            return;
        }

        int memberId = Integer.parseInt(id);
        int adminId = Integer.parseInt(session.getAttribute("adminId").toString());
        Object adminNameObj = session.getAttribute("adminName");
        String adminName = adminNameObj != null ? adminNameObj.toString() : "Admin #" + adminId;

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement active = conn.prepareStatement(
                "SELECT COUNT(*) FROM borrow_history WHERE member_id=? AND status='BORROWED'");
            active.setInt(1, memberId);
            ResultSet ar = active.executeQuery();
            ar.next();
            int activeCount = ar.getInt(1);
            active.close();

            if (activeCount > 0) {
                response.sendRedirect("adminUsers.jsp?msg=Cannot delete: member has " + activeCount + " book(s) not yet returned.");
                return;
            }

            PreparedStatement fetch = conn.prepareStatement(
                "SELECT name, email, username FROM members WHERE id=?");
            fetch.setInt(1, memberId);
            ResultSet fr = fetch.executeQuery();
            if (!fr.next()) {
                response.sendRedirect("adminUsers.jsp?msg=Member not found");
                return;
            }
            String mName = fr.getString("name");
            String mEmail = fr.getString("email");
            String mUsername = fr.getString("username");
            fetch.close();

            PreparedStatement audit = conn.prepareStatement(
                "INSERT INTO deleted_members (member_id, name, email, username, reason, deleted_by_admin_id, deleted_by_admin_name) VALUES (?,?,?,?,?,?,?)");
            audit.setInt(1, memberId);
            audit.setString(2, mName);
            audit.setString(3, mEmail);
            audit.setString(4, mUsername);
            audit.setString(5, reason.trim());
            audit.setInt(6, adminId);
            audit.setString(7, adminName);
            audit.executeUpdate();
            audit.close();

            PreparedStatement ps = conn.prepareStatement("DELETE FROM members WHERE id=?");
            ps.setInt(1, memberId);
            ps.executeUpdate();
            ps.close();

            response.sendRedirect("adminUsers.jsp?msg=Member deleted and reason logged");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminUsers.jsp?msg=Delete failed: " + e.getMessage());
        }
    }
}
