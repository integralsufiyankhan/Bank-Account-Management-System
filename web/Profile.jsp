<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="DB.DBDatabaseConnection"%>

<%
    // ===== SESSION CHECK =====
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("Login.jsp?error=Please login first!");
        return;
    }
    
    int userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    
    // ===== BACKEND: User ki saari details fetch karein =====
    String name = "", email = "", phone = "";
    int accNo = 0;
    String accType = "";
    double balance = 0;
    String createdAt = "";
    
    try {
        DBDatabaseConnection db = new DBDatabaseConnection();
        
        // Users table se details
        db.pstmt = db.con.prepareStatement(
            "SELECT name, email, phone, created_at FROM users WHERE id=?"
        );
        db.pstmt.setInt(1, userId);
        db.rst = db.pstmt.executeQuery();
        if(db.rst.next()) {
            name = db.rst.getString("name");
            email = db.rst.getString("email");
            phone = db.rst.getString("phone");
            createdAt = db.rst.getTimestamp("created_at").toString();
        }
        
        // Accounts table se details
        db.pstmt2 = db.con.prepareStatement(
            "SELECT account_no, account_type, balance FROM accounts WHERE user_id=?"
        );
        db.pstmt2.setInt(1, userId);
        ResultSet rs2 = db.pstmt2.executeQuery();
        if(rs2.next()) {
            accNo = rs2.getInt("account_no");
            accType = rs2.getString("account_type");
            balance = rs2.getDouble("balance");
        }
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Bank App</title>
    
    <style>
        body { 
            font-family: 'Segoe UI', Arial, sans-serif; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh; 
            margin: 0; 
            padding: 30px 20px;
            box-sizing: border-box;
        }

        .container { 
            background: #ffffff; 
            padding: 35px; 
            border-radius: 15px; 
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3); 
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* ===== Header ===== */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 15px;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .header h2 {
            color: #333;
            margin: 0;
            font-size: 22px;
            font-weight: 600;
        }

        .back-btn {
            background: #667eea;
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: background 0.3s ease;
        }

        .back-btn:hover { background: #5568d3; }

        /* ===== Profile Photo Section ===== */
        .profile-top {
            text-align: center;
            margin-bottom: 25px;
        }

        .profile-avatar {
            width: 110px;
            height: 110px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #667eea;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
            margin-bottom: 10px;
            background: #f0f0f0;
        }

        .profile-top h3 {
            color: #333;
            margin: 5px 0;
            font-size: 22px;
        }

        .profile-top p {
            color: #999;
            margin: 0;
            font-size: 14px;
        }

        /* ===== Info Rows ===== */
        .info-section {
            background: #f8f9ff;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
        }

        .info-section h4 {
            color: #667eea;
            margin-top: 0;
            margin-bottom: 15px;
            font-size: 15px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #e8e8e8;
            font-size: 15px;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-row .label {
            color: #666;
            font-weight: 500;
        }

        .info-row .value {
            color: #333;
            font-weight: 600;
            text-align: right;
        }

        .balance-value {
            color: #270 !important;
            font-size: 20px !important;
        }

        /* ===== Responsive ===== */
        @media (max-width: 480px) {
            .container { padding: 20px; }
            .header h2 { font-size: 18px; }
            .profile-avatar { width: 90px; height: 90px; }
            .info-row { font-size: 13px; }
        }
    </style>
</head>
<body>
    <div class="container">
        
        <!-- Header -->
        <div class="header">
            <h2>👤 My Profile</h2>
            <a href="Dashboard.jsp" class="back-btn">← Back</a>
        </div>
        
        <!-- Profile Photo -->
        <div class="profile-top">
            <img src="images/avatar.png" alt="Profile" class="profile-avatar">
            <h3><%= name %></h3>
            <p>Member since: <%= createdAt %></p>
        </div>
        
        <!-- Personal Information -->
        <div class="info-section">
            <h4>Personal Information</h4>
            <div class="info-row">
                <span class="label">Full Name</span>
                <span class="value"><%= name %></span>
            </div>
            <div class="info-row">
                <span class="label">Email</span>
                <span class="value"><%= email %></span>
            </div>
            <div class="info-row">
                <span class="label">Phone</span>
                <span class="value"><%= phone %></span>
            </div>
        </div>
        
        <!-- Account Information -->
        <div class="info-section">
            <h4>Account Information</h4>
            <div class="info-row">
                <span class="label">Account Number</span>
                <span class="value"><%= accNo %></span>
            </div>
            <div class="info-row">
                <span class="label">Account Type</span>
                <span class="value"><%= accType %></span>
            </div>
            <div class="info-row">
                <span class="label">Current Balance</span>
                <span class="value balance-value">₹ <%= balance %></span>
            </div>
        </div>
        
    </div>
</body>
</html>