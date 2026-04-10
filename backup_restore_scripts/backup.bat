@echo off
echo ====================================
echo    Резервное копирование БД
echo ====================================

REM Установка переменных
set DB_NAME=product_management
set BACKUP_DIR=C:\backup\postgres
set DATE=%date:~-4,4%%date:~-10,2%%date:~-7,2%
set TIME=%time:~0,2%%time:~3,2%%time:~6,2%
set BACKUP_FILE=%BACKUP_DIR%\%DB_NAME%_%DATE%_%TIME%.backup

REM Создание папки для бэкапов если её нет
if not exist %BACKUP_DIR% mkdir %BACKUP_DIR%

REM Выполнение резервного копирования
echo Начинаю резервное копирование базы данных %DB_NAME%...
pg_dump -U postgres -h localhost -p 5432 -F c -b -v -f "%BACKUP_FILE%" %DB_NAME%

if %errorlevel% equ 0 (
    echo.
    echo ✅ Резервное копирование успешно завершено!
    echo 📁 Файл: %BACKUP_FILE%
    echo 📊 Размер: 
    dir "%BACKUP_FILE%" | find "."
) else (
    echo.
    echo ❌ Ошибка при резервном копировании!
)

pause