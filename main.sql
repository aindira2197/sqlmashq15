SELECT 
    JSON_OBJECT(
        'customer_id', c.cust_id,
        'name', c.cust_name,
        'contact', c.email,
        'order_history', (
            SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'order_id', o.order_id,
                    'date', o.order_date,
                    'amount', o.total_amount,
                    'items', (
                        SELECT JSON_ARRAYAGG(
                            JSON_OBJECT(
                                'product', p.prod_name,
                                'qty', od.quantity,
                                'price', od.unit_price
                            )
                        )
                        FROM OrderDetails od
                        JOIN Products p ON od.prod_id = p.prod_id
                        WHERE od.order_id = o.order_id
                    )
                )
            )
            FROM Orders o
            WHERE o.cust_id = c.cust_id
        )
    ) AS Customer_Full_Profile_JSON
FROM Customers c
WHERE c.cust_id IN (SELECT DISTINCT cust_id FROM Orders);
