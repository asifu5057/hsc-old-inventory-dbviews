SELECT
	`l`.`english_name` AS `location_name`,
	(
		SELECT
			SUM(`s1`.`grand_total`)
		FROM
			`sales` `s1`
		WHERE
			`s1`.`location_id` = `l`.`id`
	) AS `total_amount`,
	
	(
    SELECT
        SUM(`p`.`paid_amount`)
    FROM
        `payments` `p`
    WHERE
        `p`.`customer_id` IN(SELECT id FROM customers cc where cc.location_id = l.id)
	) AS `paid_amount`,
	
	(
		
		(
			SELECT
			SUM(`s1`.`grand_total`)
			FROM
				`sales` `s1`
			WHERE
				`s1`.`location_id` = `l`.`id`
		)
		- 
		(
			SELECT
			SUM(`p`.`paid_amount`)
			FROM
				`payments` `p`
			WHERE
				`p`.`customer_id` IN(SELECT id FROM customers cc where cc.location_id = l.id)
		)
	) as due_amount
	
	
	
FROM sales s

INNER JOIN locations l ON s.location_id = l.id

Group by s.location_id