package com.library.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/DeleteBranchServlet")
public class DeleteBranchServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handle(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("adminBranches.jsp?msg=Branch deletion requires a reason and two-step confirmation. Use the form.");
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
        String confirmName = request.getParameter("confirmName");

        if (id == null) {
            response.sendRedirect("adminBranches.jsp?msg=Branch ID is required");
            return;
        }
        if (reason == null || reason.trim().length() < 5) {
            response.sendRedirect("adminBranches.jsp?msg=A reason (min 5 chars) is required to delete a branch");
            return;
        }
        if (confirmName == null || confirmName.trim().isEmpty()) {
            response.sendRedirect("adminBranches.jsp?msg=Confirmation name is required");
            return;
        }

        int branchId = Integer.parseInt(id);
        int adminId = Integer.parseInt(session.getAttribute("adminId").toString());
        Object adminNameObj = session.getAttribute("adminName");
        String adminName = adminNameObj != null ? adminNameObj.toString() : "Admin #" + adminId;

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement fetch = conn.prepareStatement(
                "SELECT name, contact_no, location FROM branches WHERE id=?");
            fetch.setInt(1, branchId);
            ResultSet fr = fetch.executeQuery();
            if (!fr.next()) {
                response.sendRedirect("adminBranches.jsp?msg=Branch not found");
                return;
            }
            String bName = fr.getString("name");
            String bContact = fr.getString("contact_no");
            String bLocation = fr.getString("location");
            fetch.close();

            if (!confirmName.trim().equals(bName)) {
                response.sendRedirect("adminBranches.jsp?msg=Confirmation name did not match. Deletion cancelled.");
                return;
            }

            PreparedStatement audit = conn.prepareStatement(
                "INSERT INTO deleted_branches (branch_id, name, contact_no, location, reason, deleted_by_admin_id, deleted_by_admin_name) VALUES (?,?,?,?,?,?,?)");
            audit.setInt(1, branchId);
            audit.setString(2, bName);
            audit.setString(3, bContact);
            audit.setString(4, bLocation);
            audit.setString(5, reason.trim());
            audit.setInt(6, adminId);
            audit.setString(7, adminName);
            audit.executeUpdate();
            audit.close();

            PreparedStatement ps = conn.prepareStatement("DELETE FROM branches WHERE id=?");
            ps.setInt(1, branchId);
            ps.executeUpdate();
            ps.close();

            response.sendRedirect("adminBranches.jsp?msg=Branch deleted and reason logged");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminBranches.jsp?msg=Delete failed: " + e.getMessage());
        }
    }
}
