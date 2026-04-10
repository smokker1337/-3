-- Создание ролей
CREATE ROLE manager WITH LOGIN PASSWORD 'manager123';
CREATE ROLE viewer WITH LOGIN PASSWORD 'viewer123';

-- Права для manager (менеджер)
GRANT CONNECT ON DATABASE product_management TO manager;
GRANT USAGE ON SCHEMA public TO manager;

-- Полные права на все таблицы
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO manager;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO manager;

-- Права на выполнение процедур и функций
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO manager;
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA public TO manager;

-- Права для viewer (наблюдатель)
GRANT CONNECT ON DATABASE product_management TO viewer;
GRANT USAGE ON SCHEMA public TO viewer;

-- Только чтение
GRANT SELECT ON ALL TABLES IN SCHEMA public TO viewer;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO viewer;

-- Ограничение доступа к определенным таблицам
REVOKE SELECT ON supplies FROM viewer;
GRANT SELECT ON vw_product_details TO viewer;
GRANT SELECT ON vw_category_stats TO viewer;

-- Настройка прав по умолчанию для новых таблиц
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO manager;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO viewer;