package com.library.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/UpdateAdminServlet")
public class UpdateAdminServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession().getAttribute("adminId") == null) {
            response.sendRedirect("login.jsp?role=admin&error=Unauthorized access");
            return;
        }

        String id = request.getParameter("id");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String contactNo = request.getParameter("contactNo");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String name = (firstName != null ? firstName.trim() : "") + " " + (lastName != null ? lastName.trim() : "");
        name = name.trim();

        if (id == null || name.isEmpty() || email == null || email.trim().isEmpty()) {
            response.sendRedirect("adminAdmins.jsp?msg=All fields are required");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            if (password != null && !password.trim().isEmpty()) {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE admin SET name=?, first_name=?, last_name=?, contact_no=?, email=?, username=?, password=? WHERE id=?"
                );
                ps.setString(1, name);
                ps.setString(2, firstName != null ? firstName.trim() : "");
                ps.setString(3, lastName != null ? lastName.trim() : "");
                ps.setString(4, contactNo != null ? contactNo.trim() : "");
                ps.setString(5, email.trim());
                ps.setString(6, username != null ? username.trim() : email.trim());
                ps.setString(7, password);
                ps.setInt(8, Integer.parseInt(id));
                ps.executeUpdate();
                ps.close();
            } else {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE admin SET name=?, first_name=?, last_name=?, contact_no=?, email=?, username=? WHERE id=?"
                );
                ps.setString(1, name);
                ps.setString(2, firstName != null ? firstName.trim() : "");
                ps.setString(3, lastName != null ? lastName.trim() : "");
                ps.setString(4, contactNo != null ? contactNo.trim() : "");
                ps.setString(5, email.trim());
                ps.setString(6, username != null ? username.trim() : email.trim());
                ps.setInt(7, Integer.parseInt(id));
                ps.executeUpdate();
                ps.close();
            }
            response.sendRedirect("adminAdmins.jsp?msg=Admin updated successfully");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminAdmins.jsp?msg=Update failed: " + e.getMessage());
        }
    }
}
