

CREATE UNIQUE INDEX users_email_uq_ix ON users(email);
CREATE INDEX profiles_birthday_ix ON profiles (birthday);

CREATE INDEX messages_body_ix ON messages (body);
CREATE INDEX posts_body_ix ON post (body);
CREATE INDEX posts_head_ix ON post (head);
CREATE UNIQUE INDEX community_name_ix ON post (head);



-- Построить запрос, который будет выводить следующие столбцы: 
-- имя группы 
-- среднее количество пользователей в группах 
-- самый молодой пользователь в группе 
-- самый старший пользователь в группе 
-- общее количество пользователей в группе 
-- всего пользователей в системе 
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100

SELECT * FROM communities ;
SELECT * FROM communities_users;
SELECT * FROM profiles;

SELECT DISTINCT 
	communities.id,
	communities.name as communitie_name,
	COUNT(communities_users.user_id) over(PARTITION by communities.name) / (SELECT COUNT(communities.id) FROM communities) as avg_user,-- среднее количество пользователей в группах 
	MIN(profiles.birthday) over(PARTITION by communities.name) as oldest_user,-- самый молодой пользователь в группе 
	MAX(profiles.birthday) over(PARTITION by communities.name) as youngest_user,-- самый молодой пользователь в группе
	COUNT(communities_users.user_id) over(PARTITION by communities.name) as total_user_in_comm, -- общее количество пользователей в группе
	COUNT(users.id) OVER () as total_user , -- всего пользователей в системе
	COUNT(communities_users.user_id) over(PARTITION by communities.name) / COUNT(users.id) OVER () as proc_user -- * 100 отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100	 
    FROM communities_users
      JOIN communities
        ON communities_users.community_id = communities.id 
       JOIN profiles
      	on communities_users.user_id = profiles.user_id
      JOIN users
      	on communities_users.user_id = users.id;
