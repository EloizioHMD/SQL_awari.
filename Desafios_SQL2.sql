/* 1.Retorne a quantidade de itens vendidos em cada categoria por estado em que o cliente se encontra,
mostrando somente categorias que tenham vendido uma quantidade de items acima de 1000.*/
SELECT * FROM (
	SELECT 
		Clientes.customer_state AS Estado,
		Produtos.product_category_name AS Categoria,
		COUNT(*) AS QTD_Items
	FROM
		olist_customers_dataset AS Clientes
		INNER JOIN olist_orders_dataset AS Pedidos ON Clientes.customer_id = Pedidos.customer_id
		INNER JOIN olist_order_items_dataset AS Items ON Pedidos.order_id = Items.order_id
		INNER JOIN olist_products_dataset AS Produtos ON Produtos.product_id = Items.product_id
	GROUP BY Estado, Categoria
	ORDER BY Estado, QTD_Items DESC
	)
AS TABELA WHERE QTD_Items > 1000;

/* 2.Mostre os 5 clientes (customer_id) que gastaram mais dinheiro em compras,
 qual foi o valor total de todas as compras deles,
 quantidade de compras,
 e valor médio gasto por compras.
 Ordene os mesmos por ordem decrescente pela média do valor de compra.*/
WITH top_clientes AS (
		SELECT
			Clientes.customer_unique_id AS IdCliente,
			SUM(Pagamentos.payment_value) AS TotalCompras,
			AVG(Pagamentos.payment_value) AS MediaCompras,
			COUNT(Pedidos.order_id) AS QTD_Compras
		FROM olist_customers_dataset AS Clientes
		INNER JOIN olist_orders_dataset AS Pedidos ON Clientes.customer_id = Pedidos.customer_id
		INNER JOIN olist_order_payments_dataset AS Pagamentos ON Pagamentos.order_id = Pedidos.order_id
		GROUP BY IdCliente
		ORDER BY MediaCompras DESC
		LIMIT 5
 ) SELECT * FROM top_clientes ORDER BY MediaCompras DESC;
 
/* 3.Mostre o valor vendido total de cada vendedor (seller_id) em cada uma das categorias de produtos,
 somente retornando os vendedores que nesse somatório e agrupamento venderam mais de $1000.
 Desejamos ver a categoria do produto e os vendedores.
 Para cada uma dessas categorias, mostre seus valores de venda de forma decrescente.*/
SELECT
	Vendedor.seller_id AS IdVendedor,
	Produtos.product_category_name AS Categoria,
	SUM(Items.price) AS Pagamentos
FROM olist_order_items_dataset AS Items
INNER JOIN olist_products_dataset AS Produtos ON Produtos.product_id = Items.product_id
INNER JOIN olist_sellers_dataset AS Vendedor ON Vendedor.seller_id = Items.seller_id
GROUP BY IdVendedor, Categoria
HAVING Pagamentos > 1000
ORDER BY Categoria, Pagamentos ASC;