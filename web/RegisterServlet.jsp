<%@page import="org.apache.commons.fileupload.*"%>
<%@page import="org.apache.commons.fileupload.disk.*"%>
<%@page import="org.apache.commons.fileupload.servlet.*"%>

<%
    String message = "";
    String messageType = "";
    
    if(request.getMethod().equalsIgnoreCase("POST")) {
        
        String name = "", email = "", password = "", phone = "";
        String photoFileName = "avatar.png";
        
        try {
            // ===== NAYA API (FileUpload 1.6.0 ke liye) =====
            if(ServletFileUpload.isMultipartContent(request)) {
                
                // Temporary folder
                File tempDir = new File(System.getProperty("java.io.tmpdir"));
                DiskFileItemFactory factory = new DiskFileItemFactory(1024 * 1024, tempDir);
                ServletFileUpload upload = new ServletFileUpload(factory);
                upload.setFileSizeMax(5 * 1024 * 1024); // 5MB
                upload.setSizeMax(10 * 1024 * 1024);    // 10MB
                upload.setHeaderEncoding("UTF-8");
                
                // Upload folder path
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if(!uploadDir.exists()) uploadDir.mkdir();
                
                // Items parse karein
                List<FileItem> items = upload.parseRequest(request);
                
                System.out.println("Total items: " + items.size()); // DEBUG
                
                for(FileItem item : items) {
                    if(item.isFormField()) {
                        // Text field
                        String fieldName = item.getFieldName();
                        String value = item.getString("UTF-8");
                        System.out.println("Field: " + fieldName + " = " + value); // DEBUG
                        
                        if(fieldName.equals("name")) name = value;
                        else if(fieldName.equals("email")) email = value;
                        else if(fieldName.equals("password")) password = value;
                        else if(fieldName.equals("phone")) phone = value;
                        
                    } else {
                        // File field
                        String fileName = item.getName();
                        System.out.println("File: " + fileName); // DEBUG
                        
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
            
            System.out.println("Final values -> name: " + name + ", email: " + email); // DEBUG
            
            if(message.isEmpty()) {
                DBDatabaseConnection db = new DBDatabaseConnection();
                
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