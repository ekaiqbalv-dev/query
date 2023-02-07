SELECT 
    customer_id, customer_name, customer_email, transaction_date
FROM
    (SELECT 
        sales_receipt.customer_id,
            customer.name AS customer_name,
            customer.email AS customer_email,
            DATE(sales_receipt.transaction_datetime) AS transaction_date,
            SUM(line_item_amount) AS total_line_item_amount
    FROM
        sales_receipt
    INNER JOIN customer ON sales_receipt.customer_id = customer.id
    GROUP BY customer_id , transaction_date) AS A
WHERE
    A.total_line_item_amount = (SELECT 
            SUM(line_item_amount)
        FROM
            sales_receipt
        WHERE
            customer_id = (SELECT 
                    id
                FROM
                    customer
                WHERE
                    email = 'Charissa@Integer.us')
                AND DATE(transaction_datetime) = '2019-04-20')
ORDER BY transaction_date DESC