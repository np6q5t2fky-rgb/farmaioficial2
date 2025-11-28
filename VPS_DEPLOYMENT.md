# 🌐 Розгортання на VPS - Детальна Інструкція

## Передумови

- VPS з Ubuntu 20.04/22.04 або Debian 11/12
- Root або sudo доступ
- Домен (опціонально, але рекомендовано)

## 📦 Крок 1: Підготовка VPS

```bash
# Підключення до VPS
ssh root@your-vps-ip

# Оновлення системи
apt update && apt upgrade -y

# Встановлення необхідних пакетів
apt install -y python3 python3-pip python3-venv nodejs npm nginx git

# Або встановлення останньої версії Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Створення користувача (якщо працюєте від root)
adduser farmai
usermod -aG sudo farmai
su - farmai
```

## 📁 Крок 2: Завантаження Проекту

### Варіант А: Через Git (рекомендовано)
```bash
cd /home/farmai
git clone https://your-repo.git FARMAI
cd FARMAI
```

### Варіант Б: Через SCP (з Windows)
```powershell
# На вашому локальному комп'ютері
scp -r d:\FARMAI farmai@your-vps-ip:/home/farmai/
```

## 🐍 Крок 3: Налаштування Backend

```bash
cd /home/farmai/FARMAI/backend

# Створення віртуального середовища
python3 -m venv venv
source venv/bin/activate

# Встановлення залежностей
pip install -r requirements.txt

# Створення .env файлу
cp .env.example .env
nano .env
```

Додайте в `.env`:
```
GEMINI_API_KEY=ваш_ключ_тут
```

## ⚛️ Крок 4: Збірка Frontend

```bash
cd /home/farmai/FARMAI/frontend

# Встановлення залежностей
npm install

# Production збірка
npm run build

# Копіювання в backend
cp -r build ../backend/frontend_build
```

## 🔧 Крок 5: Налаштування Systemd

```bash
sudo nano /etc/systemd/system/farmai.service
```

Вміст файлу:
```ini
[Unit]
Description=FarmAI Backend Service
After=network.target

[Service]
Type=simple
User=farmai
WorkingDirectory=/home/farmai/FARMAI/backend
Environment="PATH=/home/farmai/FARMAI/backend/venv/bin"
ExecStart=/home/farmai/FARMAI/backend/venv/bin/python app.py
Restart=always
RestartSec=10

# Логування
StandardOutput=journal
StandardError=journal
SyslogIdentifier=farmai

[Install]
WantedBy=multi-user.target
```

Активація:
```bash
sudo systemctl daemon-reload
sudo systemctl enable farmai
sudo systemctl start farmai
sudo systemctl status farmai
```

## 🌐 Крок 6: Налаштування Nginx

```bash
sudo nano /etc/nginx/sites-available/farmai
```

