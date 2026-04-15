package com.library.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/DeleteAdminServlet")
public class DeleteAdminServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Object sessionAdminId = request.getSession().getAttribute("adminId");
        if (sessionAdminId == null) {
            response.sendRedirect("login.jsp?role=admin&error=Unauthorized access");
            return;
        }

        String id = request.getParameter("id");
        if (id == null) {
            response.sendRedirect("adminAdmins.jsp?msg=Admin ID is required");
            return;
        }

        try {
            int targetId = Integer.parseInt(id);
            int currentId = Integer.parseInt(sessionAdminId.toString());
            if (targetId == currentId) {
                response.sendRedirect("adminAdmins.jsp?msg=You cannot delete your own account");
                return;
            }

            try (Connection conn = DBConnection.getConnection()) {
                PreparedStatement count = conn.prepareStatement("SELECT COUNT(*) FROM admin");
                ResultSet rs = count.executeQuery();
                rs.next();
                if (rs.getInt(1) <= 1) {
                    response.sendRedirect("adminAdmins.jsp?msg=Cannot delete the last admin");
                    return;
                }

                PreparedStatement ps = conn.prepareStatement("DELETE FROM admin WHERE id=?");
                ps.setInt(1, targetId);
                ps.executeUpdate();
                ps.close();
                response.sendRedirect("adminAdmins.jsp?msg=Admin deleted successfully");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminAdmins.jsp?msg=Delete failed: " + e.getMessage());
        }
    }
}
