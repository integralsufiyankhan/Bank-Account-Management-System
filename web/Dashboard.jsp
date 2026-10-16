<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page import="DB.DBDatabaseConnection"%>

<%
    // ===== SESSION CHECK =====
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("Login.jsp?error=Please login first!");
        return;
    }
    
    int userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    
    // ===== BACKEND CODE (Deposit/Withdraw) =====
    String message = "";
    String messageType = "";
    
    if(request.getMethod().equalsIgnoreCase("POST")) {
        String type = request.getParameter("type");
        String amountStr = request.getParameter("amount");
        
        try {
            double amount = Double.parseDouble(amountStr);
            
            if(amount <= 0) {
                message = "Amount must be greater than 0!";
                messageType = "error";
            } else {
                DBDatabaseConnection db = new DBDatabaseConnection();
                
                db.pstmt = db.con.prepareStatement("SELECT account_no, balance FROM accounts WHERE user_id=?");
                db.pstmt.setInt(1, userId);
                db.rst = db.pstmt.executeQuery();
                
                int accNo = 0;
                double balance = 0;
                if(db.rst.next()) {
                    accNo = db.rst.getInt("account_no");
                    balance = db.rst.getDouble("balance");
                }
                
                if(type.equals("WITHDRAW") && balance < amount) {
                    message = "Insufficient Balance! Available: ₹" + balance;
                    messageType = "error";
                } else {
                    double newBalance = type.equals("DEPOSIT") ? balance + amount : balance - amount;
                    
                    db.pstmt = db.con.prepareStatement("UPDATE accounts SET balance=? WHERE account_no=?");
                    db.pstmt.setDouble(1, newBalance);
                    db.pstmt.setInt(2, accNo);
                    db.pstmt.executeUpdate();
                    
                    db.pstmt2 = db.con.prepareStatement(
                        "INSERT INTO transactions(account_no, type, amount, balance_after, description) VALUES(?,?,?,?,?)"
                    );
                    db.pstmt2.setInt(1, accNo);
                    db.pstmt2.setString(2, type);
                    db.pstmt2.setDouble(3, amount);
                    db.pstmt2.setDouble(4, newBalance);
                    db.pstmt2.setString(5, type.equals("DEPOSIT") ? "Cash Deposit" : "Cash Withdrawal");
                    db.pstmt2.executeUpdate();
                    
                    message = type.equals("DEPOSIT") ? "₹" + amount + " Deposited Successfully!" : "₹" + amount + " Withdrawn Successfully!";
                    messageType = "success";
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
            message = "Something went wrong: " + e.getMessage();
            messageType = "error";
        }
    }
    
    // ===== USER PHOTO + ACCOUNT DETAILS EK HI CONNECTION SE =====
    String userPhoto = "avatar.png";   // Default
    int accNo = 0;
    double balance = 0;
    
    try {
        DBDatabaseConnection db = new DBDatabaseConnection();
        
        // 1. Photo fetch karein
        db.pstmt = db.con.prepareStatement("SELECT photo FROM users WHERE id=?");
        db.pstmt.setInt(1, userId);
        db.rst = db.pstmt.executeQuery();
        if(db.rst.next()) {
            String p = db.rst.getString("photo");
            if(p != null && !p.isEmpty()) {
                // Check karein ki file actually exist karti hai
                String photoPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + p;
                File photoFile = new File(photoPath);
                if(photoFile.exists()) {
                    userPhoto = p;
                }
            }
        }
        
        // 2. Account details fetch karein
        db.pstmt2 = db.con.prepareStatement("SELECT account_no, balance FROM accounts WHERE user_id=?");
        db.pstmt2.setInt(1, userId);
        ResultSet accRs = db.pstmt2.executeQuery();
        if(accRs.next()) {
            accNo = accRs.getInt("account_no");
            balance = accRs.getDouble("balance");
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
    <title>Dashboard - Bank App</title>
    
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
            max-width: 750px;
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

        .user-info {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        /* ===== PHOTO AVATAR ===== */
        .avatar {
            width: 55px;
            height: 55px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #667eea;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            flex-shrink: 0;
            background: #f0f0f0;
        }

        .user-info h2 {
            color: #333;
            margin: 0;
            font-size: 22px;
            font-weight: 600;
        }

        /* ===== Header Buttons ===== */
        .header-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .profile-btn {
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

        .profile-btn:hover { background: #5568d3; }

        .logout-btn {
            background: #e74c3c;
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

        .logout-btn:hover { background: #c0392b; }

        /* ===== Account Info Card ===== */
        .info-card {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 25px;
        }

        .info-card h3 {
            margin: 0 0 15px 0;
            font-size: 18px;
            font-weight: 500;
            opacity: 0.9;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin: 10px 0;
            font-size: 16px;
        }

        .info-row .label { opacity: 0.9; }
        .info-row .value { font-weight: 600; font-size: 18px; }
        .balance-amount { font-size: 32px !important; font-weight: 700 !important; }

        /* ===== Form Section ===== */
        .form-section {
            background: #f8f9ff;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
        }

        .form-section h3 {
            margin-top: 0;
            color: #333;
            font-size: 18px;
        }

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

        button[type="submit"] { 
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

        button[type="submit"]:hover { 
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }

        /* ===== Messages ===== */
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

        /* ===== Table ===== */
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 15px;
            font-size: 13px;
        }

        th, td { 
            border: 1px solid #e0e0e0; 
            padding: 10px; 
            text-align: left; 
        }

        th { 
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; 
            font-weight: 600;
            font-size: 12px;
        }

        tr:nth-child(even) { background-color: #f9f9f9; }
        tr:hover { background-color: #f0f4ff; }

        .deposit-row { color: #270; font-weight: 600; }
        .withdraw-row { color: #d8000c; font-weight: 600; }

        .receipt-btn {
            background: #667eea;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 11px;
            font-weight: 600;
            display: inline-block;
            transition: background 0.2s ease;
            white-space: nowrap;
        }

        .receipt-btn:hover { background: #764ba2; }

        h3.section-title {
            color: #333;
            font-size: 18px;
            margin-top: 30px;
            margin-bottom: 10px;
        }

        @media (max-width: 480px) {
            .container { padding: 20px; }
            .user-info h2 { font-size: 16px; }
            .avatar { width: 45px; height: 45px; }
            .balance-amount { font-size: 26px !important; }
            table { font-size: 11px; }
            th, td { padding: 6px; }
            .receipt-btn { font-size: 10px; padding: 4px 6px; }
        }
    </style>
</head>
<body>
    <div class="container">
        
        <!-- Header with Photo Avatar (DATABASE SE) -->
        <div class="header">
            <div class="user-info">
                <a href="Profile.jsp">
                    <img src="uploads/<%= userPhoto %>" alt="User Avatar" class="avatar">
                </a>
                <h2>Welcome, <%= userName %></h2>
            </div>
            <div class="header-buttons">
                <a href="Profile.jsp" class="profile-btn">👤 Profile</a>
                <a href="Logout.jsp" class="logout-btn">Logout</a>
            </div>
        </div>
        
        <!-- Messages -->
        <% if(!message.isEmpty()) { %>
            <p class="<%= messageType %>"><%= message %></p>
        <% } %>
        
        <!-- Account Info Card -->
        <div class="info-card">
            <h3>Account Details</h3>
            <div class="info-row">
                <span class="label">Account Number:</span>
                <span class="value"><%= accNo %></span>
            </div>
            <div class="info-row">
                <span class="label">Account Type:</span>
                <span class="value">Savings</span>
            </div>
            <div class="info-row">
                <span class="label">Current Balance:</span>
                <span class="value balance-amount">₹ <%= balance %></span>
            </div>
        </div>
        
        <!-- Deposit / Withdraw Form -->
        <div class="form-section">
            <h3>💸 Deposit / Withdraw</h3>
            <form action="Dashboard.jsp" method="post">
                <select name="type" required>
                    <option value="DEPOSIT">Deposit</option>
                    <option value="WITHDRAW">Withdraw</option>
                </select>
                <input type="number" name="amount" placeholder="Enter Amount" min="1" step="0.01" required>
                <button type="submit">Submit Transaction</button>
            </form>
        </div>
        
        <!-- Transaction History -->
        <h3 class="section-title">📜 Transaction History</h3>
        <table>
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Type</th>
                    <th>Amount</th>
                    <th>Balance</th>
                    <th>Description</th>
                    <th>Receipt</th>
                </tr>
            </thead>
            <tbody>
            <%
                try {
                    DBDatabaseConnection db = new DBDatabaseConnection();
                    db.pstmt2 = db.con.prepareStatement(
                        "SELECT * FROM transactions WHERE account_no=? ORDER BY txn_date DESC"
                    );
                    db.pstmt2.setInt(1, accNo);
                    ResultSet txnRs = db.pstmt2.executeQuery();
                    
                    boolean hasTxn = false;
                    while(txnRs.next()) {
                        hasTxn = true;
                        String txnType = txnRs.getString("type");
                        String rowClass = txnType.equals("DEPOSIT") ? "deposit-row" : "withdraw-row";
                        String sign = txnType.equals("DEPOSIT") ? "+" : "-";
                        int txnId = txnRs.getInt("txn_id");
            %>
                <tr>
                    <td><%= txnRs.getTimestamp("txn_date") %></td>
                    <td class="<%= rowClass %>"><%= txnType %></td>
                    <td class="<%= rowClass %>"><%= sign %> ₹<%= txnRs.getDouble("amount") %></td>
                    <td>₹ <%= txnRs.getDouble("balance_after") %></td>
                    <td><%= txnRs.getString("description") %></td>
                    <td>
                        <a href="Receipt.jsp?txn_id=<%= txnId %>" class="receipt-btn">🧾 Receipt</a>
                    </td>
                </tr>
            <%
                    }
                    if(!hasTxn) {
            %>
                <tr>
                    <td colspan="6" style="text-align:center; color:#999; padding:20px;">
                        No transactions yet.
                    </td>
                </tr>
            <%
                    }
                } catch(Exception e) {
                    e.printStackTrace();
                }
            %>
            </tbody>
        </table>
        
    </div>
</body>
</html>