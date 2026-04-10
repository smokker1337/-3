-- Функция для обновления поля updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Триггер для автоматического обновления updated_at в products
CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Процедура для добавления товара с проверкой
CREATE OR REPLACE PROCEDURE add_product(
    p_name VARCHAR(200),
    p_category_id INTEGER,
    p_supplier_id INTEGER,
    p_quantity INTEGER,
    p_price DECIMAL(10, 2),
    p_description TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Проверка существования категории
    IF NOT EXISTS (SELECT 1 FROM categories WHERE category_id = p_category_id) THEN
        RAISE EXCEPTION 'Категория с ID % не существует', p_category_id;
    END IF;
    
    -- Проверка существования поставщика
    IF NOT EXISTS (SELECT 1 FROM suppliers WHERE supplier_id = p_supplier_id) THEN
        RAISE EXCEPTION 'Поставщик с ID % не существует', p_supplier_id;
    END IF;
    
    -- Вставка товара
    INSERT INTO products (product_name, category_id, supplier_id, quantity, price, description)
    VALUES (p_name, p_category_id, p_supplier_id, p_quantity, p_price, p_description);
    
    RAISE NOTICE 'Товар "%" успешно добавлен', p_name;
END;
$$;

-- Процедура для регистрации поставки
CREATE OR REPLACE PROCEDURE register_supply(
    p_product_id INTEGER,
    p_supplier_id INTEGER,
    p_quantity INTEGER,
    p_purchase_price DECIMAL(10, 2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_product_name VARCHAR(200);
BEGIN
    -- Проверка существования товара
    SELECT product_name INTO v_product_name 
    FROM products 
    WHERE product_id = p_product_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Товар с ID % не существует', p_product_id;
    END IF;
    
    -- Добавление записи о поставке
    INSERT INTO supplies (product_id, supplier_id, quantity, purchase_price)
    VALUES (p_product_id, p_supplier_id, p_quantity, p_purchase_price);
    
    -- Обновление количества товара
    UPDATE products 
    SET quantity = quantity + p_quantity
    WHERE product_id = p_product_id;
    
    RAISE NOTICE 'Поставка товара "%" зарегистрирована, добавлено % шт.', 
        v_product_name, p_quantity;
END;
$$;

-- Функция для получения товаров с низким запасом
CREATE OR REPLACE FUNCTION get_low_stock_products(threshold INTEGER DEFAULT 10)
RETURNS TABLE (
    product_name VARCHAR(200),
    category_name VARCHAR(100),
    current_quantity INTEGER,
    supplier_name VARCHAR(200)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.product_name,
        c.category_name,
        p.quantity,
        s.supplier_name
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    JOIN suppliers s ON p.supplier_id = s.supplier_id
    WHERE p.quantity < threshold
    ORDER BY p.quantity;
END;
$$ LANGUAGE plpgsql;