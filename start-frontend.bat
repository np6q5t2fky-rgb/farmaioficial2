@echo off
echo ================================
echo   FarmAI - Запуск Frontend
echo ================================
echo.

cd /d "%~dp0frontend"

if not exist node_modules (
    echo Встановлюю залежності...
    call npm install
)

echo.
echo ================================
echo   Запуск сервера...
echo   Frontend: http://localhost:3000
echo ================================
echo.

call npm start
