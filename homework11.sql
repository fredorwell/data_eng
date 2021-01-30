-- �������� ������� logs ���� Archive. ����� ��� ������ �������� ������ � �������� users, catalogs � products � ������� logs ����������:
-- ����� � ���� �������� ������,
-- �������� �������, 
-- ������������� ���������� �����
-- ���������� ���� name


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
	      
-- ��������

INSERT INTO users (name, birthday_at) VALUES
  ('��������', '1990-10-05'),
  ('�������', '1984-11-12');
 

 INSERT INTO products
  (name, desription, price, catalog_id)
VALUES
  ('Intel Core i3-8100', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 7890.00, 1),
  ('Intel Core i5-7400', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 12700.00, 1);

SELECT * FROM catalogs c2 ;
INSERT INTO catalogs 
  (name)
VALUES
  ('������'),
  ('������� ������������');
 
 SELECT * FROM logs;

-- NOSQL
-- 1. � ���� ������ Redis ��������� ��������� ��� �������� ��������� � ������������ IP-�������.
-- 2. ��� ������ ���� ������ Redis ������ ������ ������ ����� ������������ �� ������������ ������ � ��������, ����� ������������ ������ ������������ �� ��� �����.

hset user_email name email
hset email_user email name
hget user_email "name"
hget email_user "email"


-- 3. ����������� �������� ��������� � �������� ������� ������� ���� ������ shop � ���� MongoDB.
try {
	shop.catalogs.insertMany( [
	      { _id: 1, name: "����������"},
	      { _id: 2, name: "����������� �����"},
	      { _id: 3 ,name: "����������"}
	   ] );
	
	shop.products.insertMany(
		{name: "AMD FX-8320",
	    description: "��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.",
	    price: 7120.00,
	    catalog: 1},
	    {name: "MSI B250M GAMING PRO",
	    description: "����������� ����� MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX",
	    price: 4120.00,
	    catalog: 2});
	 }
   
 -- �� ����������, ������ ��������� ��������� mongo db