### Варіант A: Без домену (тільки IP)
```nginx
server {
    listen 80;
    server_name your-vps-ip;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### Варіант B: З доменом
```nginx
server {
    listen 80;
    server_name farm.yourdomain.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Активація:
```bash
sudo ln -s /etc/nginx/sites-available/farmai /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## 🔒 Крок 7: SSL Сертифікат (HTTPS)

### Якщо є домен:
```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d farm.yourdomain.com
```

Certbot автоматично налаштує HTTPS та перенаправлення.

### Автоматичне оновлення:
```bash
sudo certbot renew --dry-run
```

## 🔥 Крок 8: Налаштування Firewall

```bash
# UFW (Ubuntu Firewall)
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw enable
sudo ufw status
```

## 📊 Корисні Команди

### Перегляд логів
```bash
# Логи сервісу
sudo journalctl -u farmai -f

# Логи Nginx
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### Управління сервісом
```bash
sudo systemctl start farmai    # Запуск
sudo systemctl stop farmai     # Зупинка
sudo systemctl restart farmai  # Перезапуск
sudo systemctl status farmai   # Статус
```

### Оновлення проекту
```bash
cd /home/farmai/FARMAI

# Якщо через Git
git pull

# Оновлення backend
cd backend
source venv/bin/activate
pip install -r requirements.txt

# Оновлення frontend
cd ../frontend
npm install
npm run build
cp -r build ../backend/frontend_build

# Перезапуск
sudo systemctl restart farmai
```

## 🔐 Безпека

### 1. Змініть паролі користувачів
```bash
nano /home/farmai/FARMAI/backend/data/users.json
```

### 2. Обмежте доступ до файлів
```bash
chmod 600 /home/farmai/FARMAI/backend/.env
chmod 700 /home/farmai/FARMAI/backend/data
```

### 3. Налаштуйте SSH ключі замість паролів
```bash
# На локальному комп'ютері
ssh-keygen -t rsa -b 4096
ssh-copy-id farmai@your-vps-ip

# На VPS вимкніть парольну аутентифікацію
sudo nano /etc/ssh/sshd_config
# PasswordAuthentication no
sudo systemctl restart sshd
```

### 4. Встановіть Fail2Ban
```bash
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

## 💾 Backup

### Створення скрипту backup
```bash
nano /home/farmai/backup.sh
```

```bash
#!/bin/bash
BACKUP_DIR="/home/farmai/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup Excel та даних
cd /home/farmai/FARMAI
tar -czf "$BACKUP_DIR/farmai_$DATE.tar.gz" \
    "тижневий облік.xlsx" \
    backend/data/

# Видалення старих backup (старіші за 7 днів)
find $BACKUP_DIR -name "farmai_*.tar.gz" -mtime +7 -delete

echo "Backup completed: $BACKUP_DIR/farmai_$DATE.tar.gz"
```

```bash
chmod +x /home/farmai/backup.sh

# Автоматичний backup щодня о 3:00 ночі
crontab -e
# Додайте: 0 3 * * * /home/farmai/backup.sh
```

## 📈 Моніторинг

### Перевірка використання ресурсів
```bash
# CPU та Memory
htop

# Дисковий простір
df -h

# Трафік
iftop
```

### Встановлення моніторингу (опціонально)
```bash
# Netdata - веб-інтерфейс моніторингу
bash <(curl -Ss https://my-netdata.io/kickstart.sh)
# Доступ: http://your-vps-ip:19999
```

## 🔧 Налаштування для 5+ користувачів

### Збільшення лімітів Flask
В `backend/app.py` додайте:
```python
if __name__ == '__main__':
    app.run(
        debug=False,
        host='0.0.0.0',
        port=5000,
        threaded=True  # Для багатопоточності
    )
```

### Або використайте Gunicorn
```bash
pip install gunicorn

# В systemd service замініть ExecStart на:
ExecStart=/home/farmai/FARMAI/backend/venv/bin/gunicorn -w 4 -b 127.0.0.1:5000 app:app
```

## ⚠️ Troubleshooting

### Сервіс не запускається
```bash
sudo journalctl -u farmai -n 50
```

### Nginx показує 502 Bad Gateway
```bash
# Перевірте чи працює backend
sudo systemctl status farmai
curl http://localhost:5000/api/health
```

### Excel файл не відкривається
```bash
# Перевірте права доступу
ls -la /home/farmai/FARMAI/"тижневий облік.xlsx"
chmod 644 /home/farmai/FARMAI/"тижневий облік.xlsx"
```

### Висока навантаженість
```bash
# Збільште кількість worker'ів Gunicorn
# або налаштуйте Redis для кешування
```

## 🎯 Чек-лист після розгортання

- [ ] Backend запущений і доступний
- [ ] Frontend відображається
- [ ] Gemini API працює
- [ ] Excel файл читається
- [ ] Всі користувачі можуть увійти
- [ ] SSL сертифікат встановлено (якщо є домен)
- [ ] Firewall налаштовано
- [ ] Backup скрипт працює
- [ ] Логування налаштовано
- [ ] Паролі змінені

## 📞 Підтримка

При проблемах:
1. Перевірте логи: `sudo journalctl -u farmai -f`
2. Перевірте статус: `sudo systemctl status farmai`
3. Перезапустіть: `sudo systemctl restart farmai`

---

**Успішного розгортання! 🚀**
