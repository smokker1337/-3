-- Оптимизированные версии запросов

-- 1. Оптимизированный запрос с использованием индексов
EXPLAIN ANALYZE
SELECT 
    p.product_name,
    c.category_name,
    s.supplier_name,
    p.quantity,
    p.price,
    COALESCE(sp.supply_stats, 0) as supply_count
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
LEFT JOIN (
    SELECT product_id, COUNT(*) as supply_stats
    FROM supplies
    GROUP BY product_id
) sp ON p.product_id = sp.product_id
WHERE p.price > 1000
ORDER BY p.price DESC;

-- 2. Оптимизированный полнотекстовый поиск
EXPLAIN ANALYZE
SELECT product_name, description
FROM products
WHERE to_tsvector('russian', description) @@ to_tsquery('russian', 'тестовый');

-- 3. Использование представления для частых запросов
EXPLAIN ANALYZE
SELECT * FROM vw_product_details WHERE price > 1000 ORDER BY price DESC;

-- 4. Использование подготовленного оператора
PREPARE get_products_by_category(INTEGER) AS
SELECT * FROM products WHERE category_id = $1;

EXPLAIN ANALYZE
EXECUTE get_products_by_category(1);

-- 5. Включение кэширования запросов
SET enable_seqscan = off; -- Принудительное использование индексов

-- 6. Анализ размера таблиц
SELECT
    relname as table_name,
    pg_size_pretty(pg_total_relation_size(relid)) as total_size,
    pg_size_pretty(pg_relation_size(relid)) as data_size,
    pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) as index_size
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;