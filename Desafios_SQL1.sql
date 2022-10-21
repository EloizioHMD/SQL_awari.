/* 1. Selecione os dados da tabela de pagamentos onde só apareçam os tipos de pagamento “VOUCHER” e “BOLETO”.*/
SELECT *,
payment_type AS pagamentos
FROM olist_order_payments_dataset
WHERE pagamentos = 'voucher' or pagamentos = 'boleto';

/* 2. Retorne os campos da tabela de produtos e calcule o volume de cada produto em um novo campo.*/
SELECT 	product_id,
		product_length_cm * product_height_cm * product_width_cm AS product_volume_cm3
FROM olist_products_dataset
GROUP BY product_id;

/* 3. Retorne somente os reviews que não tem comentários.*/
SELECT *,
	review_comment_message
FROM olist_order_reviews_dataset
WHERE (review_comment_message = '' or review_comment_message is NULL);

/* 4. Retorne pedidos que foram feitos somente no ano de 2017.*/
SELECT *, order_approved_at
FROM olist_orders_dataset
WHERE order_approved_at >= '2017-01-01 00:00:00'
	AND order_approved_at < '2018-01-01 00:00:00'
ORDER BY order_approved_at ASC

/* 5. Encontre os clientes do estado de SP e que não morem na cidade de São Paulo.*/
SELECT 	customer_unique_id AS cliente,
		customer_state AS estado,
		customer_city AS cidade
FROM olist_customers_dataset
WHERE estado = 'SP'
	AND cidade != 'sao paulo'
GROUP BY cliente, cidade, estado
ORDER By cidade ASC