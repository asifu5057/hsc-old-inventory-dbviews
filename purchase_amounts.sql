/* View seller amounts */
CREATE VIEW purchase_amounts AS SELECT
    `s`.`id` AS `seller_id`,
    (
    SELECT
        SUM(`p`.`grand_total`)
    FROM
        `purchases` `p`
    WHERE
        `p`.`seller_id` = `s`.`id`
) AS `total_amount`,
(
    SELECT
        SUM(`pp`.`paid_amount`)
    FROM
        `purchase_payments` `pp`
    WHERE
        `pp`.`seller_id` = `s`.`id`
    GROUP BY
        `pp`.`seller_id`
) AS `paid_amount`,
(
    SELECT
        MAX(`pp2`.`payment_date`)
    FROM
        `purchase_payments` `pp2`
    WHERE
        `pp2`.`seller_id` = `s`.`id`
) AS `last_payment_date`,
(
    SELECT
        `pp3`.`paid_amount`
    FROM
        `purchase_payments` `pp3`
    WHERE
        `pp3`.`seller_id` = `s`.`id` AND `pp3`.`paid_amount` > 0
    ORDER BY
        `pp3`.`id`
    DESC
LIMIT 1
) AS `last_paid_amount`
FROM
    `purchases` `pr`
INNER JOIN sellers s ON
    pr.seller_id = s.id
GROUP BY
    `pr`.`seller_id`, `s`.`id`