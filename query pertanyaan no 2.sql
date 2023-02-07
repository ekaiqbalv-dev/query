SELECT 
    product_type,
    total_quantity,
    CASE
        WHEN total_quantity < 1000 THEN 'Low sold'
        WHEN
            total_quantity >= 1000
                AND total_quantity < 2000
        THEN
            'Medium sold'
        ELSE 'High sold'
    END AS 'status_sold'
FROM
    (SELECT 
        product_type,
            SUM(total_quantity_by_product) AS total_quantity
    FROM
        (SELECT 
        product.id, product_type.name AS product_type
    FROM
        product
    INNER JOIN product_type ON product.product_type_id = product_type.id) AS A
    INNER JOIN (SELECT 
        product_id, SUM(quantity) AS total_quantity_by_product
    FROM
        sales_receipt
    WHERE
        DATE(transaction_datetime) BETWEEN '2019-04-06' AND '2019-04-14'
    GROUP BY product_id) AS B ON A.id = B.product_id
    GROUP BY product_type
    ORDER BY total_quantity DESC) AS C