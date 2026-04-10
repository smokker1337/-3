Администрирование и оптимизация БД учета товаров

Запускаем в pgAdmin:
1. 01_create_database.sql    - для создание БД
2. 02_create_tables.sql       - для создание таблиц
3. 03_create_indexes.sql      - для создание индексов
4. 04_create_views.sql        - для создание представлений
5. 05_create_procedures_triggers.sql – для процедур и триггеров
6. 06_insert_test_data.sql    - для заполнение тестовыми данными
7. 07_create_roles_permissions.sql - Роли и права

Тестирование:
- Запустите 08_analysis_queries.sql для анализа производительности
- Запустите 09_optimized_queries.sql для сравнения с оптимизированными запросами

Резервное копирование:
- Запустите backup_restore_scripts\backup.bat

Восстановление:
- Запустите backup_restore_scripts\restore.bat


