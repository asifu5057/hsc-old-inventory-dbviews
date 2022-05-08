SELECT
    `c`.`id` AS `customer_id`,
    (
    SELECT
        SUM(`s`.`grand_total`)
    FROM
        `inventory_live`.`sales` `s`
    WHERE
        `s`.`customer_id` = `c`.`id`
    GROUP BY
        `s`.`customer_id`
) AS `total_amount`,
(
    SELECT
        SUM(`p`.`paid_amount`)
    FROM
        `inventory_live`.`payments` `p`
    WHERE
        `p`.`customer_id` = `c`.`id`
    GROUP BY
        `p`.`customer_id`
) AS `paid_amount`,
(
    SELECT
        MAX(`p2`.`payment_date`)
    FROM
        `inventory_live`.`payments` `p2`
    WHERE
        `p2`.`customer_id` = `c`.`id`
) AS `last_payment_date`,
(
    SELECT
        `p3`.`paid_amount`
    FROM
        `inventory_live`.`payments` `p3`
    WHERE
        `p3`.`customer_id` = `c`.`id`
    ORDER BY
        `p3`.`id`
    DESC
LIMIT 1
) AS `last_paid_amount`
FROM
    `inventory_live`.`customers` `c`