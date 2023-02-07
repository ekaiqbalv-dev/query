SELECT 
    product_type,
    IFNULL(SUM(total_quantity_by_product), 0) AS total_quantity
FROM
    (SELECT 
        product.id, product_type.name AS product_type
    FROM
        product
    INNER JOIN product_type ON product.product_type_id = product_type.id) AS A
        LEFT JOIN
    (SELECT 
        product_id, SUM(quantity) AS total_quantity_by_product
    FROM
        sales_receipt
    WHERE
        DATE(transaction_datetime) = '2019-04-02'
    GROUP BY product_id) AS B ON A.id = B.product_id
GROUP BY product_type
ORDER BY total_quantity DESC