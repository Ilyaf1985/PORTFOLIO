/* База данных программы сотрудников условной Компании, в которой много филиалов в различных городах мира.
Сотрудники состоят в различных отделах этой Компании и работают в разных городах.
С помощью внутренней программы Компании они коммуницируют друг с другом и состоят в сообществах (отлелы, рабочие группы), в которые они добавляются автоматически 
при устройстве на работу, а также могут добавиться в рабочие группы. 
Эта программа основывается на БД сотрудников Компании.
*/

-- ЗАПРОСЫ К КУРСОВОМУ ПРОЕКТУ

USE company ;

-- ПРОСТЫЕ ЗАПРОСЫ -------------------

SELECT * FROM employees
WHERE affiliate = 3 AND gender = 'M'
ORDER BY last_name DESC; -- простой запрос
-- ----

SELECT first_name, last_name, birthday, gender, email,
(SELECT phone FROM phones WHERE phones.id = employees.phone_work) AS 'Рабочий телефон'
  FROM employees
  WHERE affiliate = 1 AND status_in_company = 'Active'
  ORDER BY last_name; -- сложный запрос


-- ГРУППИРОВКА -----------------------------------

SELECT first_name, last_name, gender, affiliate
FROM employees
WHERE affiliate IN (2, 3) AND gender = 'M'
ORDER BY affiliate, last_name; -- Вывести всех мужчин в Филиалах Барселоны и Милана

-- СЛОЖНЫЕ ЗАПРОСЫ С ВЛОЖЕННЫМИ ЗАПРОСАМИ -------------

SELECT  department_id AS 'Номер отдела',
		(SELECT name_department FROM departments WHERE departments.id = departments_employees.department_id) AS 'Название отдела',
        (SELECT name_affiliate FROM affiliates WHERE affiliates.id = 
        (SELECT affiliate FROM employees WHERE employees.id = departments_employees.employee_id)) AS 'Название филиала',
        (SELECT city FROM affiliates WHERE affiliates.id = 
        (SELECT affiliate FROM employees WHERE employees.id = departments_employees.employee_id)) AS 'Город',
        (SELECT country FROM affiliates WHERE affiliates.id = 
        (SELECT affiliate FROM employees WHERE employees.id = departments_employees.employee_id)) AS 'Страна',
		(SELECT first_name FROM employees WHERE employees.id = departments_employees.employee_id) AS 'ИМЯ',
        (SELECT last_name FROM employees WHERE employees.id = departments_employees.employee_id) AS 'Фамилия',
		(SELECT birthday FROM employees WHERE employees.id = departments_employees.employee_id) AS 'Дата рождения',
        (SELECT phone FROM phones WHERE phones.id = 
        (SELECT phone_work FROM employees WHERE employees.id = departments_employees.employee_id)) AS 'Рабочий телефон'
FROM departments_employees
WHERE department_id = 5
ORDER BY 'Дата рождения' DESC; --  аналитики отдела в России по дате рождения

-- COUNT -------------------

SELECT count(*), gender FROM employees WHERE affiliate IN (2, 3) AND gender = 'F'; -- Количество женщин в Филиалах Барселоны и Милана

SELECT count(*) AS 'Количество сотрудников',
	   affiliate AS 'Номер филиала',
       (SELECT name_affiliate FROM affiliates WHERE id = affiliate) AS 'Название филиала',
       (SELECT country FROM affiliates WHERE id = affiliate) AS 'Страна',
       (SELECT city FROM affiliates WHERE id = affiliate) AS 'Город'
FROM employees
GROUP BY affiliate; -- Количество сотрудников в филиалах      
 --  ---       
       
SELECT affiliate, count(*) AS 'Количество сообщений'
FROM (SELECT from_employee_id, 
(SELECT affiliate FROM employees WHERE messages.from_employee_id = employees.id) AS affiliate FROM messages
UNION ALL
SELECT to_employee_id,
(SELECT affiliate FROM employees WHERE employees.id = messages.to_employee_id) AS affiliate FROM messages)
AS rerry
GROUP BY affiliate
ORDER BY count(*) DESC; -- Какой филиал больше всего отправил или принял сообщений

-- JOIN -----------------------------------

