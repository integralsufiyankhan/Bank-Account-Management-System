<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="DB.DBDatabaseConnection"%>

<%
    // Session check
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("Login.jsp?error=Please login first!");
        return;
    }
    
    int userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    
    // URL se txn_id nikalna
    String txnIdStr = request.getParameter("txn_id");
    if(txnIdStr == null) {
        response.sendRedirect("Dashboard.jsp");
        return;
    }
    
    int txnId = Integer.parseInt(txnIdStr);
    
    // Transaction details fetch karein
    String txnDate = "";
    String txnType = "";
    double txnAmount = 0;
    double txnBalance = 0;
    String txnDesc = "";
    int accNo = 0;
    
    try {
        DBDatabaseConnection db = new DBDatabaseConnection();
        
        db.pstmt = db.con.prepareStatement(
            "SELECT t.*, a.account_no FROM transactions t " +
            "JOIN accounts a ON t.account_no = a.account_no " +
            "WHERE t.txn_id=? AND a.user_id=?"
        );
        db.pstmt.setInt(1, txnId);
        db.pstmt.setInt(2, userId);
        db.rst = db.pstmt.executeQuery();
        
        if(db.rst.next()) {
            txnDate = db.rst.getTimestamp("txn_date").toString();
            txnType = db.rst.getString("type");
            txnAmount = db.rst.getDouble("amount");
            txnBalance = db.rst.getDouble("balance_after");
            txnDesc = db.rst.getString("description");
            accNo = db.rst.getInt("account_no");
        } else {
            response.sendRedirect("Dashboard.jsp");
            return;
        }
    } catch(Exception e) {
        e.printStackTrace();
    }
    
    // Receipt number generate karein
    String receiptNo = "TXN" + String.format("%06d", txnId);
    String sign = txnType.equals("DEPOSIT") ? "+" : "-";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Receipt - Bank App</title>
    
    <style>
        * { box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f0f2f5;
            margin: 0;
            padding: 30px 20px;
            min-height: 100vh;
        }
        
        .receipt-box {
            background: white;
            max-width: 600px;
            margin: 0 auto;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border-top: 6px solid #667eea;
        }
        
        /* Bank Header */
        .bank-header {
            text-align: center;
            border-bottom: 2px dashed #ddd;
            padding-bottom: 20px;
            margin-bottom: 25px;
        }
        
        .bank-header h1 {
            color: #667eea;
            margin: 0 0 5px 0;
            font-size: 28px;
        }
        
        .bank-header p {
            color: #666;
            margin: 0;
            font-size: 14px;
        }
        
        /* Receipt Title */
        .receipt-title {
            text-align: center;
            background: #f8f9ff;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 25px;
        }
        
        .receipt-title h2 {
            margin: 0;
            color: #333;
            font-size: 20px;
            letter-spacing: 1px;
        }
        
        .receipt-title p {
            margin: 5px 0 0 0;
            color: #667eea;
            font-size: 13px;
            font-weight: 600;
        }
        
        /* Details Table */
        .details {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 25px;
        }
        
        .details tr td {
            padding: 12px 5px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 15px;
        }
        
        .details tr td:first-child {
            color: #666;
            width: 45%;
        }
        
        .details tr td:last-child {
            text-align: right;
            font-weight: 600;
            color: #333;
        }
        
        .amount-highlight {
            font-size: 24px !important;
            font-weight: 700 !important;
            color: #667eea !important;
        }
        
        .deposit { color: #270 !important; }
        .withdraw { color: #d8000c !important; }
        
        /* Footer */
        .footer {
            text-align: center;
            border-top: 2px dashed #ddd;
            padding-top: 20px;
            margin-top: 20px;
            color: #999;
            font-size: 12px;
        }
        
        /* Buttons */
        .btn-group {
            text-align: center;
            margin-top: 25px;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            margin: 5px;
            transition: all 0.2s ease;
        }
        
        .btn-print {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }
        
        .btn-print:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-back {
            background: #f0f0f0;
            color: #333;
        }
        
        .btn-back:hover {
            background: #e0e0e0;
        }
        
        /* Print Styles */
        @media print {
            body {
                background: white;
                padding: 0;
            }
            .receipt-box {
                box-shadow: none;
                border-radius: 0;
                max-width: 100%;
                padding: 20px;
            }
            .btn-group {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="receipt-box">
        
        <!-- Bank Header -->
        <div class="bank-header">
            <h1>🏦 Bank App</h1>
            <p>Your Trusted Banking Partner</p>
        </div>
        
        <!-- Receipt Title -->
        <div class="receipt-title">
            <h2>TRANSACTION RECEIPT</h2>
            <p>Receipt No: <%= receiptNo %></p>
        </div>
        
        <!-- Transaction Details -->
        <table class="details">
            <tr>
                <td>Account Holder</td>
                <td><%= userName %></td>
            </tr>
            <tr>
                <td>Account Number</td>
                <td><%= accNo %></td>
            </tr>
            <tr>
                <td>Transaction Date</td>
                <td><%= txnDate %></td>
            </tr>
            <tr>
                <td>Transaction Type</td>
                <td class="<%= txnType.equals("DEPOSIT") ? "deposit" : "withdraw" %>">
                    <%= txnType %>
                </td>
            </tr>
            <tr>
                <td>Description</td>
                <td><%= txnDesc %></td>
            </tr>
            <tr>
                <td>Amount</td>
                <td class="amount-highlight <%= txnType.equals("DEPOSIT") ? "deposit" : "withdraw" %>">
                    <%= sign %> ₹<%= txnAmount %>
                </td>
            </tr>
            <tr>
                <td>Balance After Transaction</td>
                <td>₹ <%= txnBalance %></td>
            </tr>
        </table>
        
        <!-- Footer -->
        <div class="footer">
            <p>This is a computer-generated receipt. No signature required.</p>
            <p>Thank you for banking with us! 💜</p>
        </div>
        
        <!-- Buttons (Print mein nahi dikhenge) -->
        <div class="btn-group">
            <button class="btn btn-print" onclick="window.print()">🖨️ Print / Save as PDF</button>
            <a href="Dashboard.jsp" class="btn btn-back">← Back to Dashboard</a>
        </div>
        
    </div>
</body>
</html>