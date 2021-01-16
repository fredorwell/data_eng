-- 1. ��������� ������ ������������� users, ������� ����������� ���� �� ���� ����� orders � �������� ��������.

SELECT id, name, (SELECT COUNT(*) from orders where orders.user_id = users.id) as total_order from users where (SELECT COUNT(*) from orders where orders.user_id = users.id) > 0 ORDER BY id;

-- 2. �������� ������ ������� products � �������� catalogs, ������� ������������� ������.

SELECT (SELECT name from catalogs c2 where catalog_id = id) as category, name, desription, price FROM products;

-- 3.(�� �������) ����� ������� ������� ������ flights (id, from, to) � ������� ������� cities (label, name). ���� from, to � label �������� ���������� �������� �������, ���� name � �������. �������� ������ ������ flights � �������� ���������� �������.

SELECT id, flight_from, flight_to, (SELECT name from cities c2 where label = flight_from) as "�����", (SELECT name from cities c2 where label = flight_to)  as "��������" FROM flight f ;
