

CREATE UNIQUE INDEX users_email_uq_ix ON users(email);
CREATE INDEX profiles_birthday_ix ON profiles (birthday);

CREATE INDEX messages_body_ix ON messages (body);
CREATE INDEX posts_body_ix ON post (body);
CREATE INDEX posts_head_ix ON post (head);
CREATE UNIQUE INDEX community_name_ix ON post (head);



-- ��������� ������, ������� ����� �������� ��������� �������: 
-- ��� ������ 
-- ������� ���������� ������������� � ������� 
-- ����� ������� ������������ � ������ 
-- ����� ������� ������������ � ������ 
-- ����� ���������� ������������� � ������ 
-- ����� ������������� � ������� 
-- ��������� � ��������� (����� ���������� ������������� � ������ / ����� ������������� � �������) * 100

SELECT * FROM communities ;
SELECT * FROM communities_users;
SELECT * FROM profiles;

SELECT DISTINCT 
	communities.id,
	communities.name as communitie_name,
	COUNT(communities_users.user_id) over(PARTITION by communities.name) / (SELECT COUNT(communities.id) FROM communities) as avg_user,-- ������� ���������� ������������� � ������� 
	MIN(profiles.birthday) over(PARTITION by communities.name) as oldest_user,-- ����� ������� ������������ � ������ 
	MAX(profiles.birthday) over(PARTITION by communities.name) as youngest_user,-- ����� ������� ������������ � ������
	COUNT(communities_users.user_id) over(PARTITION by communities.name) as total_user_in_comm, -- ����� ���������� ������������� � ������
	COUNT(users.id) OVER () as total_user , -- ����� ������������� � �������
	COUNT(communities_users.user_id) over(PARTITION by communities.name) / COUNT(users.id) OVER () as proc_user -- * 100 ��������� � ��������� (����� ���������� ������������� � ������ / ����� ������������� � �������) * 100	 
    FROM communities_users
      JOIN communities
        ON communities_users.community_id = communities.id 
       JOIN profiles
      	on communities_users.user_id = profiles.user_id
      JOIN users
      	on communities_users.user_id = users.id;