SELECT CONCAT (first_name, ' ', last_name) AS 'Имя',
birthday, gender, profiles.city, profiles.country, 
(SELECT name FROM hobbies WHERE hobbies.id = hobbies_employees.hobbies_id) AS 'Хобби', 
profiles.about_yourself AS 'О себе'
FROM employees
JOIN profiles ON profiles.employee_id = employees.id
JOIN hobbies_employees ON hobbies_employees.employee_id = employees.id
WHERE affiliate = (SELECT id FROM affiliates WHERE city = 'Barcelona')
ORDER BY 'Имя' DESC, 'Хобби'; -- JOIN запросы. Личные данные сотрудников Барселоны       
-- -----

SELECT employees.affiliate, count(*) AS 'Количество сообщений'
FROM messages
JOIN employees ON messages.from_employee_id = employees.id OR messages.to_employee_id = employees.id
JOIN affiliates ON affiliates.id = employees.affiliate
GROUP BY affiliate
ORDER BY count(*) DESC;  -- JOIN!!! Какой филиал больше всего отправил или принял сообщений

-- Хранимые процедуры -----------------------------------

DROP PROCEDURE IF EXISTS find_post_1;
DROP PROCEDURE IF EXISTS find_post_2;

DELIMITER //

CREATE PROCEDURE find_post_1 (IN name_post VARCHAR(100))
BEGIN
SELECT p2.id AS 'Номер должности', p2.name_post AS 'Название должности'
FROM posts p1
JOIN posts p2 ON p1.id = p2.id
WHERE p1.name_post = name_post;
END //

CREATE PROCEDURE find_post_2 (IN name_post VARCHAR(100))
BEGIN
SELECT e.id AS 'Номер сотрудника', p2.name_post AS 'Название должности', CONCAT (e.first_name, ' ', e.last_name) AS 'ФИО'
FROM posts p1
JOIN posts p2 ON p1.id = p2.id
JOIN employees e ON e.post = p2.id
WHERE p1.name_post = name_post;
END //

DELIMITER ;

CALL find_post_1 ('Specialist'); -- ПОИСК ВСЕ АНАЛОГИЧНые ДОЛЖНОСТи В КОМПАНИИ
CALL find_post_2 ('Analytic'); -- ПОИСК ВСЕХ СОТРУДНИКОВ АНАЛОГИЧНОЙ ДОЛЖНОСТи В КОМПАНИИ

-- -----

DROP PROCEDURE IF EXISTS find_friends_in_my_affiliate; 

DELIMITER //
CREATE PROCEDURE find_friends_in_my_affiliate (IN last_name VARCHAR(100)) -- ФИО МОЖЕТ СОВПАДАТЬ, ПОЭТОМУ ЛУЧШЕ СДЕЛАТЬ ПО ТЕЛЕФОНУ
BEGIN
SELECT e2.id AS 'Номер сотрудника', a.name_affiliate AS 'Название филиала', CONCAT (e2.first_name, ' ', e2.last_name) AS 'ФИО'
FROM employees e1 -- можно создать вложенную таблицу с id, affiliate и ФИО пользователя через CONCAT и найти по ФИО а не фамилии
JOIN employees e2 ON e1.affiliate =e2.affiliate
JOIN affiliates a ON a.id = e2.affiliate
WHERE e1.last_name = last_name AND e2.last_name != last_name
ORDER BY RAND()
LIMIT 5; -- <> аналогично
END //
DELIMITER ;

CALL find_friends_in_my_affiliate ('Rohan'); -- ПРЕДЛОЖИТЬ ДЛЯ ДРУЖБЫ ЛЮБЫХ 5 СОТРУДНИКОВ В МОЕМ ФИЛИАЛЕ

-- --------- ДОБАВЛЕНИЕ СОТРУДНИКА С ПОМОЩЬЮ ПРОЦЕДУРЫ И ТРАНЗАКЦИИ

DROP PROCEDURE IF EXISTS add_employees;

