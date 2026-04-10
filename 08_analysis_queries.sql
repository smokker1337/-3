-- Анализ производительности - "тяжелые" запросы

-- Включение тайминга
\timing on

-- 1. Сложный запрос с множественными JOIN без индексов (для демонстрации)
EXPLAIN ANALYZE
SELECT 
    p.product_name,
    c.category_name,
    s.supplier_name,
    p.quantity,
    p.price,
    (SELECT COUNT(*) FROM supplies sp WHERE sp.product_id = p.product_id) as supply_count
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE p.price > 1000
ORDER BY p.price DESC;

-- 2. Поиск по тексту
EXPLAIN ANALYZE
SELECT product_name, description
FROM products
WHERE description LIKE '%тестового%';

-- 3. Агрегация с группировкой
EXPLAIN ANALYZE
SELECT 
    c.category_name,
    COUNT(p.product_id) as product_count,
    AVG(p.price) as avg_price,
    SUM(p.quantity) as total_stock
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY product_count DESC;

-- 4. Анализ статистики таблиц
SELECT 
    schemaname,
    tablename,
    n_live_tup as live_rows,
    n_dead_tup as dead_rows,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables
WHERE schemaname = 'public';