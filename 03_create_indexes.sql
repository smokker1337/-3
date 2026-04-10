-- Индексы для таблицы products
CREATE INDEX idx_products_name ON products(product_name);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_supplier ON products(supplier_id);
CREATE INDEX idx_products_price ON products(price);

-- Индексы для таблицы supplies
CREATE INDEX idx_supplies_date ON supplies(supply_date);
CREATE INDEX idx_supplies_product ON supplies(product_id);
CREATE INDEX idx_supplies_supplier ON supplies(supplier_id);

-- Полнотекстовый поиск для products
CREATE INDEX idx_products_description ON products USING GIN(to_tsvector('russian', description));