-- Создаем партиционированную таблицу
CREATE TABLE orders (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status order_status_enum NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (created);

-- Для начала создаем партицию вручную
CREATE TABLE orders_2025_05 PARTITION OF orders
FOR VALUES FROM ('2025-05-01') TO ('2025-06-01');

-- Создаем функцию‑триггер
CREATE FUNCTION create_orders_partitions()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  start_month DATE;
BEGIN
  FOR start_month IN
      SELECT DISTINCT date_trunc('month', created)::date FROM new_rows
  LOOP
    EXECUTE format(
      'CREATE TABLE IF NOT EXISTS %I PARTITION OF orders FOR VALUES FROM (%L) TO (%L)',
      'orders_' || to_char(start_month, 'YYYY_MM'),
      start_month::text,
      (start_month + INTERVAL '1 month')::text
    );
  END LOOP;

  RETURN NULL;
END;
$$;

-- Создаем триггер
CREATE TRIGGER trg_orders_partition_creation
BEFORE INSERT ON orders
REFERENCING NEW TABLE AS new_rows
FOR EACH STATEMENT
EXECUTE FUNCTION create_orders_partitions();
