--

SELECT 
	order_content.name, 
	sum(revenue) as revenue, 
	sum(total) as total_product,
	TRUNCATE(sum(revenue) * 0.55, 2) as profit
FROM order_content
group by order_content.name 
ORDER BY total_product DESC ;

-- Отчет по визитам из разных источников и каналов

SELECT DISTINCT 
	chanel_type.name as chanel,
	visit.source as source,
	COUNT(visit.id) over (PARTITION by visit.source) as visit
FROM visit
LEFT JOIN chanel_type
	ON visit.chanel_type_id = chanel_type.id
ORDER by visit desc;

-- Отчет по посещаемости в разных городах

SELECT DISTINCT 
	city.city_name ,
	city.country_name ,
	COUNT(visit.id) over (PARTITION by city.city_name) as visit
FROM visit
LEFT JOIN city
	ON visit.city_id = city.id;

-- Отчет по количеству совершенных конверсий

SELECT DISTINCT 
	conversion.id ,
	conversion.name as conversion,
	COUNT(hit.conversion_id) over (PARTITION by conversion.name) as total
FROM conversion
join hit
on hit.conversion_id = conversion.id 
ORDER by conversion.id;
       
-- Отчет по количеству визитов с разных девайсов и их соотношение


SELECT DISTINCT 
	device_type.name,
	COUNT(visit.id) over (PARTITION by device_type.name) as visit,
	COUNT(visit.id) over (PARTITION by device_type.name) / (SELECT count(id) FROM visit) as percent_of_device,
FROM device_type
LEFT JOIN visit
	ON visit.device_type_id = device_type.id;

-- Аналитика по пользователям, их визитам и совершенным ими заказам

SELECT DISTINCT 
	chanel_type.name as Chanel,
	visit.user_id, 
	COUNT(hit.id) over (PARTITION by hit.visit_id) as page_per_visit, 
	SEC_TO_TIME(sum(hit.time_on_page) over (PARTITION by hit.visit_id))  as visit_time,
	orders.id as order_id,
	(SELECT sum(order_content.revenue) FROM order_content where order_content.order_id = orders.id) DIV (SELECT sum(order_content.total) FROM order_content where order_content.order_id = orders.id) as avg_bill,
	(SELECT sum(order_content.total) FROM order_content where order_content.order_id = orders.id) as total_product,
	(SELECT sum(order_content.revenue) FROM order_content where order_content.order_id = orders.id) as revenue	
FROM hit
LEFT JOIN visit
	ON hit.visit_id = visit.id
LEFT JOIN chanel_type
        ON visit.chanel_type_id = chanel_type.id
LEFT JOIN orders
        ON visit.id = orders.visit_id
LEFT JOIN order_content
        ON orders.id = order_content.order_id
ORDER by order_id DESC;


-- Представление взято всего одно, но тут есть вообще все данные что бы можно было сделать любой отчет очень простым в написании


CREATE OR REPLACE view all_data as
SELECT DISTINCT 
	chanel_type.name as visit_chanel,
	visit.source as visit_source,
	visit.user_id visit_user_id,
	visit.id as visit_id,
	city.country_name as visit_country,
	city.country_name as visit_city,
	gender_type.name as gender,
	COUNT(hit.id) over (PARTITION by hit.visit_id) as page_per_visit, 
	SEC_TO_TIME(sum(hit.time_on_page) over (PARTITION by hit.visit_id))  as visit_time,
	orders.id as order_id,
	(SELECT sum(order_content.revenue) FROM order_content where order_content.order_id = orders.id) DIV (SELECT sum(order_content.total) FROM order_content where order_content.order_id = orders.id) as avg_bill,
	(SELECT sum(order_content.total) FROM order_content where order_content.order_id = orders.id) as total_product,
	(SELECT sum(order_content.revenue) FROM order_content where order_content.order_id = orders.id) as revenue	
FROM hit
LEFT JOIN visit
	ON hit.visit_id = visit.id
LEFT JOIN city
	ON visit.city_id = city.id
LEFT JOIN users 
	ON users.id = visit.user_id
LEFT JOIN gender_type 
	ON users.gender_id = gender_type.id	
LEFT JOIN chanel_type
	ON visit.chanel_type_id = chanel_type.id
LEFT JOIN orders
    ON visit.id = orders.visit_id
LEFT JOIN order_content
	ON orders.id = order_content.order_id
ORDER by order_id DESC;

SELECT * FROM all_data;

-- Представления с заказами и источникам заказов
CREATE OR REPLACE view all_orders as
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
        ON visit.chanel_type_id = chanel_type.id;


-- Стандартный отчет Яндекс метрики, собранный из того представления которое было создано

SELECT 
	visit_chanel, 
	COUNT(visit_id) as visit,
	TRUNCATE(AVG(page_per_visit), 2) as page_per_visit,
	SEC_TO_TIME(ROUND(AVG(visit_time))) as time_per_visit,
	COUNT(order_id) as orders, 
	ROUND(AVG(revenue)) as avg_bill,
	sum(revenue) as revenue	
FROM all_data 
group by visit_chanel;


