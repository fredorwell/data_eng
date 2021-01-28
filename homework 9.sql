-- ����������, ���������� � ��������� �������������
-- 1.� ���� ������ shop � sample ������������ ���� � �� �� �������, ������� ���� ������. ����������� ������ id = 1 �� ������� shop.users � ������� sample.users. ����������� ����������.

desc sample.users;
desc shop.users;
ALTER TABLE sample.users ADD COLUMN birthday_at DATE COMMENT '���� ��������';
ALTER TABLE sample.users ADD COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE sample.users ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;


SELECT *from sample.users;
SELECT * from shop.users;

start transaction;
	INSERT into sample.users select * from shop.users where id=1;
	DELETE FROM shop.users WHERE id = 1;
commit;

-- 3.�������� �������������, ������� ������� �������� name �������� ������� �� ������� products � ��������������� �������� �������� name �� ������� catalogs.

SELECT * FROM products p ;
SELECT * FROM catalogs c2 ;

create view product_catalog as select products.name as product, catalogs.name as category from products join catalogs on products.catalog_id = catalogs.id;

SELECT * from product_catalog;
DROP VIEW product_catalog;

-- 4. (�� �������) ����� ������� ����� ������� � ����������� ����� created_at. �������� ������, ������� ������� ���������� ������ �� �������, �������� ������ 5 ����� ������ �������.

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

DELETE from fresh_value WHERE id < (SELECT max(ID)-5 FROM fresh_value) -- ���� �� ������������ ����� � id ����� primary key

delete fresh_value FROM fresh_value join (SELECT created_at from shop.fresh_value order by created_at desc limit 5.1) as del on shop.fresh_value.created_at <= del.created_at;

SELECT * FROM shop.fresh_value ;


-- �������� ��������� � �-���

-- 1. �������� �������� ������� hello(), ������� ����� ���������� �����������, � ����������� �� �������� ������� �����. 
-- � 6:00 �� 12:00 ������� ������ ���������� ����� "������ ����", 
-- � 12:00 �� 18:00 ������� ������ ���������� ����� "������ ����", 
-- � 18:00 �� 00:00 � "������ �����", 
-- � 00:00 �� 6:00 � "������ ����".

delimiter //
CREATE function hello() 
returns text no sql
begin
	declare hour INT;
	set hour = hour(now());
	case
	when hour between 6 and 11 then RETURN "������ ����";
	when hour between 12 and 17 then RETURN "������ ����";
	when hour between 18 and 23 then RETURN "������ �����";
	when hour between 0 and 5 then RETURN "������ ����";
    end case;
end//
delimiter ;
select now(), hello ();
DROP function hello;

-- � ������� products ���� ��� ��������� ����: name � ��������� ������ � description � ��� ���������. 
-- ��������� ����������� ����� ����� ��� ���� �� ���. ��������, ����� ��� ���� ��������� �������������� �������� NULL �����������. ��������� ��������, ��������� ����, ����� ���� �� ���� ����� ��� ��� ���� ���� ���������. 
-- ��� ������� ��������� ����� NULL-�������� ���������� �������� ��������.

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


