@echo off
echo ============================================
echo   WanderAI Travel Planner - Setup Script
echo ============================================
echo.

:: Step 1 - Install Python packages
echo [1/4] Installing Python packages...
pip install flask mysql-connector-python requests
echo Done.
echo.

:: Step 2 - Set Gemini API Key
echo [2/4] Setting Gemini API Key...
echo Get your FREE key from: https://aistudio.google.com
echo Click "Get API Key" - no credit card needed!
echo.
set /p APIKEY="Paste your Gemini API key here: "
set GEMINI_API_KEY=%APIKEY%
echo API Key set for this session.
echo.

:: Step 3 - Set up MySQL database
echo [3/4] Setting up MySQL database...
set /p MYSQLPASS="MySQL root password: "
mysql -u root -p%MYSQLPASS% < schema.sql
echo Database setup complete.
echo.

:: Step 4 - Update app.py with the password
echo [4/4] Updating database config in app.py...
powershell -Command "(Get-Content app.py) -replace 'your_mysql_password', '%MYSQLPASS%' | Set-Content app.py"
echo Done.
echo.

echo ============================================
echo   Setup complete! Starting the server...
echo   Open http://localhost:5000 in your browser
echo ============================================
echo.
python app.py
pause
