-- 3. ���������� ��� ������ �������� ������ (�����) - ������� ��� �������?

SELECT (SELECT gender FROM profiles where user_id = likes.user_id) as gen, count(*) AS total FROM likes group by gen WITH ROLLUP;

-- 4. ���������� ���������� ������ ������� �������� 10 ����� ������� �������������.


SELECT 
	liked_user_id, 
	COUNT(*) as total,
	CONCAT((SELECT first_name FROM users u2 where id = liked_user_id), ' ',(SELECT last_name FROM users u2 where id = liked_user_id)) as name ,
	(SELECT created_at FROM users u3 where id = liked_user_id) as user_created_at	 
FROM likes l 
where liked_user_id > 0 
GROUP BY liked_user_id
ORDER BY user_created_at DESC
LIMIT 10;



-- 5. ����� 10 �������������, ������� ��������� ���������� ���������� �
-- ������������� ���������� ����
-- (�������� ���������� ���������� ���������� ��������������).
SELECT 
	id,
	first_name,
	last_name,
	(Select count(*) FROM likes where user_id = users.id) + 
	(Select count(*) FROM posts where user_id = users.id) + 
	(Select count(*) FROM messages m2 where from_user_id  = users.id)  + 
	(Select count(*) FROM media m2 where user_id = users.id) as ap 
FROM users 
group by id
ORDER by ap
LIMIT 10;