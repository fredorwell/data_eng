-- 1. —оставьте список пользователей users, которые осуществили хот€ бы один заказ orders в интернет магазине.

SELECT id, name, (SELECT COUNT(*) from orders where orders.user_id = users.id) as total_order from users where (SELECT COUNT(*) from orders where orders.user_id = users.id) > 0 ORDER BY id;

-- 2. ¬ыведите список товаров products и разделов catalogs, который соответствует товару.

SELECT (SELECT name from catalogs c2 where catalog_id = id) as category, name, desription, price FROM products;

-- 3.(по желанию) ѕусть имеетс€ таблица рейсов flights (id, from, to) и таблица городов cities (label, name). ѕол€ from, to и label содержат английские названи€ городов, поле name Ч русское. ¬ыведите список рейсов flights с русскими названи€ми городов.

SELECT id, flight_from, flight_to, (SELECT name from cities c2 where label = flight_from) as "¬ылет", (SELECT name from cities c2 where label = flight_to)  as "ѕрибытие" FROM flight f ;
