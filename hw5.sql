-- ���������
-- 1.C������� ������� � ���������� updated_at, created_at
CREATE TABLE users_hw5 (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� ��������',
  created_at DATETIME /*DEFAULT CURRENT_TIMESTAMP*/,
  updated_at DATETIME /*DEFAULT CURRENT_TIMESTAMP*/ ON UPDATE CURRENT_TIMESTAMP
) comment = '�������� ���������������� �������� �� �������� ��� �� �������� ������� �������� � �������';

INSERT INTO users_hw5 (name, birthday_at) VALUES
  ('��������', '1990-10-05'),
  ('�������', '1984-11-12'),
  ('���������', '1985-05-20'),
  ('������', '1988-02-14'),
  ('����', '1998-01-12'),
  ('�����', '1992-08-29');
  
SELECT * FROM users_hw5 uh ;

UPDATE users_hw5 set updated_at = NOW();
UPDATE users_hw5 set created_at = NOW();

-- 2. �� varchar � datetime
SELECT * FROM users_hw5 uh ;


ALTER TABLE users_hw5 ADD updated_at_v VARCHAR(30);
UPDATE users_hw5 set updated_at_v = NOW(); -- ��� �� �� ������ ��� � ������ ������ ����� ������� ������ ��� �������
ALTER TABLE users_hw5 MODIFY COLUMN updated_at_v DATETIME; -- ��������� ����
ALTER TABLE users_hw5 ADD created_at_v varchar(30);
UPDATE users_hw5 set created_at_v = NOW();
ALTER TABLE users_hw5 MODIFY COLUMN created_at_v DATETIME;


ALTER TABLE users_hw5 DROP created_at_v;-- ��� ��� �� ������� ����� �������
ALTER TABLE users_hw5 DROP updated_at_v;
ALTER TABLE users_hw5 DROP stock;

-- 3. ����� � ����������� 
SELECT * FROM storehouse_products sp ;
INSERT INTO storehouse_products (storehouse_id , product_id, value) VALUES
  ('1', '1', '10'),
  ('1', '2', '20'),
  ('1', '3', '30'),
  ('1', '4', '0'),
  ('1', '5', '0'),
  ('2', '6', '40'),
  ('2', '7', '50');
ALTER TABLE storehouse_products ADD stock BOOLEAN;
UPDATE storehouse_products set stock = IF(value = 0, 0, 1);
SELECT * FROM storehouse_products sp ORDER BY stock DESC, value ;
-- �������� ������� �������������� ������� ����������� ���� ��� �� ��������� ���������� �� ���� ��������


-- ��������� ������
-- 1. ������� ������� ������������
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW()))) FROM users;
-- 2. �������� ���� �������� �� ���� ������

SELECT name, FLOOR((TO_DAYS(now()) - TO_DAYS(birthday_at)) / 365.25) as AGE FROM users; -- ���������� �������� ����� ���


SELECT name, birthday_at, (TO_DAYS(birthday_at)) as AGE FROM users_hw5; -- ���������� �������� ����� ���
SELECT name, birthday_at, (TO_DAYS(birthday_at) + TO_DAYS(NOW())) as AGE FROM users_hw5;
SELECT * FROM users_hw5 uh ;
 









ALTER TABLE users_hw5 DROP created_at_v;


SELECT * FROM users_hw5 uh ;

ALTER TABLE users_hw5 ADD updated_at_v_u VARCHAR(30);
UPDATE users_hw5 set = UNIX_TIMESTAMP(updated_at_v) ;


SELECT UNIX_TIMESTAMP(NOW()) AS TIMESTAMP, FROM_UNIXTIME(1610314880) AS DATETIME; 