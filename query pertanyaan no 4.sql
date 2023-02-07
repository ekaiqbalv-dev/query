SELECT 
    id, name, email, D.transaction_date
FROM
    customer
        INNER JOIN
    (SELECT 
        A.customer_id,
            A.transaction_date,
            A.total_quantity_by_customer_id_and_transaction_date
    FROM
        (SELECT 
        customer_id,
            DATE(transaction_datetime) AS transaction_date,
            SUM(quantity) AS total_quantity_by_customer_id_and_transaction_date
    FROM
        sales_receipt
    WHERE
        DATE(transaction_datetime) BETWEEN '2019-04-12' AND '2019-04-20'
            AND customer_id != 0
    GROUP BY customer_id , transaction_date
    ORDER BY transaction_date DESC) AS A
    INNER JOIN (SELECT 
        transaction_date,
            MAX(total_quantity_by_customer_id_and_transaction_date) AS max_total_quantity_by_customer_id_and_transaction_date
    FROM
        (SELECT 
        customer_id,
            DATE(transaction_datetime) AS transaction_date,
            SUM(quantity) AS total_quantity_by_customer_id_and_transaction_date
    FROM
        sales_receipt
    WHERE
        DATE(transaction_datetime) BETWEEN '2019-04-12' AND '2019-04-20'
            AND customer_id != 0
    GROUP BY customer_id , transaction_date
    ORDER BY transaction_date DESC) AS B
    GROUP BY transaction_date) AS C ON A.transaction_date = C.transaction_date
        AND A.total_quantity_by_customer_id_and_transaction_date = C.max_total_quantity_by_customer_id_and_transaction_date) AS D ON customer.id = D.customer_id