@echo off
echo ================================
echo   FarmAI - Production Build
echo ================================
echo.

echo Крок 1: Збірка Frontend...
cd /d "%~dp0frontend"
call npm run build

echo.
echo Крок 2: Копіювання в Backend...
xcopy /E /I /Y build ..\backend\frontend_build

echo.
echo ================================
echo   Збірка завершена!
echo   Запустіть: start-backend.bat
echo   Відкрийте: http://localhost:5000
echo ================================
pause
