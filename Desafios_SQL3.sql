/* 1.Crie uma tabela analítica de todos os itens que foram vendidos, mostrando somente pedidos interestaduais.
Queremos saber quantos dias os fornecedores demoram para postar o produto, se o produto chegou ou não no prazo.*/

SELECT Items.*,
    Pedidos.order_delivered_customer_date,
    Pedidos.order_estimated_delivery_date,
    substr (ROUND (julianday (Pedidos.order_delivered_carrier_date) - julianday(Pedidos.order_purchase_timestamp),0),1,1) as DiasPostagem,
	IIF(Pedidos.order_delivered_customer_date <= Pedidos.order_estimated_delivery_date, 'Sim', 'Não') as EntregePrazo,
    Clientes.customer_state,
    Vendedores.seller_state
FROM olist_customers_dataset AS Clientes
inner join olist_orders_dataset AS Pedidos on Clientes.customer_id = Pedidos.customer_id
inner join olist_order_items_dataset AS Items on Pedidos.order_id = Items.order_id
inner join olist_sellers_dataset AS Vendedores on Vendedores.seller_id = Items.seller_id
WHERE Clientes.customer_state <> Vendedores.seller_state

/* 2.Retorne todos os pagamentos do cliente,
com suas datas de aprovação,
valor da compra e o
valor total que o cliente já gastou em todas as suas compras,
mostrando somente os clientes onde o valor da compra é diferente do valor total já gasto.*/

WITH TABELA AS (
SELECT  Clientes.customer_unique_id AS IdCliente,
        Pedidos.order_approved_at as DataAprovacao,
        Pagamentos.payment_value as ValorCompra,
        sum(Pagamentos.payment_value) over (partition by Clientes.customer_unique_id) TotalCompras
FROM olist_customers_dataset AS Clientes
INNER JOIN olist_orders_dataset AS Pedidos ON Clientes.customer_id = Pedidos.customer_id
INNER JOIN olist_order_payments_dataset AS Pagamentos ON Pagamentos.order_id = Pedidos.order_id
)
SELECT * FROM TABELA WHERE ValorCompra <> TotalCompras

/* 3.Retorne as categorias válidas, suas somas totais dos valores de vendas,
um ranqueamento de maior valor para menor valor junto com o somatório acumulado dos valores pela mesma regra do ranqueamento.*/

WITH TABELA AS (
        select  Produtos.product_category_name as Categoria,
                sum(Items.price) as SomaVendas,
                rank() over (order by  sum(Items.price) desc) as Ranking
        FROM olist_order_items_dataset as Items
        inner join olist_products_dataset as Produtos on Produtos.product_id = Items.product_id
        GROUP BY Categoria
        ORDER BY SomaVendas DESC
)
SELECT *,
        sum(SomaVendas) over (order by SomaVendas desc) SomaAcumulada
FROM TABELA;
