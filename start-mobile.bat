@echo off
chcp 65001 >nul
cls
echo ========================================
echo   Облік Свиноферми - Запуск
echo ========================================
echo.

echo Визначаю IP адресу...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do set IP=%%a
set IP=%IP:~1%
echo.
echo ========================================
echo   IP адреса комп'ютера: %IP%
echo ========================================
echo.
echo На телефоні відкрийте:
echo.
echo   http://%IP%:3000
echo.
echo ========================================
echo.

echo Запускаю сервери...
echo.

cd /d "%~dp0"

start "Backend - Облік Свиноферми" cmd /k "cd backend && python app.py"
timeout /t 3 /nobreak >nul
start "Frontend - Облік Свиноферми" cmd /k "cd frontend && npm start"

echo.
echo Обидва сервера запущені!
echo.
echo Якщо не працює, перевірте:
echo 1. Телефон та комп'ютер в одній WiFi
echo 2. Фаєрвол Windows вимкнений або налаштований
echo.
pause
