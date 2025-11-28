@echo off
echo ================================
echo   FarmAI - Запуск Backend
echo ================================
echo.

cd /d "%~dp0backend"

if not exist venv (
    echo Створюю віртуальне середовище...
    python -m venv venv
)

echo Активую віртуальне середовище...
call venv\Scripts\activate.bat

if not exist .env (
    echo.
    echo УВАГА: Файл .env не знайдено!
    echo Створюю з шаблону...
    copy .env.example .env
    echo.
    echo Відредагуйте backend\.env та додайте ваш GEMINI_API_KEY
    echo.
    pause
    exit /b
)

echo Перевірка залежностей...
pip install -q -r requirements.txt

echo.
echo ================================
echo   Запуск сервера...
echo   Backend: http://localhost:5000
echo ================================
echo.

python app.py
