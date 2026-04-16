package com.library.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/UpdateMemberServlet")
public class UpdateMemberServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession().getAttribute("adminId") == null) {
            response.sendRedirect("login.jsp?role=admin&error=Unauthorized access");
            return;
        }

        String id = request.getParameter("id");
        String email = request.getParameter("email");
        String contactNo = request.getParameter("contactNo");

        if (id == null || email == null || email.trim().isEmpty()) {
            response.sendRedirect("adminUsers.jsp?msg=Email is required");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE members SET email=?, contact_no=? WHERE id=?"
            );
            ps.setString(1, email.trim());
            ps.setString(2, contactNo != null && !contactNo.trim().isEmpty() ? contactNo.trim() : null);
            ps.setInt(3, Integer.parseInt(id));
            ps.executeUpdate();
            ps.close();
            response.sendRedirect("adminUsers.jsp?msg=Member updated successfully");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminUsers.jsp?msg=Update failed: " + e.getMessage());
        }
    }
}
