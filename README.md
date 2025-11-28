# 🚜 FarmAI - Система Обліку Ферми з ШІ

Повнофункціональна система обліку ферми з інтеграцією Gemini AI від Google.

## 📋 Можливості

- 💬 **Чат з ШІ** - Інтелектуальний асистент для питань про ферму
- 🧠 **Пам'ять ШІ** - Збереження важливого контексту для кращих відповідей
- 📊 **Облік** - Повний облік ферми на основі Excel файлу з редагуванням
- 👥 **Багатокористувацька система** - До 5 користувачів
- 🌐 **Доступ до інтернету** - ШІ може давати актуальні поради
- 🎨 **Сучасний темний інтерфейс** - Зручний та естетичний дизайн

## 🏗️ Архітектура

**Backend:**
- Flask (Python) - REST API
- OpenPyXL - Робота з Excel
- Google Generative AI (Gemini)

**Frontend:**
- React 18
- Axios для HTTP запитів
- Адаптивний дизайн

## 📦 Встановлення (Windows)

### 1. Встановіть Python 3.8+
Завантажте з https://www.python.org/downloads/

### 2. Встановіть Node.js 16+
Завантажте з https://nodejs.org/

### 3. Клонуйте або перейдіть в директорію проекту
```powershell
cd d:\FARMAI
```

### 4. Налаштування Backend

```powershell
# Перейдіть в папку backend
cd backend

# Встановіть залежності Python
pip install -r requirements.txt

# Створіть файл .env
copy .env.example .env

# Відредагуйте .env та додайте ваш Gemini API ключ
# GEMINI_API_KEY=ваш_ключ_тут
```

**Як отримати Gemini API ключ:**
1. Перейдіть на https://makersuite.google.com/app/apikey
2. Увійдіть через Google акаунт
3. Натисніть "Create API Key"
4. Скопіюйте ключ у файл `.env`

### 5. Налаштування Frontend

```powershell
# Перейдіть в папку frontend
cd ..\frontend

# Встановіть залежності Node.js
npm install
```

## 🚀 Запуск Локально

### Варіант 1: Два термінали (для розробки)

**Термінал 1 - Backend:**
```powershell
cd d:\FARMAI\backend
python app.py
```
Сервер запуститься на http://localhost:5000

**Термінал 2 - Frontend:**
```powershell
cd d:\FARMAI\frontend
npm start
```
Інтерфейс відкриється на http://localhost:3000

### Варіант 2: Production режим

```powershell
# Збудуйте frontend
cd d:\FARMAI\frontend
npm run build

# Запустіть тільки backend (він буде віддавати frontend)
cd ..\backend
python app.py
```
Відкрийте http://localhost:5000

## 👥 Користувачі за замовчуванням

| Логін | Пароль | Роль  |
|-------|--------|-------|
| admin | admin  | admin |
| user1 | user1  | user  |
| user2 | user2  | user  |
| user3 | user3  | user  |
| user4 | user4  | user  |

## 📂 Структура Проекту

```
FARMAI/
├── backend/
│   ├── app.py              # Головний Flask сервер
│   ├── requirements.txt    # Python залежності
│   ├── .env.example        # Приклад конфігурації
│   └── data/               # JSON файли (історія, пам'ять, користувачі)
├── frontend/
│   ├── src/
│   │   ├── App.js          # Головний компонент
│   │   ├── App.css         # Стилі
│   │   └── components/     # React компоненти
│   │       ├── Login.js    # Авторизація
│   │       ├── Chat.js     # Чат з ШІ
│   │       ├── Memory.js   # Пам'ять ШІ
│   │       └── Accounting.js # Облік
│   ├── package.json
│   └── public/
└── тижневий облік.xlsx     # Excel файл з даними
```

## 🌐 Розгортання на VPS

### Підготовка VPS (Ubuntu/Debian)

```bash
# Оновлення системи
sudo apt update && sudo apt upgrade -y

# Встановлення Python та pip
sudo apt install python3 python3-pip python3-venv -y

# Встановлення Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs -y

# Встановлення Nginx
sudo apt install nginx -y
```

