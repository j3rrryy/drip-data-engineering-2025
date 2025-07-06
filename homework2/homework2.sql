-- Создаем
CREATE TYPE gender_enum AS ENUM ('male', 'female');
CREATE TYPE order_status_enum AS ENUM ('packing', 'in_delivery', 'received', 'cancelled');

CREATE TABLE users (
    id UUID PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    gender gender_enum NOT NULL,
    birth_date TIMESTAMP NOT NULL,
    phone_number VARCHAR(25) NOT NULL UNIQUE,
    delivery_address TEXT NOT NULL,
    avatar_url VARCHAR(255),
    registered TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE categories (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE products (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category_id UUID NOT NULL REFERENCES categories(id),
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    rating DECIMAL(2,1),
    image_url VARCHAR(255),
    stock INTEGER NOT NULL
);

CREATE TABLE orders (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status order_status_enum NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE order_items (
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id),
    quantity INTEGER NOT NULL,
    price_at_order DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE cart_items (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL,
    PRIMARY KEY (user_id, product_id)
);

CREATE TABLE favorite_items (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, product_id)
);

-- Наполняем
INSERT INTO users (id, email, password_hash, first_name, last_name, gender, birth_date, phone_number, delivery_address, avatar_url)
VALUES
  ('550e8400-e29b-41d4-a716-446655440000', 'john.doe@example.com', 'hashed_password_1', 'John', 'Doe', 'male', '1980-01-01 00:00:00', '1234567890', '123 Main St, City', 'https://example.com/john_avatar.jpg'),
  ('550e8400-e29b-41d4-a716-446655440001', 'jane.doe@example.com', 'hashed_password_2', 'Jane', 'Doe', 'female', '1990-02-02 00:00:00', '0987654321', '456 Elm St, City', 'https://example.com/jane_avatar.jpg'),
  ('550e8400-e29b-41d4-a716-446655440002', 'alice.smith@example.com', 'hashed_password_3', 'Alice', 'Smith', 'female', '1985-03-03 00:00:00', '1122334455', '789 Oak St, City', 'https://example.com/alice_avatar.jpg'),
  ('550e8400-e29b-41d4-a716-446655440003', 'bob.jones@example.com', 'hashed_password_4', 'Bob', 'Jones', 'male', '2000-04-04 00:00:00', '5544332211', '321 Pine St, City', 'https://example.com/bob_avatar.jpg');

INSERT INTO categories (id, name)
VALUES
  ('550e8400-e29b-41d4-a716-446655440010', 'Electronics'),
  ('550e8400-e29b-41d4-a716-446655440011', 'Clothing'),
  ('550e8400-e29b-41d4-a716-446655440012', 'Furniture'),
  ('550e8400-e29b-41d4-a716-446655440013', 'Food');

INSERT INTO products (id, name, category_id, description, price, rating, image_url, stock)
VALUES
  ('550e8400-e29b-41d4-a716-446655440100', 'Smartphone', '550e8400-e29b-41d4-a716-446655440010', 'Latest model', 699.99, 4.5, 'https://example.com/smartphone.jpg', 50),
  ('550e8400-e29b-41d4-a716-446655440101', 'Laptop', '550e8400-e29b-41d4-a716-446655440010', 'High performance laptop', 1299.99, 4.7, 'https://example.com/laptop.jpg', 30),
  ('550e8400-e29b-41d4-a716-446655440102', 'T-shirt', '550e8400-e29b-41d4-a716-446655440011', 'Cotton t-shirt', 19.99, 4.0, 'https://example.com/tshirt.jpg', 100),
  ('550e8400-e29b-41d4-a716-446655440103', 'Sofa', '550e8400-e29b-41d4-a716-446655440012', 'Leather sofa', 899.99, 4.2, 'https://example.com/sofa.jpg', 10);

INSERT INTO orders (id, user_id, status, total_price, created)
VALUES
  ('550e8400-e29b-41d4-a716-446655440200', '550e8400-e29b-41d4-a716-446655440000', 'received', 719.99, '2025-04-25 12:00:00'),
  ('550e8400-e29b-41d4-a716-446655440201', '550e8400-e29b-41d4-a716-446655440001', 'packing', 1319.99, '2025-04-25 12:30:00'),
  ('550e8400-e29b-41d4-a716-446655440202', '550e8400-e29b-41d4-a716-446655440002', 'in_delivery', 19.99, '2025-04-25 13:00:00'),
  ('550e8400-e29b-41d4-a716-446655440203', '550e8400-e29b-41d4-a716-446655440003', 'cancelled', 899.99, '2025-04-25 14:00:00');

INSERT INTO order_items (order_id, product_id, quantity, price_at_order)
VALUES
  ('550e8400-e29b-41d4-a716-446655440200', '550e8400-e29b-41d4-a716-446655440100', 1, 699.99),
  ('550e8400-e29b-41d4-a716-446655440201', '550e8400-e29b-41d4-a716-446655440101', 1, 1299.99),
  ('550e8400-e29b-41d4-a716-446655440202', '550e8400-e29b-41d4-a716-446655440102', 1, 19.99),
  ('550e8400-e29b-41d4-a716-446655440203', '550e8400-e29b-41d4-a716-446655440103', 1, 899.99);

INSERT INTO cart_items (user_id, product_id, quantity)
VALUES
  ('550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440101', 2),
  ('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440102', 5),
  ('550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440103', 1),
  ('550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440100', 1);

INSERT INTO favorite_items (user_id, product_id)
VALUES
  ('550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440100'),
  ('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440102'),
  ('550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440103'),
  ('550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440101');

-- Запросы
SELECT u.first_name, u.last_name, COUNT(f.product_id) favorites_count
FROM users u
JOIN favorite_items f ON u.id = f.user_id
GROUP BY u.id;

SELECT p.name, p.price
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE c.name = 'Electronics' AND p.price < 700;

SELECT
    p.name product_name,
    c.quantity,
    p.price,
    ROUND(c.quantity * p.price, 2) total_price
FROM cart_items c
JOIN users u ON c.user_id = u.id
JOIN products p ON c.product_id = p.id
WHERE u.id = '550e8400-e29b-41d4-a716-446655440000';

SELECT
    c.name category,
    ROUND(AVG(p.price), 2) avg_price,
    ROUND(AVG(p.rating), 2) avg_rating
FROM categories c
JOIN products p ON c.id = p.category_id
GROUP BY c.name;

SELECT
    c.name category_name,
    COUNT(p.id) product_count
FROM categories c
LEFT JOIN products p ON p.category_id = c.id
GROUP BY c.name;
