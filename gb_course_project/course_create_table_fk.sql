-- CREATE DATABASE analytics_system_course;

-- use analytics_system_course;

-- Основные таблицы


CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "client id", 
  gender_id INT UNSIGNED COMMENT "client_id",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
 ) COMMENT "Таблица сlient id";


CREATE TABLE visit (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор визита", 
  user_id INT UNSIGNED NOT NULL COMMENT "client_id",
  source VARCHAR(30) COMMENT "Источник визита",
  chanel_type_id INT UNSIGNED COMMENT "Ссылка канал привлечения визита",
  city_id INT UNSIGNED COMMENT "Ссылка город визита",
  device_type_id INT UNSIGNED COMMENT "Ссылка тип девайса",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки"
  ) COMMENT "Таблица c визитами";
 

CREATE TABLE hit (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор hit'a",
  visit_id INT UNSIGNED COMMENT "id визита в рамках которого был совершен hit",
  url VARCHAR(255) COMMENT "url страницы на которой был hit",
  time_on_page INT COMMENT "время проведенное на странице",
  conversion_id INT UNSIGNED COMMENT "id конверсии если была",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки"
  ) COMMENT "Данные по hit'ам";
  
CREATE TABLE orders (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "идентификатор заказа",
  visit_id INT UNSIGNED COMMENT "id визита в рамках которого была совершен заказ",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP  
 ) COMMENT "Таблица со списком транзакций";
 
CREATE TABLE order_content (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT  "Идентификатор строки",
  order_id INT UNSIGNED NOT NULL COMMENT "id визита в рамках которого была совершена транзакция",
  name VARCHAR(130) COMMENT "Название товарной позиции",
  total INT NOT NULL COMMENT "Количество товара",
  revenue INT NOT NULL COMMENT "стоимость товаров",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки"
  ) COMMENT "Данные по товарам в заказах";

 -- таблицы справочники
 
 CREATE TABLE chanel_type (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "идентификатор типа канала привлечения визита",
  name VARCHAR(50) COMMENT "Название канала",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP  
 ) COMMENT "Справочник каналов";
 
 CREATE TABLE gender_type (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "идентификатор пола",
  name VARCHAR(150) COMMENT "Название пола",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP  
 ) COMMENT "Справочник каналов";

CREATE TABLE city (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "идентификатор города",
  city_name VARCHAR(150) COMMENT "Название города",
  country_name VARCHAR(150) COMMENT "Название Страны",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
 ) COMMENT "Справочник городов";
 
CREATE TABLE device_type (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "идентификатор типа устройства",
  name VARCHAR(150) COMMENT "Название типа устройства",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
 ) COMMENT "Справочников типов устройств";

CREATE TABLE conversion (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "идентификатор конверсии",
  name VARCHAR(150) COMMENT "Название конверсии",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
 ) COMMENT "Справочник конверсий";
 

-- create foreign key

ALTER TABLE visit DROP FOREIGN KEY visit_device_type_id_fk;

ALTER TABLE visit
	ADD CONSTRAINT visit_user_id_fk 
		FOREIGN KEY (user_id) REFERENCES users(id)
	ON DELETE CASCADE;
ALTER TABLE visit
	ADD CONSTRAINT visit_chanel_type_id_fk 
		FOREIGN KEY (chanel_type_id) REFERENCES chanel_type(id)
		ON DELETE SET NULL;
ALTER TABLE visit
	ADD CONSTRAINT visit_city_id_fk 
		FOREIGN KEY (city_id) REFERENCES city (id)
		ON DELETE SET NULL;
ALTER TABLE visit
	ADD CONSTRAINT visit_device_type_id_fk 
		FOREIGN KEY (device_type_id) REFERENCES device_type (id)
		ON DELETE SET NULL;

	
ALTER TABLE users
	ADD CONSTRAINT users_gender_type_id_fk 
		FOREIGN KEY (gender_id) REFERENCES gender_type (id)
		ON DELETE SET NULL;


ALTER TABLE order_content 
	ADD CONSTRAINT order_content_order_id_fk 
		FOREIGN KEY (order_id) REFERENCES orders (id)
			ON DELETE CASCADE; -- null

			
ALTER TABLE orders 
	ADD CONSTRAINT orders_visit_id_fk 
		FOREIGN KEY (visit_id) REFERENCES visit (id)
			ON DELETE SET NULL; -- null

		
ALTER TABLE hit
	ADD CONSTRAINT hit_visit_id_fk 
		FOREIGN KEY (visit_id) REFERENCES visit (id)
		ON DELETE CASCADE;
		
ALTER TABLE hit
	ADD CONSTRAINT hit_conversion_id_fk 
		FOREIGN KEY (conversion_id) REFERENCES conversion (id);


