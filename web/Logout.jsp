<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Session clear karein (user logout ho jayega)
    session.invalidate();
    
    // Login page par redirect karein success message ke saath
    response.sendRedirect("Login.jsp?msg=Logged out successfully!");
%>