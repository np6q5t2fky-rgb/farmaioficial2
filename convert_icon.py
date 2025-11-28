from PIL import Image
import os

try:
    print("Конвертую оригінальну іконку з Viber...")
    
    # Відкриваю оригінальну іконку
    img = Image.open('d:/FARMAI/mobile/assets/pig-original.jpg')
    print(f"Оригінал: {img.size}, формат: {img.format}, режим: {img.mode}")
    
    # Конвертую в RGBA для PNG
    if img.mode != 'RGBA':
        img = img.convert('RGBA')
    
    # Змінюю розмір до 1024x1024 (стандарт Expo)
    img_resized = img.resize((1024, 1024), Image.Resampling.LANCZOS)
    
    # Зберігаю як icon.png
    icon_path = 'd:/FARMAI/mobile/assets/icon.png'
    img_resized.save(icon_path, 'PNG', optimize=True)
    print(f"✓ icon.png збережено: {icon_path}")
    
    # Зберігаю як adaptive-icon.png
    adaptive_path = 'd:/FARMAI/mobile/assets/adaptive-icon.png'
    img_resized.save(adaptive_path, 'PNG', optimize=True)
    print(f"✓ adaptive-icon.png збережено: {adaptive_path}")
    
    # Створюю splash screen 1284x2778 (iPhone розмір)
    splash_img = Image.new('RGB', (1284, 2778), color='#87CEEB')  # блакитний фон як на іконці
    
    # Вставляю іконку по центру (трохи зменшену)
    icon_size = 400
    icon_for_splash = img.resize((icon_size, icon_size), Image.Resampling.LANCZOS)
    
    # Конвертую в RGB якщо потрібно
    if icon_for_splash.mode == 'RGBA':
        # Створюю білий фон для іконки
        background = Image.new('RGB', (icon_size, icon_size), '#87CEEB')
        background.paste(icon_for_splash, (0, 0), icon_for_splash)
        icon_for_splash = background
    
    x = (1284 - icon_size) // 2
    y = (2778 - icon_size) // 2
    splash_img.paste(icon_for_splash, (x, y))
    
    splash_path = 'd:/FARMAI/mobile/assets/splash-icon.png'
    splash_img.save(splash_path, 'PNG', optimize=True)
    print(f"✓ splash-icon.png збережено: {splash_path}")
    
    print(f"  Розмір: 1024x1024, формат: PNG")
    
except Exception as e:
    print(f"Помилка: {e}")
    import traceback
    traceback.print_exc()
