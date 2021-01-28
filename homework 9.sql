-- транзакции, переменные и временные представления
-- 1.В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

desc sample.users;
desc shop.users;
ALTER TABLE sample.users ADD COLUMN birthday_at DATE COMMENT 'Дата рождения';
ALTER TABLE sample.users ADD COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE sample.users ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;


SELECT *from sample.users;
SELECT * from shop.users;

start transaction;
	INSERT into sample.users select * from shop.users where id=1;
	DELETE FROM shop.users WHERE id = 1;
commit;

-- 3.Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.

SELECT * FROM products p ;
SELECT * FROM catalogs c2 ;

create view product_catalog as select products.name as product, catalogs.name as category from products join catalogs on products.catalog_id = catalogs.id;

SELECT * from product_catalog;
DROP VIEW product_catalog;

-- 4. (по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

use shop;
CREATE TABLE fresh_value (
	id SERIAL PRIMARY KEY,
	created_at DATE not null
);

SELECT * FROM shop.fresh_value ;

INSERT into shop.fresh_value values
(null, '2020-01-01'),
(null, '2020-02-01'),
(null, '2020-03-01'),
(null, '2020-04-01'),
(null, '2020-05-01'),
(null, '2020-06-01'),
(null, '2020-07-01'),
(null, '2020-08-01'),
(null, '2020-09-01'),
(null, '2020-10-01'),
(null, '2020-11-01'),
(null, '2020-12-01');

DELETE from fresh_value WHERE id < (SELECT max(ID)-5 FROM fresh_value) -- Если не использовать джоин и id будет primary key

delete fresh_value FROM fresh_value join (SELECT created_at from shop.fresh_value order by created_at desc limit 5.1) as del on shop.fresh_value.created_at <= del.created_at;

SELECT * FROM shop.fresh_value ;


-- хранимые процедуры и ф-ции

-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", 
-- с 00:00 до 6:00 — "Доброй ночи".

delimiter //
CREATE function hello() 
returns text no sql
begin
	declare hour INT;
	set hour = hour(now());
	case
	when hour between 6 and 11 then RETURN "Доброе утро";
	when hour between 12 and 17 then RETURN "Добрый день";
	when hour between 18 and 23 then RETURN "Добрый вечер";
	when hour between 0 and 5 then RETURN "Доброй ночи";
    end case;
end//
delimiter ;
select now(), hello ();
DROP function hello;

-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

drop trigger if exists check_insert_product;
drop trigger if exists check_update_product;
SELECT * FROM products p ;

delimiter //

CREATE TRIGGER check_insert_product BEFORE INSERT ON shop.products
FOR EACH ROW BEGIN
  IF NEW.name IS NULL AND NEW.desription IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Name and description is null';
  END IF;
END//



CREATE TRIGGER check_update_product BEFORE update ON shop.products
FOR EACH ROW BEGIN
  IF NEW.name IS NULL AND NEW.desription IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Name and description is null';
  END IF;
END//
delimiter ;

INSERT INTO shop.products
  (id, name, desription)
VALUES
  (null, null, null);


