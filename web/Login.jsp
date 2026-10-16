<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="DB.DBDatabaseConnection"%>

<%
    // ===== BACKEND CODE =====
    String message = "";
    String messageType = "";
    
    // URL se success/error message check karein (Register.jsp se aane wala)
    String urlMsg = request.getParameter("msg");
    String urlError = request.getParameter("error");
    
    if(urlMsg != null) {
        message = urlMsg;
        messageType = "success";
    } else if(urlError != null) {
        message = urlError;
        messageType = "error";
    }
    
    if(request.getMethod().equalsIgnoreCase("POST")) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        try {
            DBDatabaseConnection db = new DBDatabaseConnection();
            
            // User ko email aur password se check karein
            db.pstmt = db.con.prepareStatement("SELECT id, name FROM users WHERE email=? AND password=?");
            db.pstmt.setString(1, email);
            db.pstmt.setString(2, password);
            db.rst = db.pstmt.executeQuery();
            
            if(db.rst.next()) {
                // Login successful — Session banayein
                int userId = db.rst.getInt("id");
                String userName = db.rst.getString("name");
                
                session.setAttribute("userId", userId);
                session.setAttribute("userName", userName);
                
                // Dashboard par redirect karein
                response.sendRedirect("Dashboard.jsp");
                return;
            } else {
                message = "Invalid Email or Password!";
                messageType = "error";
            }
            
        } catch(Exception e) {
            e.printStackTrace();
            message = "Something went wrong: " + e.getMessage();
            messageType = "error";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Bank App</title>
    
    <style>
        /* ===== General Body Styling ===== */
        body { 
            font-family: 'Segoe UI', Arial, sans-serif; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex; 
            justify-content: center; 
            align-items: center; 
            min-height: 100vh; 
            margin: 0; 
            padding: 20px;
            box-sizing: border-box;
        }

        /* ===== Main Container (Card) ===== */
        .container { 
            background: #ffffff; 
            padding: 40px 35px; 
            border-radius: 15px; 
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3); 
            width: 100%;
            max-width: 400px;
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* ===== Heading ===== */
        h2 { 
            text-align: center; 
            color: #333; 
            margin-top: 0;
            margin-bottom: 25px; 
            font-size: 26px;
            font-weight: 600;
        }

        /* ===== Input Fields ===== */
        input, select { 
            width: 100%; 
            padding: 12px 15px; 
            margin: 8px 0; 
            border: 1.5px solid #ddd; 
            border-radius: 8px; 
            box-sizing: border-box;
            font-size: 14px;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        input:focus, select:focus { 
            outline: none; 
            border-color: #667eea; 
            box-shadow: 0 0 8px rgba(102, 126, 234, 0.3);
        }

        input::placeholder {
            color: #aaa;
        }

        /* ===== Buttons ===== */
        button { 
            width: 100%; 
            padding: 13px; 
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; 
            border: none; 
            border-radius: 8px; 
            cursor: pointer; 
            font-size: 16px;
            font-weight: 600;
            margin-top: 12px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            font-family: inherit;
        }

        button:hover { 
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }

        button:active {
            transform: translateY(0);
        }

        /* ===== Links ===== */
        .link { 
            text-align: center; 
            margin-top: 18px; 
            font-size: 14px; 
            color: #666;
        }

        .link a { 
            color: #667eea; 
            text-decoration: none; 
            font-weight: 600;
            transition: color 0.2s ease;
        }

        .link a:hover { 
            color: #764ba2;
            text-decoration: underline;
        }

        a { 
            color: #667eea; 
            text-decoration: none;
        }

        /* ===== Error Message ===== */
        .error { 
            color: #d8000c; 
            text-align: center; 
            background: #ffe6e6; 
            padding: 12px; 
            border-radius: 8px; 
            border-left: 4px solid #d8000c;
            margin-bottom: 15px;
            font-size: 14px;
        }

        /* ===== Success Message ===== */
        .success { 
            color: #270; 
            text-align: center; 
            background: #e6ffe6; 
            padding: 12px; 
            border-radius: 8px; 
            border-left: 4px solid #270;
            margin-bottom: 15px;
            font-size: 14px;
        }

        /* ===== Responsive Design (Mobile) ===== */
        @media (max-width: 480px) {
            .container { padding: 25px 20px; }
            h2 { font-size: 22px; }
            input, select, button { font-size: 14px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Login</h2>
        
        <% if(!message.isEmpty()) { %>
            <p class="<%= messageType %>"><%= message %></p>
        <% } %>
        
        <form action="Login.jsp" method="post">
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        
        <div class="link">
            <a href="Register.jsp">New user? Register here</a>
        </div>
    </div>
</body>
</html>