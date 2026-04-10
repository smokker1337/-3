-- Представление для отображения товаров с категориями и поставщиками
CREATE VIEW vw_product_details AS
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    s.supplier_name,
    p.quantity as stock_quantity,
    p.price,
    p.description,
    p.created_at
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id;

-- Представление для статистики по категориям
CREATE VIEW vw_category_stats AS
SELECT 
    c.category_id,
    c.category_name,
    COUNT(p.product_id) as products_count,
    COALESCE(SUM(p.quantity), 0) as total_stock,
    COALESCE(AVG(p.price), 0) as avg_price,
    COALESCE(SUM(p.quantity * p.price), 0) as total_value
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name;

-- Представление для истории поставок
CREATE VIEW vw_supply_history AS
SELECT 
    s.supply_id,
    p.product_name,
    sup.supplier_name,
    s.quantity,
    s.purchase_price,
    s.quantity * s.purchase_price as total_cost,
    s.supply_date
FROM supplies s
JOIN products p ON s.product_id = p.product_id
JOIN suppliers sup ON s.supplier_id = sup.supplier_id
ORDER BY s.supply_date DESC;