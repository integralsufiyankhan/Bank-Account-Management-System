<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.commons.fileupload.*"%>
<%@page import="org.apache.commons.fileupload.disk.*"%>
<%@page import="org.apache.commons.fileupload.servlet.*"%>
<%@page import="DB.DBDatabaseConnection"%>

<%
    // ===== BACKEND CODE =====
    String message = "";
    String messageType = "";
    
    if(request.getMethod().equalsIgnoreCase("POST")) {
        
        String name = "", email = "", password = "", phone = "";
        String photoFileName = "avatar.png";
        
        try {
            // ===== COMMONS FILEUPLOAD SE FORM DATA PARSE KAREIN =====
            boolean isMultipart = ServletFileUpload.isMultipartContent(request);
            
            if(isMultipart) {
                DiskFileItemFactory factory = new DiskFileItemFactory();
                ServletFileUpload upload = new ServletFileUpload(factory);
                upload.setHeaderEncoding("UTF-8");
                
                // Upload folder
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if(!uploadDir.exists()) uploadDir.mkdir();
                
                // Items parse karein
                List<FileItem> items = upload.parseRequest(request);
                
                // DEBUG (baad mein hata sakte hain)
                System.out.println("DEBUG: Total items = " + items.size());
                
                for(FileItem item : items) {
                    System.out.println("DEBUG: Field=" + item.getFieldName() 
                        + " | isForm=" + item.isFormField() 
                        + " | Value=" + (item.isFormField() ? item.getString("UTF-8") : item.getName()));
                    
                    if(item.isFormField()) {
                        String fieldName = item.getFieldName();
                        String value = item.getString("UTF-8");
                        
                        if(fieldName.equals("name")) name = value;
                        else if(fieldName.equals("email")) email = value;
                        else if(fieldName.equals("password")) password = value;
                        else if(fieldName.equals("phone")) phone = value;
                        
                    } else {
                        String fileName = item.getName();
                        
                        if(fileName != null && !fileName.isEmpty()) {
                            String ext = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
                            
                            if(ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png") || ext.equals(".gif")) {
                                photoFileName = email.replaceAll("[^a-zA-Z0-9]", "_") + "_" + System.currentTimeMillis() + ext;
                                File storeFile = new File(uploadPath + File.separator + photoFileName);
                                item.write(storeFile);
                            } else {
                                message = "Only JPG, JPEG, PNG, GIF allowed!";
                                messageType = "error";
                            }
                        }
                    }
                }
            }
            
            if(message.isEmpty()) {
                DBDatabaseConnection db = new DBDatabaseConnection();
                
                // Email check
                db.pstmt = db.con.prepareStatement("SELECT id FROM users WHERE email=?");
                db.pstmt.setString(1, email);
                db.rst = db.pstmt.executeQuery();
                
                if(db.rst.next()) {
                    message = "Email already registered! Try another.";
                    messageType = "error";
                } else {
                    db.pstmt = db.con.prepareStatement(
                        "INSERT INTO users(name, email, password, phone, photo) VALUES(?,?,?,?,?)"
                    );
                    db.pstmt.setString(1, name);
                    db.pstmt.setString(2, email);
                    db.pstmt.setString(3, password);
                    db.pstmt.setString(4, phone);
                    db.pstmt.setString(5, photoFileName);
                    db.pstmt.executeUpdate();
                    
                    db.pstmt2 = db.con.prepareStatement("SELECT id FROM users WHERE email=?");
                    db.pstmt2.setString(1, email);
                    db.rst = db.pstmt2.executeQuery();
                    int userId = 0;
                    if(db.rst.next()) userId = db.rst.getInt("id");
                    
                    db.pstmt = db.con.prepareStatement(
                        "INSERT INTO accounts(user_id, account_type, balance) VALUES(?, 'Savings', 0.00)"
                    );
                    db.pstmt.setInt(1, userId);
                    db.pstmt.executeUpdate();
                    
                    response.sendRedirect("Login.jsp?msg=Registration Successful! Please Login.");
                    return;
                }
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
    <title>Register - Bank App</title>
    
    <style>
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

        .container { 
            background: #ffffff; 
            padding: 40px 35px; 
            border-radius: 15px; 
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3); 
            width: 100%;
            max-width: 420px;
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 { 
            text-align: center; 
            color: #333; 
            margin-top: 0;
            margin-bottom: 25px; 
            font-size: 26px;
            font-weight: 600;
        }

        .photo-upload {
            text-align: center;
            margin-bottom: 20px;
        }

        .photo-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #667eea;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            background: #f0f0f0;
            margin-bottom: 10px;
            transition: transform 0.2s ease;
        }

        .photo-preview:hover { transform: scale(1.05); }

        .file-label {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 8px 18px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .file-label:hover { background: #5568d3; }

        input[type="file"] { display: none; }

        input[type="text"], input[type="email"], input[type="password"] { 
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

        input:focus { 
            outline: none; 
            border-color: #667eea; 
            box-shadow: 0 0 8px rgba(102, 126, 234, 0.3);
        }

        input::placeholder { color: #aaa; }

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
        }

        .link a:hover { 
            color: #764ba2;
            text-decoration: underline;
        }

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

        @media (max-width: 480px) {
            .container { padding: 25px 20px; }
            h2 { font-size: 22px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Create Bank Account</h2>
        
        <% if(!message.isEmpty()) { %>
            <p class="error"><%= message %></p>
        <% } %>
        
        <form action="Register.jsp" method="post" enctype="multipart/form-data">
            
            <div class="photo-upload">
                <img src="images/avatar.png" alt="Preview" class="photo-preview" id="preview">
                <br>
                <label for="photoInput" class="file-label">📷 Choose Photo</label>
                <input type="file" name="photo" id="photoInput" accept="image/*">
            </div>
            
            <input type="text" name="name" placeholder="Full Name" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="text" name="phone" placeholder="Phone Number" required>
            <button type="submit">Register</button>
        </form>
        
        <div class="link">
            <a href="Login.jsp">Already have account? Login</a>
        </div>
    </div>
    
    <script>
        document.getElementById('photoInput').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if(file) {
                const reader = new FileReader();
                reader.onload = function(event) {
                    document.getElementById('preview').src = event.target.result;
                };
                reader.readAsDataURL(file);
            }
        });
    </script>
</body>
</html>