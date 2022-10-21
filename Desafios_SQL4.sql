/*Crie uma view (SELLER_STATS) para mostrar por fornecedor,
a quantidade de itens enviados, o tempo médio de postagem após a aprovação da compra, a quantidade total de pedidos de cada Fornecedor,
note que trabalharemos na mesma query com 2 granularidades diferentes.*/

SELECT Vendedores.seller_id as IdVendedor,
	count(*) as QtdItems,
	avg(substr (ROUND (julianday (Pedidos.order_delivered_carrier_date) - julianday(Pedidos.order_purchase_timestamp),0),1,1)) as DiasPostagem,
	count(distinct Pedidos.order_id) as QtdPedidos
FROM olist_customers_dataset as Clientes
INNER JOIN olist_orders_dataset as Pedidos on Clientes.customer_id = Pedidos.customer_id
INNER JOIN olist_order_items_dataset as Items on Pedidos.order_id = Items.order_id
INNER JOIN olist_sellers_dataset as Vendedores on Vendedores.seller_id = Items.seller_id
GROUP BY IdVendedor;

/*Queremos dar um cupom de 10% do valor da última compra do cliente.
Porém os clientes elegíveis a este cupom devem ter feito uma compra anterior a última (a partir da data de aprovação do pedido) que tenha sido maior ou igual o valor da última compra.
Crie uma querie que retorne os valores dos cupons para cada um dos clientes elegíveis.*/

SELECT * FROM (
  SELECT *,
    LAG(ValorPagamento) OVER (PARTITION BY IdCliente ORDER BY DataAprovacao) ValorPedidoAnterior,
    ValorPagamento*0.1 AS ValorCupom
  FROM (
    SELECT Clientes.customer_unique_id AS IdCliente,
      Pedidos.order_id AS IdPedido,
      MAX(order_approved_at) AS DataAprovacao,
      SUM(Pagamentos.payment_value) AS ValorPagamento
    FROM  olist_customers_dataset AS Clientes
    INNER JOIN olist_orders_dataset AS Pedidos ON Clientes.customer_id = Pedidos.customer_id
    INNER JOIN olist_order_payments_dataset AS Pagamentos ON Pagamentos.order_id = Pedidos.order_id
    GROUP BY IdCliente, IdPedido
    ORDER BY IdCliente
    )
)
WHERE ValorPedidoAnterior >= ValorPagamento;