DELIMITER //
CREATE PROCEDURE add_employees(
first_name VARCHAR(100), last_name VARCHAR(100), birthday DATE, gender ENUM('M','F'), email VARCHAR(100), affiliate INT, department INT, post INT,
phone VARCHAR(12), phone_work INT, avatar INT, city VARCHAR(100) , country VARCHAR(100), about_yourself TEXT, 
OUT result VARCHAR (200))
BEGIN
   DECLARE `_rollback` BIT DEFAULT 0;
   DECLARE code VARCHAR(100);
   DECLARE error_string VARCHAR(100);

   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
   BEGIN 
     SET `_rollback` = 1;
     GET stacked DIAGNOSTICS CONDITION 1
          code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
     SET result = CONCAT('ERROR: ', code, ' . Text: ', error_string);
END;

START TRANSACTION;
    INSERT INTO employees (first_name, last_name, birthday, gender, email, affiliate, department, post, phone, phone_work)
    VALUES (first_name, last_name, birthday, gender, email, affiliate, department, post, phone, phone_work);
    
    INSERT INTO profiles (employee_id, avatar, city, country)
    VALUES (last_insert_id(), avatar, city, country);

IF `_rollback` = 1 THEN ROLLBACK;
ELSE 
SET result = 'OK';
COMMIT;
END IF;
END //
DELIMITER ;

CALL add_employees('Лео', 'Месси', '1987-06-28', 'M', 'leonid.messi@mail.ru', 3, 15, 40, '+79261111111', 44, 55, 'Егорьевск', 'Россия', 'Nothing', @result);
SELECT @result AS 'Результат'; 

-- ПРЕДСТАВЛЕНИЯ 

-- Какой филиал больше всего отправил или принял сообщений

CREATE VIEW count_message AS
SELECT employees.affiliate, count(*) AS 'Количество сообщений'
FROM messages
JOIN employees ON messages.from_employee_id = employees.id OR messages.to_employee_id = employees.id
JOIN affiliates ON affiliates.id = employees.affiliate
GROUP BY affiliate
ORDER BY count(*) DESC;

SELECT * FROM count_message; -- Какой филиал больше всего отправил или принял сообщений

-- -----------------------

CREATE VIEW employees_BARCELONA AS
SELECT CONCAT (first_name, ' ', last_name) AS 'Имя',
birthday, gender, profiles.city, profiles.country, 
(SELECT name FROM hobbies WHERE hobbies.id = hobbies_employees.hobbies_id) AS 'Хобби', 
profiles.about_yourself AS 'О себе'
FROM employees
JOIN profiles ON profiles.employee_id = employees.id
JOIN hobbies_employees ON hobbies_employees.employee_id = employees.id
WHERE affiliate = (SELECT id FROM affiliates WHERE city = 'Barcelona')
ORDER BY 'Имя' DESC, 'Хобби'; 

SELECT * FROM employees_BARCELONA; -- Личные данные сотрудников Барселоны

-- --------------------------------

CREATE VIEW employees_Milan AS
SELECT CONCAT (first_name, ' ', last_name) AS 'Имя',
birthday, gender, profiles.city, profiles.country, 
(SELECT name FROM hobbies WHERE hobbies.id = hobbies_employees.hobbies_id) AS 'Хобби', 
profiles.about_yourself AS 'О себе'
FROM employees
JOIN profiles ON profiles.employee_id = employees.id
JOIN hobbies_employees ON hobbies_employees.employee_id = employees.id
WHERE affiliate = (SELECT id FROM affiliates WHERE city = 'Milan')
ORDER BY 'Имя' DESC, 'Хобби'; 

SELECT * FROM employees_Milan; -- Личные данные сотрудников Милана


-- ТРИГГЕРЫ

drop TRIGGER check_age;

DELIMITER //
CREATE TRIGGER check_age
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  IF NEW.birthday > CURRENT_DATE() - INTERVAL 18 YEAR
  THEN 
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Сотрудник несовершеннолетний';
  END IF;
  END // -- Нельзя внести данные по несовершеннолетнему сотруднику

DELIMITER ;

INSERT INTO employees (id, first_name, last_name, birthday, gender, email, affiliate, department, post, phone, phone_work) VALUES 
(46, 'Лев', 'Толстой', '2003-10-22', 'M', 'lev.tolstoy@example.com', 1, 3, 23, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 46);

DELETE FROM employees WHERE id = 46;
