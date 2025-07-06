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

CREATE INDEX idx_users_email_hash ON users USING HASH(LOWER(email));
CREATE INDEX idx_orders_user_created ON orders(user_id, created DESC);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_cart_items_user ON cart_items(user_id);
CREATE INDEX idx_favorite_items_user ON favorite_items(user_id);

CREATE INDEX idx_products_category_price ON products(category_id, price);
CREATE INDEX idx_products_category_rating ON products(category_id, rating DESC);
CREATE INDEX idx_products_fts_name_description ON products USING GIN(to_tsvector('english', name || ' ' || description));
