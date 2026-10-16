<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SecureTrust Bank - Next-Gen Banking</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* CSS Variables for Light & Dark Mode */
        :root[data-theme="light"] {
            --bg-gradient: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --header-bg: rgba(255, 255, 255, 0.85);
            --primary: #0f172a;
            --accent: #2563eb;
            --accent-hover: #1d4ed8;
            --feature-bg: #f8fafc;
            --shadow-lg: 0 20px 25px -5px rgba(0, 0, 0, 0.08);
        }

        :root[data-theme="dark"] {
            --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            --card-bg: #1e293b;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border-color: #334155;
            --header-bg: rgba(30, 41, 59, 0.85);
            --primary: #f8fafc;
            --accent: #3b82f6;
            --accent-hover: #60a5fa;
            --feature-bg: #0f172a;
            --shadow-lg: 0 20px 25px -5px rgba(0, 0, 0, 0.5);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Plus Jakarta Sans', sans-serif;
            transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease;
        }

        body {
            background: var(--bg-gradient);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        /* ===== Header Bar ===== */
        header {
            width: 100%;
            background: var(--header-bg);
            backdrop-filter: blur(10px);
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 1px solid var(--border-color);
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 20px;
            font-weight: 800;
            color: var(--primary);
            text-decoration: none;
        }

        .logo i {
            color: var(--accent);
            font-size: 24px;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .secure-badge {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            font-weight: 600;
            color: #10b981;
            background: rgba(16, 185, 129, 0.1);
            padding: 6px 12px;
            border-radius: 20px;
        }

        /* Theme Toggle Button */
        .theme-toggle {
            background: var(--border-color);
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            color: var(--text-main);
            font-size: 16px;
        }

        .theme-toggle:hover {
            background: var(--accent);
            color: white;
        }

        /* ===== Main Content Area ===== */
        .content-container {
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
            padding: 40px 20px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            align-items: center;
        }

        /* Hero Login Card */
        .auth-card {
            background: var(--card-bg);
            padding: 40px 35px;
            border-radius: 24px;
            box-shadow: var(--shadow-lg);
            border: 1px solid var(--border-color);
            position: relative;
            overflow: hidden;
        }

        .auth-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, #2563eb, #9333ea);
        }

        .hero-icon {
            width: 60px;
            height: 60px;
            background: rgba(37, 99, 235, 0.1);
            color: var(--accent);
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 16px;
            font-size: 26px;
            margin-bottom: 20px;
        }

        h2 {
            color: var(--primary);
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .subtitle {
            color: var(--text-muted);
            font-size: 14px;
            margin-bottom: 25px;
            line-height: 1.5;
        }

        .btn-group {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .btn {
            width: 100%;
            padding: 13px 20px;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-decoration: none;
            transition: transform 0.2s ease;
        }

        .btn-primary {
            background: var(--accent);
            color: white;
            border: none;
        }

        .btn-primary:hover {
            background: var(--accent-hover);
            transform: translateY(-2px);
        }

        .btn-outline {
            background: transparent;
            color: var(--primary);
            border: 2px solid var(--border-color);
        }

        .btn-outline:hover {
            background: var(--border-color);
            transform: translateY(-2px);
        }

        /* ===== Features Showcase Section ===== */
        .features-section {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .features-section h3 {
            font-size: 22px;
            color: var(--primary);
            font-weight: 700;
        }

        .feature-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            padding: 18px 20px;
            border-radius: 16px;
            display: flex;
            align-items: flex-start;
            gap: 15px;
        }

        .feature-card i {
            font-size: 22px;
            color: var(--accent);
            background: rgba(37, 99, 235, 0.1);
            padding: 12px;
            border-radius: 12px;
        }

        .feature-info h4 {
            font-size: 16px;
            color: var(--primary);
            margin-bottom: 4px;
        }

        .feature-info p {
            font-size: 13px;
            color: var(--text-muted);
            line-height: 1.4;
        }

        /* ===== Footer Section ===== */
        footer {
            width: 100%;
            background: var(--card-bg);
            border-top: 1px solid var(--border-color);
            padding: 25px 20px;
            margin-top: 40px;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            font-size: 13px;
            color: var(--text-muted);
        }

        .creator-info {
            font-weight: 600;
            color: var(--primary);
        }

        /* Responsive Design */
        @media (max-width: 900px) {
            .content-container {
                grid-template-columns: 1fr;
                gap: 30px;
                padding: 20px;
            }
            .secure-badge {
                display: none; /* Hide badge on very small screens to save space */
            }
        }
    </style>
</head>
<body>

    <!-- Header & Navigation -->
    <header>
        <div class="nav-container">
            <a href="#" class="logo">
                <i class="fa-solid fa-building-columns"></i> SecureTrust
            </a>
            <div class="nav-right">
                <div class="secure-badge">
                    <i class="fa-solid fa-shield-halved"></i> 256-bit Bank Grade Security
                </div>
                <!-- Light / Dark Mode Toggle Button -->
                <button class="theme-toggle" id="themeToggleBtn" onclick="toggleTheme()" title="Switch Theme">
                    <i class="fa-solid fa-moon" id="themeIcon"></i>
                </button>
            </div>
        </div>
    </header>

    <!-- Main Content Area (Auth + Features) -->
    <div class="content-container">
        
        <!-- Left Side: Login / Register Box -->
        <div class="auth-card">
            <div class="hero-icon">
                <i class="fa-solid fa-vault"></i>
            </div>
            <h2>Welcome to Portal</h2>
            <p class="subtitle">Securely log into your bank account or register a new account to begin your digital banking journey.</p>
            
            <div class="btn-group">
                <a href="Login.jsp" class="btn btn-primary">
                    <i class="fa-solid fa-right-to-bracket"></i> Login to Account
                </a>
                
                <a href="Register.jsp" class="btn btn-outline">
                    <i class="fa-solid fa-user-plus"></i> Open New Account
                </a>
            </div>
        </div>

        <!-- Right Side: Application Features -->
        <div class="features-section">
            <h3>App Features & Highlights</h3>
            
            <div class="feature-card">
                <i class="fa-solid fa-bolt"></i>
                <div class="feature-info">
                    <h4>Instant Fund Transfer</h4>
                    <p>Transfer money securely across accounts instantly with high-speed transaction networks.</p>
                </div>
            </div>

            <div class="feature-card">
                <i class="fa-solid fa-fingerprint"></i>
                <div class="feature-info">
                    <h4>Advanced Security & SSL</h4>
                    <p>Protected with multi-layer authorization, encryption protocols, and anti-fraud detection.</p>
                </div>
            </div>

            <div class="feature-card">
                <i class="fa-solid fa-chart-pie"></i>
                <div class="feature-info">
                    <h4>Smart Account Tracking</h4>
                    <p>Track your deposit history, check live balances, and view statement archives in real-time.</p>
                </div>
            </div>
        </div>

    </div>

    <!-- Footer with Developer/Creator info -->
    <footer>
        <div class="footer-content">
            <div>&copy; 2026-27 SecureTrust Bank N.A. All rights reserved. Developed By Sufiyan Khan</div>
            <div class="creator-info">
                Designed & Developed with <i class="fa-solid fa-heart" style="color: #ef4444;"></i> for Secure Banking
            </div>
        </div>
    </footer>

    <!-- JavaScript for Dark/Light Mode Switching -->
    <script>
        const toggleBtn = document.getElementById('themeToggleBtn');
        const themeIcon = document.getElementById('themeIcon');
        const htmlElement = document.documentElement;

        function toggleTheme() {
            let currentTheme = htmlElement.getAttribute('data-theme');
            if (currentTheme === 'light') {
                htmlElement.setAttribute('data-theme', 'dark');
                themeIcon.className = 'fa-solid fa-sun';
                localStorage.setItem('bank_app_theme', 'dark');
            } else {
                htmlElement.setAttribute('data-theme', 'light');
                themeIcon.className = 'fa-solid fa-moon';
                localStorage.setItem('bank_app_theme', 'light');
            }
        }

        // Save preference check on load
        window.addEventListener('DOMContentLoaded', () => {
            const savedTheme = localStorage.getItem('bank_app_theme') || 'light';
            htmlElement.setAttribute('data-theme', savedTheme);
            themeIcon.className = savedTheme === 'dark' ? 'fa-solid fa-sun' : 'fa-solid fa-moon';
        });
    </script>

</body>
</html>