-- Фильтрация товаров по категории и цене
-- WHERE category_id = ? AND price <= ?
CREATE INDEX idx_products_category_price ON products(category_id, price);

-- Фильтрация товаров по категории и сортировка по рейтингу
-- WHERE category_id = ? ORDER BY rating DESC
CREATE INDEX idx_products_category_rating ON products(category_id, rating DESC);

-- Полнотекстовый поиск товаров по name + description
-- to_tsvector(...) @@ plainto_tsquery(...)
CREATE INDEX idx_products_fts_name_description ON products USING GIN(to_tsvector('english', name || ' ' || description));

-- Поиск пользователя по email при входе в систему
-- WHERE email = ?
CREATE INDEX idx_users_email_hash ON users USING HASH(LOWER(email));

-- История заказов пользователя с сортировкой по дате
-- WHERE user_id = ? ORDER BY created DESC
CREATE INDEX idx_orders_user_created ON orders(user_id, created DESC);

-- Товары одного заказа
-- WHERE order_id = ?
CREATE INDEX idx_order_items_order ON order_items(order_id);

-- Просмотр корзины пользователя
-- WHERE user_id = ?
CREATE INDEX idx_cart_items_user ON cart_items(user_id);

-- Просмотр избранного пользователя
-- WHERE user_id = ?
CREATE INDEX idx_favorite_items_user ON favorite_items(user_id);
