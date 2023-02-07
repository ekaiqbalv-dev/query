SELECT 
    A.product_id,
    product_detail.name,
    A.total_quantity_by_product,
    A.transaction_date
FROM
    (SELECT 
        product_id,
            SUM(quantity) AS total_quantity_by_product,
            DATE(transaction_datetime) AS transaction_date
    FROM
        sales_receipt
    WHERE
        DATE(transaction_datetime) BETWEEN '2019-04-11' AND '2019-04-13'
    GROUP BY product_id , transaction_date) AS A
        INNER JOIN
    (SELECT 
        transaction_date,
            MAX(total_quantity_by_product) AS max_product_quantity_by_date
    FROM
        (SELECT 
        product_id,
            SUM(quantity) AS total_quantity_by_product,
            DATE(transaction_datetime) AS transaction_date
    FROM
        sales_receipt
    WHERE
        DATE(transaction_datetime) BETWEEN '2019-04-11' AND '2019-04-13'
    GROUP BY product_id , transaction_date) AS B
    GROUP BY transaction_date) AS C ON A.transaction_date = C.transaction_date
        AND A.total_quantity_by_product = C.max_product_quantity_by_date
        INNER JOIN
    product ON A.product_id = product.id
        INNER JOIN
    product_detail ON product.product_detail_id = product_detail.id