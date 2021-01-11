Операторы
______________________________________________
SELECT 3+5;
SELECT 3+5 AS summ;

SELECT * FROM catalogs;

UPDATE catalogs SET id = id +10;

SELECT 8-5;
SELECT 3*5;
SELECT 8/0;
SELECT 5/2, 5 DIV 2;
SELECT 5%2, 5 MOD 2;

SELECT TRUE, FALSE,! TRUE, ! FALSE;

SELECT 2 <=> NULL, NULL <=> NULL; 

INSERT INTO catalogs VALUE();
INSERT INTO catalogs VALUE(NULL, 'Сетевое оборудование');

SELECT * FROM catalogs WHERE name IS NULL;
SELECT * FROM catalogs WHERE name IS NOT NULL;

CREATE TABLE tbl (x INT, y int, summ INT AS (x + y));
SELECT * FROM tbl;

INSERT INTO tbl(x, y) VALUES (1, 1), (5, 6), (11, 12);
DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl (x INT, y int, summ INT AS (x + y) STORED);

______________________________________________


Условная выборка
______________________________________________

SELECT * FROM catalogs;
SELECT * FROM catalogs WHERE id > 2;
SELECT * FROM catalogs WHERE id > 2 AND id <= 4;
SELECT * FROM catalogs WHERE id BETWEEN 1 AND 3;
SELECT * FROM catalogs WHERE id NOT BETWEEN 1 AND 3;
SELECT * FROM catalogs WHERE id IN (1, 2, 5);
SELECT * FROM catalogs WHERE id NOT IN (1, 2, 5);
SELECT * FROM catalogs WHERE name = 'процессоры';
SELECT * FROM catalogs WHERE name LIKE '%ы';
SELECT * FROM catalogs WHERE name NOT LIKE '%ы';
INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');
SELECT * FROM users;
SELECT * FROM users WHERE birthday_at >= '1990-01-01' AND birthday_at <= '2000-01-01';
SELECT * FROM users WHERE birthday_at BETWEEN '1990-01-01' AND '2000-01-01';
SELECT * FROM users WHERE birthday_at LIKE '199%';

SELECT 'грамм' RLIKE 'грам', 'граммпластинка' RLIKE 'грам';
SELECT 'программиолвагие' RLIKE '^грам', 'граммпластинка' RLIKE '^грам';-- начало строки
SELECT 'программиолвагие' RLIKE 'грам$', 'sdasdsadграм' RLIKE 'грам$';-- начало строки
SELECT 'п' RLIKE '[а-яё]';
SELECT 7 RLIKE '[[:digit:]]', 'Hello' RLIKE '[[:digit:]]';
SELECT '342.34' RLIKE '^[0-9]*\\.[0-9]{2}$' AS '342.34';
______________________________________________


Сортировка
______________________________________________

SELECT * FROM products;
SELECT * FROM catalogs ORDER BY name ;

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);
 
SELECT id, catalog_id ,price ,name FROM products ORDER BY catalog_id ,price; -- Сортировка по каталог ид и прайсу
SELECT id, catalog_id ,price ,name FROM products ORDER BY catalog_id ,price DESC ;  -- Сортировка по каталог ид и прайсу в обратную
SELECT id, catalog_id ,price ,name FROM products LIMIT 2;
SELECT id, catalog_id ,price ,name FROM products LIMIT 2,2;

SELECT DISTINCT catalog_id FROM products ORDER BY catalog_id; -- Вывод уникальных значений
SELECT ALL catalog_id FROM products ORDER BY catalog_id; -- Вывод всех значений

SELECT id, catalog_id ,price ,name FROM products WHERE catalog_id = 2 AND price >= "5000";
UPDATE products SET price = price * 0.9 WHERE catalog_id = 2 AND price >= "5000";

SELECT id, catalog_id ,price ,name FROM products ORDER BY price DESC;
SELECT id, catalog_id ,price ,name FROM products ORDER BY price DESC LIMIT 2;
DELETE FROM products ORDER BY price DESC LIMIT 2;


______________________________________________
Предопределенные функции
______________________________________________

SELECT NOW();
INSERT INTO users VALUES (NULL, 'Александр', '1986-01-20', NOW(), NOW());
SELECT DATE_FORMAT(NOW(), 'На дворе %Y год'); 
SELECT name, DATE_FORMAT(birthday_at, '%d.%m.%Y') AS birthday_at FROM users;
SELECT * FROM users;
SELECT UNIX_TIMESTAMP(NOW()) AS TIMESTAMP, FROM_UNIXTIME(1610305905) AS DATETIME; 
SELECT name, FLOOR((TO_DAYS(now()) - TO_DAYS(birthday_at)) / 365.25) as AGE FROM users; -- Вычисление возраста через дни
SELECT name, TIMESTAMPDIFF(YEAR, birthday_at, NOW()) as AGE FROM users; -- Вычисление возраста через TIMESTAMPDIFF
SELECT * FROM users ORDER BY RAND();
SELECT VERSION();

SELECT * FROM distances ;

CREATE TABLE distances (
  id SERIAL PRIMARY KEY,
  x1 INT NOT NULL,
  y1 INT NOT NULL,
  x2 INT NOT NULL,
  y2 INT NOT NULL,
  distance DOUBLE AS (SQRT(POW(x1 - x2, 2) + POW(y1 - y2, 2)))
) COMMENT = 'Расстояние между двумя точками';

INSERT INTO distances
  (x1, y1, x2, y2)
