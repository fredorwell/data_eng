
DELIMITER //
CREATE TRIGGER validate_hit_visit BEFORE INSERT ON hit
FOR EACH ROW BEGIN
  IF NEW.visit_id IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'У записи отстутсвует идентификатор визита';
  END IF;
END//
DELIMITER ;



-- 

DELIMITER //
CREATE TRIGGER validate_order_visit BEFORE INSERT ON orders
FOR EACH ROW BEGIN
  IF NEW.visit_id IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'У заказа отстутсвует идентификатор визита';
  END IF;
END//
DELIMITER ;


show triggers;
--

-- Процедура выводит последний хит занесенный в базу

DROP PROCEDURE last_hit;
DELIMITER //
CREATE procedure last_hit ()
BEGIN
 	 SELECT * FROM course_proj_anal_sys.hit order by created_at desc limit 1 ;  
END//
 
DELIMITER ;

CALL last_hit()

-- процедура выводит произвольное количество последних заказов


DROP PROCEDURE last_order;
DELIMITER //
CREATE procedure last_order (in p1 int)
BEGIN
 	 SELECT DISTINCT 
	chanel_type.name as chanel,
	visit.source as source,
	orders.id as order_id,
	orders.created_at as order_date,
	sum(order_content.total) over (PARTITION by orders.id ) as avg_bill,
	sum(order_content.revenue) over (PARTITION by orders.id ) as reuvenue
FROM orders
LEFT JOIN order_content
        ON orders.id = order_content.order_id
LEFT JOIN visit
	ON orders.id = visit.id 
LEFT JOIN chanel_type
        ON visit.chanel_type_id = chanel_type.id
order by order_date desc limit p1;  
END//
 
DELIMITER ;

CALL last_order(5);

*/


