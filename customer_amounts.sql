CREATE VIEW customer_amounts AS SELECT
    `c`.`id` AS `customer_id`,
    (
    SELECT
        SUM(`s`.`grand_total`)
    FROM
        `hangu_silk_center`.`sales` `s`
    WHERE
        `s`.`customer_id` = `c`.`id`
    GROUP BY
        `s`.`customer_id`
) AS `total_amount`,
(
    SELECT
        SUM(`p`.`paid_amount`)
    FROM
        `hangu_silk_center`.`payments` `p`
    WHERE
        `p`.`customer_id` = `c`.`id`
    GROUP BY
        `p`.`customer_id`
) AS `paid_amount`,
(
    SELECT
        MAX(`p2`.`payment_date`)
    FROM
        `hangu_silk_center`.`payments` `p2`
    WHERE
        `p2`.`customer_id` = `c`.`id`
) AS `last_payment_date`,
(
    SELECT
        `p3`.`paid_amount`
    FROM
        `hangu_silk_center`.`payments` `p3`
    WHERE
        `p3`.`customer_id` = `c`.`id`
    ORDER BY
        `p3`.`id`
    DESC
LIMIT 1
) AS `last_paid_amount`
FROM
    `hangu_silk_center`.`customers` `c`