### Розгортання додатку

```bash
# Завантажте проект на VPS
scp -r d:\FARMAI user@your-vps-ip:/home/user/

# На VPS
cd /home/user/FARMAI

# Backend
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
nano .env  # Додайте GEMINI_API_KEY

# Frontend
cd ../frontend
npm install
npm run build

# Запуск через systemd
sudo nano /etc/systemd/system/farmai.service
```

**Вміст farmai.service:**
```ini
[Unit]
Description=FarmAI Backend
After=network.target

[Service]
User=your-user
WorkingDirectory=/home/user/FARMAI/backend
Environment="PATH=/home/user/FARMAI/backend/venv/bin"
ExecStart=/home/user/FARMAI/backend/venv/bin/python app.py
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
# Активація сервісу
sudo systemctl daemon-reload
sudo systemctl enable farmai
sudo systemctl start farmai
```

### Налаштування Nginx

```bash
sudo nano /etc/nginx/sites-available/farmai
```

**Вміст конфігурації:**
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
# Активація конфігурації
sudo ln -s /etc/nginx/sites-available/farmai /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### SSL (HTTPS) через Let's Encrypt

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d your-domain.com
```

## 🔧 API Endpoints

### Чат
- `GET /api/chat/history` - Історія чату
- `POST /api/chat` - Відправити повідомлення
- `POST /api/chat/clear` - Очистити історію

### Пам'ять ШІ
- `GET /api/memory` - Отримати всю пам'ять
- `POST /api/memory` - Додати запис
- `DELETE /api/memory/<id>` - Видалити запис

### Облік
- `GET /api/accounting` - Отримати дані Excel
- `POST /api/accounting` - Зберегти зміни
- `GET /api/accounting/sheets` - Список аркушів

### Користувачі
- `POST /api/users/login` - Авторизація
- `GET /api/users` - Список користувачів

## 🛠️ Розробка

### Додавання нових функцій

1. **Backend:** Додайте нові endpoints в `backend/app.py`
2. **Frontend:** Створіть компоненти в `frontend/src/components/`
3. **Стилі:** Редагуйте `frontend/src/App.css`

### Тестування

```powershell
# Backend (в розробці)
cd backend
python app.py

# Frontend (hot reload)
cd frontend
npm start
```

## 📝 Налаштування ШІ

Ви можете налаштувати поведінку ШІ редагуючи функцію `get_ai_context()` в `backend/app.py`:

```python
def get_ai_context():
    # Додайте кастомні інструкції для ШІ
    context = "Ти - експерт з фермерства. Твоя задача..."
    return context
```

## ⚠️ Важливо

- **Безпека:** Змініть паролі користувачів у production
- **Backup:** Регулярно робіть копії `тижневий облік.xlsx` та папки `backend/data/`
- **API Ключ:** Не додавайте `.env` файл в git
- **Оновлення:** Регулярно оновлюйте залежності

## 🐛 Вирішення проблем

### Backend не запускається
```powershell
# Перевірте чи встановлені всі залежності
pip install -r requirements.txt

# Перевірте чи є .env файл
ls backend/.env
```

### Frontend не збирається
```powershell
# Видаліть node_modules та перевстановіть
cd frontend
rm -rf node_modules package-lock.json
npm install
```

### ШІ не відповідає
- Перевірте чи додано `GEMINI_API_KEY` в `.env`
- Перевірте з'єднання з інтернетом
- Перевірте ліміти API на Google AI Studio

## 📞 Підтримка

При виникненні проблем:
1. Перевірте логи сервера
2. Перевірте консоль браузера (F12)
3. Перегляньте документацію Gemini API

## 🎯 Наступні кроки

1. ✅ Додайте ваш Gemini API ключ
2. ✅ Запустіть локально та протестуйте
3. ✅ Налаштуйте користувачів
4. ✅ Додайте дані в пам'ять ШІ
5. ✅ Протестуйте роботу з обліком
6. 🚀 Розгорніть на VPS

---

**Розроблено для оптимального управління фермою з використанням штучного інтелекту!** 🚜✨
