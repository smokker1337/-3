-- Создание базы данных
CREATE DATABASE product_management
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;

-- Подключение к созданной БД
\c product_management;