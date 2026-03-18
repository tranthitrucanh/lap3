-- 1
SELECT * 
FROM users
ORDER BY user_name ASC;

-- 2
SELECT TOP 7 *
FROM users
ORDER BY user_name ASC;

-- 3
SELECT *
FROM users
WHERE user_name LIKE '%a%'
ORDER BY user_name ASC;

-- 4
SELECT *
FROM users
WHERE user_name LIKE 'm%';

-- 5
SELECT *
FROM users
WHERE user_name LIKE '%i';

-- 6
SELECT *
FROM users
WHERE user_email LIKE '%@gmail.com';

-- 7
SELECT *
FROM users
WHERE user_email LIKE '%@gmail.com'
AND user_name LIKE 'm%';

-- 8
SELECT *
FROM users
WHERE user_email LIKE '%@gmail.com'
AND user_name LIKE '%i%'
AND LEN(user_name) > 5;

-- 9
SELECT *
FROM users
WHERE user_name LIKE '%a%'
AND LEN(user_name) BETWEEN 5 AND 9
AND user_email LIKE '%@gmail.com'
AND user_email LIKE '%i%@gmail.com';

-- 10
SELECT *
FROM users
WHERE 
(
    user_name LIKE '%a%' AND LEN(user_name) BETWEEN 5 AND 9
)
OR 
(
    user_name LIKE '%i%' AND LEN(user_name) < 9
)
OR
(
    user_email LIKE '%i%@gmail.com'
);