VALUES
  (1, 1, 4, 5),
  (4, -1, 3, 2),
  (-2, 5, 1, 3);

 DROP TABLE IF EXISTS distances;
CREATE TABLE distances (
  id SERIAL PRIMARY KEY,
  a JSON NOT NULL,
  b JSON NOT NULL,
  distance DOUBLE AS (SQRT(POW(a->>'$.x' - b->>'$.x', 2) + POW(a->>'$.y' - b->>'$.y', 2)))
) COMMENT = 'Расстояние между двумя точками';

INSERT INTO distances
  (a, b)
VALUES
  ('{"x": 1, "y": 1}', '{"x": 4, "y": 5}'),
  ('{"x": 4, "y": -1}', '{"x": 3, "y": 2}'),
  ('{"x": -2, "y": 5}', '{"x": 1, "y": 3}');
 -- триугольники
 DROP TABLE IF EXISTS triangles;
CREATE TABLE triangles (
  id SERIAL PRIMARY KEY,
  a DOUBLE NOT NULL COMMENT 'Сторона треугольника',
  b DOUBLE NOT NULL COMMENT 'Сторона треугольника',
  angle INT NOT NULL COMMENT 'Угол треугольника в градусах',
  square DOUBLE AS (a * b * SIN(RADIANS(angle)) / 2.0)
) COMMENT = 'Площадь треугольника';

INSERT INTO triangles (a, b, angle) VALUES (1.414, 1, 45), (2.707, 2.104, 60), (2.088, 2.112, 56), (5.014, 2.304, 23), (3.482, 4.708, 38);

SELECT * FROM triangles ;
ALTER TABLE triangles CHANGE square square DOUBLE AS (ROUND(a * b * SIN(RADIANS(angle)) / 2.0 , 4));

SELECT id, SUBSTRING(name, 1, 5) AS name FROM users; -- ограничение кол-ва вывода
SELECT id, CONCAT(name, ' ', TIMESTAMPDIFF(YEAR, birthday_at, NOW())) as NAME FROM users; -- Вычисление возраста через TIMESTAMPDIFF

SELECT name, IF(TIMESTAMPDIFF(YEAR, birthday_at, NOW()) >= 18, 'совершеннолетний', 'несовершеннолетний') AS status FROM users;

DROP TABLE IF EXISTS rainbow;
CREATE TABLE rainbow (
  id SERIAL PRIMARY KEY,
  color VARCHAR(255)
) COMMENT = 'Цвета радуги';

INSERT INTO
  rainbow (color)
VALUES
  ('red'),
  ('orange'),
  ('yellow'),
  ('green'),
  ('blue'),
  ('indigo'),
  ('violet');
 
 SELECT
  CASE
    WHEN color = 'red' THEN 'красный'
    WHEN color = 'orange' THEN 'оранжевый'
    WHEN color = 'yellow' THEN 'желтый'
    WHEN color = 'green' THEN 'зеленый'
    WHEN color = 'blue' THEN 'голубой'
    WHEN color = 'indigo' THEN 'синий'
    ELSE 'фиолетовый'
  END AS russian
FROM
  rainbow;
 
______________________________________________
Агрегация данных
______________________________________________
 
SELECT * FROM users u ;
SELECT id, name , SUBSTRING(birthday_at, 1, 3) FROM users;
SELECT id, name , SUBSTRING(birthday_at, 1, 3) as decade FROM users order by decade ;
SELECT SUBSTRING(birthday_at, 1, 3) as decade FROM users GROUP by decade ;
SELECT COUNT(*) AS total, SUBSTRING(birthday_at, 1, 3) as decade FROM users GROUP by decade ORDER by total ;
SELECT GROUP_CONCAT(name ORDER BY name DESC SEPARATOR ' ') , SUBSTRING(birthday_at, 1, 3) as decade FROM users GROUP by decade; -- склеивание группы с разделителями

SELECT COUNT(id) FROM users u ;
SELECT COUNT(*) FROM users u ;

SELECT catalog_id, MIN(price) as min, MAX(price) as max FROM products p group by catalog_id ; -- макс мин
SELECT catalog_id, ROUND(AVG(price * 1.2), 2) FROM products p group by catalog_id ; -- Среднее
SELECT catalog_id, ROUND(SUM(price * 1.2), 2) FROM products p group by catalog_id ; -- сумма 

SELECT COUNT(*) AS total, SUBSTRING(birthday_at, 1, 3) as decade FROM users GROUP by decade HAVING total >= 2;

TRUNCATE products;



INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);


SELECT * FROM products;
SELECT name, description, price, catalog_id FROM products group by name, description, price, catalog_id ;

SELECT * FROM products_new;
CREATE TABLE products_new (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  desription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products_new SELECT NULL,name, description, price, catalog_id, NOW(), NOW() FROM products group by name, description, price, catalog_id ;
SELECT * FROM products_new;

DROP table products ;
ALTER table products_new RENAME products;

INSERT INTO users (name, birthday_at) VALUES ('Геннадий', '1990-10-05');

SELECT * FROM users ;

SELECT COUNT(*), YEAR(birthday_at) FROM users group by birthday_at order by birthday_at ;
SELECT ANY_VALUE(name), YEAR(birthday_at) FROM users group by birthday_at order by birthday_at ;
SELECT COUNT(*), SUBSTRING(birthday_at, 1, 3) as decade FROM users GROUP by decade WITH ROLLUP ;



HW


CREATE TABLE users_hw5 (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)