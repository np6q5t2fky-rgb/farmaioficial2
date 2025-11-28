@echo off
echo ================================
echo   FarmAI - Повний Запуск
echo ================================
echo.
echo Запускаю Backend та Frontend...
echo.

start "FarmAI Backend" cmd /k "%~dp0start-backend.bat"
timeout /t 3 /nobreak >nul
start "FarmAI Frontend" cmd /k "%~dp0start-frontend.bat"

echo.
echo Обидва сервери запущені в окремих вікнах!
echo Backend: http://localhost:5000
echo Frontend: http://localhost:3000
echo.
pause
