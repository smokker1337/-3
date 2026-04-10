@echo off
echo ====================================
echo    Восстановление БД из резервной копии
echo ====================================

REM Установка переменных
set DB_NAME=product_management
set BACKUP_DIR=C:\backup\postgres

REM Показ доступных бэкапов
echo Доступные резервные копии:
echo.
dir /b %BACKUP_DIR%\*.backup 2>nul
echo.

if %errorlevel% neq 0 (
    echo ❌ Резервные копии не найдены!
    pause
    exit /b
)

REM Запрос имени файла для восстановления
set /p BACKUP_FILE="Введите имя файла для восстановления: "

REM Проверка существования файла
if not exist "%BACKUP_DIR%\%BACKUP_FILE%" (
    echo ❌ Файл не найден!
    pause
    exit /b
)

REM Подтверждение
echo.
echo ⚠️ ВНИМАНИЕ: Все текущие данные в базе %DB_NAME% будут потеряны!
set /p CONFIRM="Продолжить? (y/n): "

if /i "%CONFIRM%" neq "y" (
    echo Операция отменена.
    pause
    exit /b
)

REM Завершение соединений с БД
echo Завершение всех соединений с БД...
psql -U postgres -h localhost -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '%DB_NAME%';"

REM Удаление и создание БД заново
echo Пересоздание базы данных...
dropdb -U postgres -h localhost %DB_NAME%
createdb -U postgres -h localhost %DB_NAME%

REM Восстановление из бэкапа
echo Восстановление данных из резервной копии...
pg_restore -U postgres -h localhost -d %DB_NAME% -v "%BACKUP_DIR%\%BACKUP_FILE%"

if %errorlevel% equ 0 (
    echo.
    echo ✅ Восстановление успешно завершено!
) else (
    echo.
    echo ❌ Ошибка при восстановлении!
)

pause