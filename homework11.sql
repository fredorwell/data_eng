-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается:
-- время и дата создания записи,
-- название таблицы, 
-- идентификатор первичного ключа
-- содержимое поля name


CREATE TABLE logs (
  table_name VARCHAR(20) NOT NULL,
  obj_id INT UNSIGNED NOT NULL,
  name VARCHAR(255),
  created_at DATETIME DEFAULT NOW()
) ENGINE=ARCHIVE;


CREATE TRIGGER users_logs_new 
	AFTER INSERT ON users FOR EACH ROW
	  INSERT INTO logs 
	    SET 
	      table_name = 'users',
	      obj_id = NEW.id,
	      name = NEW.name;

CREATE TRIGGER catalogs_logs_new 
	AFTER INSERT ON catalogs FOR EACH ROW
	  INSERT INTO logs 
	    SET 
	      table_name = 'catalogs',
	      obj_id = NEW.id,
	      name = NEW.name;

CREATE TRIGGER products_logs_new
	AFTER INSERT ON products FOR EACH ROW
	  INSERT INTO logs 
	    SET 
	      table_name = 'products',
	      obj_id = NEW.id,
	      name = NEW.name;
	      
-- проверка

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12');
 

 INSERT INTO products
  (name, desription, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1);

SELECT * FROM catalogs c2 ;
INSERT INTO catalogs 
  (name)
VALUES
  ('Корпус'),
  ('Сетевое оборудование');
 
 SELECT * FROM logs;

-- NOSQL
-- 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
-- 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.

hset user_email name email
hset email_user email name
hget user_email "name"
hget email_user "email"


-- 3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
try {
	shop.catalogs.insertMany( [
	      { _id: 1, name: "Процессоры"},
	      { _id: 2, name: "Материнские платы"},
	      { _id: 3 ,name: "Видеокарты"}
	   ] );
	
	shop.products.insertMany(
		{name: "AMD FX-8320",
	    description: "Процессор для настольных персональных компьютеров, основанных на платформе AMD.",
	    price: 7120.00,
	    catalog: 1},
	    {name: "MSI B250M GAMING PRO",
	    description: "Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX",
	    price: 4120.00,
	    catalog: 2});
	 }
   
 -- Не тестировал, просто посмотрел синтаксис mongo db
