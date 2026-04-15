package com.library.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.Base64;

@WebServlet("/MemberRegisterServlet")
public class MemberRegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String contactNo = request.getParameter("contactNo");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String photo = request.getParameter("photo");

        String name = (firstName != null ? firstName.trim() : "") + " " + (lastName != null ? lastName.trim() : "");
        name = name.trim();

        if (name.isEmpty() || email == null || email.trim().isEmpty()
                || username == null || username.trim().isEmpty()
                || password == null || password.length() < 4) {
            response.sendRedirect("register.jsp?role=member&error=All fields required, password min 4 chars");
            return;
        }

        if (photo == null || !photo.startsWith("data:image/")) {
            response.sendRedirect("register.jsp?role=member&error=Face photo is required for virtual ID");
            return;
        }

        String mimeType;
        byte[] photoBytes;
        try {
            int comma = photo.indexOf(",");
            String meta = photo.substring(5, photo.indexOf(";"));
            mimeType = meta;
            String b64 = photo.substring(comma + 1);
            photoBytes = Base64.getDecoder().decode(b64);
            if (photoBytes.length < 500) {
                response.sendRedirect("register.jsp?role=member&error=Captured photo is too small or invalid");
                return;
            }
        } catch (Exception ex) {
            response.sendRedirect("register.jsp?role=member&error=Invalid photo data");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement check = conn.prepareStatement(
                "SELECT id FROM members WHERE email=? OR username=?");
            check.setString(1, email.trim());
            check.setString(2, username.trim());
            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                response.sendRedirect("register.jsp?role=member&error=Email or username already registered");
                return;
            }

            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO members (name, username, email, password, profile_image, image_type) VALUES (?,?,?,?,?,?)"
            );
            ps.setString(1, name);
            ps.setString(2, username.trim());
            ps.setString(3, email.trim());
            ps.setString(4, password);
            ps.setBytes(5, photoBytes);
            ps.setString(6, mimeType);
            ps.executeUpdate();
            ps.close();
            response.sendRedirect("login.jsp?role=member&success=Registration successful! Your virtual ID is ready. Please login.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?role=member&error=Registration failed: " + e.getMessage());
        }
    }
}
