/* Crie os índices apropriados para as tabelas do nosso modelo de dados com o intuito de melhorar a performance. */

CREATE INDEX IF NOT EXISTS "customers" ON "olist_customers_dataset" (
	"customer_zip_code_prefix"
);
CREATE INDEX IF NOT EXISTS "geolocation" ON "olist_geolocation_dataset" (
	"geolocation_zip_code_prefix"
);
CREATE INDEX IF NOT EXISTS "order_itens" ON "olist_order_items_dataset" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "order_payments" ON "olist_order_payments_dataset" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "order_reviews" ON "olist_order_reviews_dataset" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "orders" ON "olist_orders_dataset" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "products" ON "olist_products_dataset" (
	"product_id"
);
CREATE INDEX IF NOT EXISTS "seller" ON "olist_sellers_dataset" (
	"seller_zip_code_prefix"
);