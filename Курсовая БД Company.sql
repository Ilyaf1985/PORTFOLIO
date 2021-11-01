/* База данных программы сотрудников условной Компании, в которой много филиалов в различных городах мира.
Сотрудники состоят в различных отделах этой Компании и работают в разных городах.
С помощью внутренней программы Компании они коммуницируют друг с другом и состоят в сообществах (отлелы, рабочие группы), в которые они добавляются автоматически 
при устройстве на работу, а также могут добавиться в рабочие группы. 
Эта программа основывается на БД сотрудников Компании.
*/
DROP DATABASE IF EXISTS company ;
CREATE DATABASE IF NOT EXISTS company ;
USE company ;
SHOW TABLES;


-- не использую SERIAL тк количество сотрудников не превышает 1000, поэтому INT, а не BEGINT
CREATE TABLE employees (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
  first_name VARCHAR(100) NOT NULL COMMENT 'Имя сотрудника',
  last_name VARCHAR(100) NOT NULL COMMENT 'Фамилия сотрудника',
  birthday DATE NOT NULL COMMENT 'Дата рождения',
  gender ENUM('M','F') NOT NULL COMMENT 'Пол',
  email VARCHAR(100) NOT NULL UNIQUE COMMENT 'Email пользователя',
  affiliate INT UNSIGNED NOT NULL COMMENT 'Филиал сотрудника',
  department INT UNSIGNED NOT NULL COMMENT 'Отдел сотрудника',
  post INT UNSIGNED NOT NULL COMMENT 'Должность сотрудника',
  phone VARCHAR(12) NOT NULL UNIQUE COMMENT 'Мобильный телефон пользователя',
  phone_work INT UNSIGNED NOT NULL COMMENT 'Рабочий телефон пользователя',
  status_in_company ENUM('Active','Dismissed') DEFAULT 'Active' NOT NULL COMMENT 'Статус в компании',
  FOREIGN KEY (affiliate) REFERENCES affiliates(id),
  FOREIGN KEY (department) REFERENCES departments(id),
  FOREIGN KEY (post) REFERENCES posts(id),
  FOREIGN KEY (phone_work) REFERENCES phones(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания строки',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW() DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата изменения строки'
  ) COMMENT 'Таблица сотрудников';
  
  -- ALTER TABLE users DROP CONSTRAINT check_phone; -- Удаление ограничения целостности
  ALTER TABLE employees ADD CONSTRAINT check_home_phone CHECK (REGEXP_LIKE(phone, '^\\+79[0-9]{9}$')); -- пользовательское правило
 
 /* INSERT INTO employees (first_name, last_name, birthday, gender, email, phone)
SELECT first_name, last_name, birthday, gender, email, phone
FROM vk.users ; -- Копирование данных из другой таблицы */

INSERT INTO employees (id, first_name, last_name, birthday, gender, email, affiliate, department, post, phone, phone_work) VALUES 
(1, 'Tyrell', 'Erdman', '1992-02-08', 'M', 'luisa.ruecker@example.com', 1, 1, 1, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 1),
(2, 'Russ', 'Ullrich', '1988-01-11', 'M', 'ppurdy@example.org', 1, 2, 2, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 2),
(3, 'Stephan', 'Nikolaus', '2010-05-26', 'M', 'dakota.bernier@example.com', 1, 2, 16, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 3),
(4, 'Adriana', 'Douglas', '2016-04-18', 'F', 'amira.littel@example.com', 1, 2, 17, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 4),
(5, 'Dario', 'Hettinger', '1991-08-02', 'M', 'd\'amore.halle@example.net', 1, 3, 3, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 5),
(6, 'Virgie', 'Legros', '1998-11-23', 'F', 'eulalia.dubuque@example.net', 1, 3, 22, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 6),
(7, 'Ruth', 'Kling', '1971-07-01', 'M', 'jules.prosacco@example.net', 1, 3, 23, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 7),
(8, 'Brittany', 'Ruecker', '2011-07-27', 'F', 'alva.abernathy@example.com', 1, 3, 24, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 8),
(9, 'Sydni', 'Hudson', '2000-04-28', 'F', 'rey.heller@example.net', 1, 4, 30, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 9),
(10, 'Justyn', 'Blick', '2021-07-27', 'M', 'rowena96@example.org', 1, 4, 31, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 10),
(11, 'Theodora', 'Barrows', '1990-12-20', 'F', 'abshire.helga@example.com', 1, 5, 36, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 11),
(12, 'Andreane', 'Hegmann', '2004-11-25', 'M', 'murphy.amiya@example.org', 1, 5, 37, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 12),
(13, 'Levi', 'Frami', '1997-06-03', 'M', 'golda.stehr@example.net', 1, 4, 4, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 13),
(14, 'Jodie', 'Bogisich', '1970-01-13', 'M', 'peffertz@example.org', 1, 5, 5, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 14),
(15, 'Alphonso', 'Koss', '1995-12-16', 'M', 'harber.renee@example.org', 2, 6, 6, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 15),
(16, 'Zula', 'Paucek', '2009-09-03', 'F', 'dee33@example.net', 2, 7, 7, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 16),
(17, 'Aaliyah', 'Reichert', '1990-05-09', 'F', 'lyla.fadel@example.org', 2, 7, 19, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 17),
(18, 'Rosalinda', 'Torp', '1998-03-06', 'M', 'marisol.koss@example.org', 2, 7, 18, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 18),
(19, 'Aryanna', 'Jacobs', '1972-05-27', 'F', 'oceane30@example.org', 2, 8, 8, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 19),
(20, 'Kyra', 'Gorczany', '2007-10-29', 'F', 'bsteuber@example.com', 2, 8, 25, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 20),
(21, 'Zackery', 'Lynch', '2001-08-25', 'M', 'gilda.pagac@example.org', 2, 8, 26, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 21),
(22, 'Aiden', 'Corkery', '1998-06-27', 'M', 'vdenesik@example.net', 2, 8, 27, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 22),
(23, 'Juana', 'Lehner', '2012-06-07', 'M', 'eweber@example.net', 2, 9, 9, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 23),
(24, 'Mitchell', 'Hettinger', '1983-07-17', 'F', 'ferry.georgianna@example.net', 2, 9, 32, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 24),
(25, 'Leonard', 'Rohan', '1971-03-07', 'F', 'yesenia29@example.net', 2, 9, 33, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 25),
(26, 'Jessica', 'Jerde', '1983-02-18', 'F', 'dicki.camylle@example.net', 2, 10, 10, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 26),
(27, 'Cristina', 'Hahn', '1994-06-03', 'F', 'bernie50@example.net', 2, 10, 38, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 27),
(28, 'Christy', 'Rutherford', '2017-11-08', 'F', 'wisoky.zella@example.com', 2, 10, 39, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 28),
(29, 'Katharina', 'Stroman', '1982-02-02', 'F', 'price.barrett@example.com', 3, 11, 11, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 29),
(30, 'Amelia', 'Streich', '2007-06-08', 'F', 'metz.andy@example.net', 3, 12, 12,  CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 30),
(31, 'Branson', 'Schoen', '2014-12-18', 'F', 'harvey.lisandro@example.net', 3, 12, 21, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 31),
(32, 'Cecil', 'Mertz', '2000-07-02', 'F', 'arno.bailey@example.net', 3, 12, 20, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 32),
(33, 'Jessie', 'Sporer', '1995-03-30', 'M', 'hans88@example.net', 3, 13, 13, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 33),
(34, 'Raheem', 'Wiza', '1981-04-07', 'F', 'jasmin.kulas@example.com', 3, 13, 28, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 34),
(35, 'Stacy', 'Waters', '1998-02-05', 'F', 'boyle.emmett@example.com', 3, 13, 29, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 35),
(36, 'Nels', 'Toy', '1990-06-20', 'M', 'kathryn52@example.org', 3, 14, 14, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 36),
(37, 'Brando', 'West', '1975-03-09', 'F', 'boehm.onie@example.org', 3, 14, 34, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 37),
(38, 'Laurie', 'Parker', '2018-12-25', 'F', 'isac97@example.org', 3, 14, 35, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 38),
(39, 'Lavonne', 'Yundt', '2016-05-01', 'F', 'kamren.kunze@example.com', 3, 14, 42, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 39),
(40, 'Wanda', 'Becker', '1979-10-05', 'F', 'modesta.dubuque@example.org', 3, 15, 15, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 40),
(41, 'Freddie', 'Gottlieb', '1987-08-15', 'F', 'wilson.douglas@example.net', 3, 15, 41, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 41),
(42, 'Hertha', 'Walker', '1977-02-27', 'F', 'aliza.dickinson@example.net', 1, 3, 40, CONCAT('+7', 9000000000 + FLOOR(999999999 * RAND())), 42);

UPDATE employees SET status_in_company = 'Dismissed' WHERE id = 42;
UPDATE employees SET post = 22 WHERE id = 42;

 SELECT * FROM employees;
 
  CREATE TABLE profiles (
  employee_id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Идентификатор строки',
  avatar INT UNSIGNED NOT NULL COMMENT 'Аватар сотрудника',
  city VARCHAR(100) COMMENT 'Город проживания сотрудника',
  country VARCHAR(100) COMMENT 'Страна проживания',
  about_yourself TEXT COMMENT 'Несколько слов в себе',
  FOREIGN KEY (avatar) REFERENCES media(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания строки',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW() DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата изменения строки'
) COMMENT "Таблица профилей сотрудников"; 

ALTER TABLE profiles ADD CONSTRAINT profiles_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id);

INSERT INTO profiles (employee_id, avatar, city, country, about_yourself) VALUES 
(2, 8, 'Benberg', 'Russia', SUBSTR(MD5(RAND()), 1, 10)),
(3, 9, 'East Urban', 'Russia', SUBSTR(MD5(RAND()), 1, 10)),
(4, 10, 'South Vladimir', 'Russia', SUBSTR(MD5(RAND()), 1, 10)),
(5, 11,  'West Mollie', 'Russia', SUBSTR(MD5(RAND()), 1, 10)),
(6, 12, 'Marlenhaven', 'Russia', SUBSTR(MD5(RAND()), 1, 10)),
(7, 13, 'Port Shane', 'Russia', SUBSTR(MD5(RAND()), 1, 10)),
(8, 14, 'New Carsonstad', 'Russia', SUBSTR(MD5(RAND()), 1, 10)),
(9, 15, 'Port Peggie', 'Russia', SUBSTR(MD5(RAND()), 1, 10)),
(10, 16, 'Turnerfort', 'Russia', SUBSTR(MD5(RAND()), 1, 10)),
(11, 17, 'Estaton', 'Russia', SUBSTR(MD5(RAND()), 1, 10)),
(12, 18, 'South Peytonport', 'Russia', SUBSTR(MD5(RAND()), 1, 10)),
(13, 19, 'East Lillian', 'Russia', SUBSTR(MD5(RAND()), 1, 10)),
(14, 20, 'Wilburnmouth', 'Russia', SUBSTR(MD5(RAND()), 1, 10)),
(15, 48, 'South Dangelo', 'Russia', SUBSTR(MD5(RAND()), 1, 10)),
(16, 21, 'Jonesport', 'Spain', SUBSTR(MD5(RAND()), 1, 10)),
(17, 22, 'Carlosmouth', 'Spain', SUBSTR(MD5(RAND()), 1, 10)),
(18, 23, 'Lake Melodymouth', 'Spain', SUBSTR(MD5(RAND()), 1, 10)),
(19, 24, 'Eliasfort', 'Spain', SUBSTR(MD5(RAND()), 1, 10)),
(20, 25, 'New Shayneburgh', 'Spain', SUBSTR(MD5(RAND()), 1, 10)),
(21, 26, 'East Dina', 'Spain', SUBSTR(MD5(RAND()), 1, 10)),
(22, 27, 'East Madelineview', 'Spain', SUBSTR(MD5(RAND()), 1, 10)),
(23, 28, 'Nashton', 'Spain', SUBSTR(MD5(RAND()), 1, 10)),
(24, 29, 'Reillyfurt', 'Spain', SUBSTR(MD5(RAND()), 1, 10)),
(25, 30, 'Kurtisview', 'Spain', SUBSTR(MD5(RAND()), 1, 10)),
(26, 31, 'Christbury', 'Spain', SUBSTR(MD5(RAND()), 1, 10)),
(27, 32, 'Glennachester', 'Spain', SUBSTR(MD5(RAND()), 1, 10)),
(28, 33, 'Stevieborough', 'Spain', SUBSTR(MD5(RAND()), 1, 10)),
(29, 34, 'South Titoland', 'Spain', SUBSTR(MD5(RAND()), 1, 10)),
(30, 35, 'East Nicholeport', 'Italy', SUBSTR(MD5(RAND()), 1, 10)),
(31, 36, 'Heathcoteside', 'Italy', SUBSTR(MD5(RAND()), 1, 10)),
(32, 37, 'Dimitribury', 'Italy', SUBSTR(MD5(RAND()), 1, 10)),
(33, 38, 'Lake Tracestad', 'Italy', SUBSTR(MD5(RAND()), 1, 10)),
(34, 39, 'Lisettestad', 'Italy', SUBSTR(MD5(RAND()), 1, 10)),
(35, 40, 'Kristopherberg', 'Italy', SUBSTR(MD5(RAND()), 1, 10)),
(36, 41, 'Eberttown', 'Italy', SUBSTR(MD5(RAND()), 1, 10)),
(37, 42, 'North Minniestad', 'Italy', SUBSTR(MD5(RAND()), 1, 10)),
(38, 43, 'Samanthaview', 'Italy', SUBSTR(MD5(RAND()), 1, 10)),
(39, 44, 'Elverabury', 'Italy', SUBSTR(MD5(RAND()), 1, 10)),
(40, 45, 'New Johnborough', 'Italy', SUBSTR(MD5(RAND()), 1, 10)),
(41, 46, 'Ebertshire', 'Italy', SUBSTR(MD5(RAND()), 1, 10)),
(42, 47, 'Jocelynport', 'Italy', SUBSTR(MD5(RAND()), 1, 10));

UPDATE profiles SET country = 'Russia' WHERE employee_id = 42;
UPDATE profiles SET country = 'Spain' WHERE employee_id = 15;

SELECT * FROM profiles;

CREATE TABLE affiliates (
  id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Идентификатор строки',
  name_affiliate VARCHAR(100) UNIQUE NOT NULL COMMENT 'Название филиала',
  city VARCHAR(100) NOT NULL COMMENT 'Город филиала',
  country VARCHAR(100) NOT NULL COMMENT 'Страна филиала',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания строки',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW() DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата изменения строки'
) COMMENT "Таблица филиалов компании"; 

INSERT INTO affiliates (id, name_affiliate, city, country) VALUES 
(1,'My Arena','Moscow', 'Russia'),
(2,'Palau Blaugrana','Barcelona', 'Spain'),
(3,'San Siro','Milan', 'Italy');

SELECT * FROM affiliates;

CREATE TABLE departments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
  name_department VARCHAR(100) NOT NULL COMMENT 'Название отдела',
  affiliate_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на филиал',
  responsibility VARCHAR(200) NOT NULL COMMENT 'Обязанности отдела',
  FOREIGN KEY (affiliate_id) REFERENCES affiliates(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания строки',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW() DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата изменения строки'
) COMMENT "Таблица отделов компании";

SHOW CREATE TABLE departments;

ALTER TABLE departments MODIFY name_department VARCHAR(100) NOT NULL COMMENT 'Название отдела';
ALTER TABLE departments DROP INDEX name_department_2;
DESCRIBE departments;

REPLACE INTO departments (id, name_department, affiliate_id, responsibility) VALUES 
(1,'Director',1, 'Управление'),
(2,'Business',1, 'Поиск и привлечение новых бизнес-партнеров'),
(3,'Operations',1, 'Работа с клиентами'),
(4,'Managers',1, 'Работа с бизнес-партнерами'),
(5,'Analytics',1, 'Аналитика данных и процессов'),
(6,'Director',2, 'Управление'),
(7,'Business',2, 'Поиск и привлечение новых бизнес-партнеров'),
(8,'Operations',2, 'Работа с клиентами'),
(9,'Managers',2, 'Работа с бизнес-партнерами'),
(10,'Analytics',2, 'Аналитика данных и процессов'),
(11,'Director',3, 'Управление'),
(12,'Business',3, 'Поиск и привлечение новых бизнес-партнеров'),
(13,'Operations',3, 'Работа с клиентами'),
(14,'Managers',3, 'Работа с бизнес-партнерами'),
(15,'Analytics',3, 'Аналитика данных и процессов');

SELECT * FROM departments;

CREATE TABLE departments_employees (
  department_id INT UNSIGNED NOT NULL COMMENT "ссылка на отдел",
  employee_id INT UNSIGNED NOT NULL COMMENT "ссылка на сотрудника",
  PRIMARY KEY (department_id, employee_id) COMMENT "составной первичный ключ",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW() DEFAULT CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Сообщество по отделам, связь между сотрудниками и отделами";

ALTER TABLE departments_employees ADD CONSTRAINT departments_employees_department_id FOREIGN KEY (department_id) REFERENCES departments(id);
ALTER TABLE departments_employees ADD CONSTRAINT departments_employees_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id);

INSERT INTO departments_employees (department_id, employee_id) VALUES 
(1,1),
(2,2),
(2,16),
(2,17),
(3,3),
(3,22),
(3,23),
(3,24),
(4,4),
(4,30),
(4,31),
(5,5),
(5,36),
(5,37),
(6,6),
(7,7),
(7,18),
(7,19),
(8,8),
(8,25),
(8,26),
(8,27),
(9,9),
(9,32),
(9,33),
(10,10),
(10,38),
(10,39),
(11,11),
(12,12),
(12,20),
(12,21),
(13,13),
(13,28),
(13,29),
(14,14),
(14,34),
(14,35),
(14,42),
(15,15),
(15,40),
(15,41);

SELECT * FROM departments_employees;

CREATE TABLE posts (
  id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Идентификатор строки',
  name_post VARCHAR(100) NOT NULL COMMENT 'Название должности',
  department_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на отдел',
  responsibility VARCHAR(200) NOT NULL COMMENT 'Обязанности должности',
  FOREIGN KEY (department_id) REFERENCES departments(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания строки',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW() DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата изменения строки'
) COMMENT "Таблица должностей компании";

INSERT INTO posts (id, name_post, department_id, responsibility) VALUES 
(1,'Head department',1, 'Начальник отдела'),
(2,'Head department',2, 'Начальник отдела'),
(3,'Head department',3, 'Начальник отдела'),
(4,'Head department',4, 'Начальник отдела'),
(5,'Head department',5, 'Начальник отдела'),
(6,'Head department',6, 'Начальник отдела'),
(7,'Head department',7, 'Начальник отдела'),
(8,'Head department',8, 'Начальник отдела'),
(9,'Head department',9, 'Начальник отдела'),
(10,'Head department',10, 'Начальник отдела'),
(11,'Head department',11, 'Начальник отдела'),
(12,'Head department',12, 'Начальник отдела'),
(13,'Head department',13, 'Начальник отдела'),
(14,'Head department',14, 'Начальник отдела'),
(15,'Head department',15, 'Начальник отдела'),
(16,'Buseness manager',2, 'Повышение доходов Компании'),
(17,'Buseness manager',2, 'Повышение доходов Компании'),
(18,'Buseness manager',7, 'Повышение доходов Компании'),
(19,'Buseness manager',7, 'Повышение доходов Компании'),
(20,'Buseness manager',12, 'Повышение доходов Компании'),
(21,'Buseness manager',12, 'Повышение доходов Компании'),
(22,'Specialist',3, 'Обеспечение клиентского сервиса'),
(23,'Specialist',3, 'Обеспечение клиентского сервиса'),
(24,'Specialist',3, 'Обеспечение клиентского сервиса'),
(25,'Specialist',8, 'Обеспечение клиентского сервиса'),
(26,'Specialist',8, 'Обеспечение клиентского сервиса'),
(27,'Specialist',8, 'Обеспечение клиентского сервиса'),
(28,'Specialist',13, 'Обеспечение клиентского сервиса'),
(29,'Specialist',13, 'Обеспечение клиентского сервиса'),
(30,'Manager',4, 'Поддержка бизнеса'),
(31,'Manager',4, 'Поддержка бизнеса'),
(32,'Manager',9, 'Поддержка бизнеса'),
(33,'Manager',9, 'Поддержка бизнеса'),
(34,'Manager',14, 'Поддержка бизнеса'),
(35,'Manager',14, 'Поддержка бизнеса'),
(36,'Analytic',5, 'Анализ данных и процессов'),
(37,'Analytic',5, 'Анализ данных и процессов'),
(38,'Analytic',10, 'Анализ данных и процессов'),
(39,'Analytic',10, 'Анализ данных и процессов'),
(40,'Analytic',15, 'Анализ данных и процессов'),
(41,'Analytic',15, 'Анализ данных и процессов');

INSERT INTO posts (id, name_post, department_id, responsibility) VALUES 
(42,'Manager',14, 'Поддержка бизнеса');

SELECT * FROM posts;

CREATE TABLE posts_employees (
  post_id INT UNSIGNED NOT NULL COMMENT "ссылка на должность",
  employee_id INT UNSIGNED NOT NULL COMMENT "ссылка на сотрудника",
  PRIMARY KEY (post_id, employee_id) COMMENT "составной первичный ключ",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW() DEFAULT CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Сообщество по должностям, связь между сотрудниками и должностями";

ALTER TABLE posts_employees ADD CONSTRAINT posts_employees_post_id FOREIGN KEY (post_id) REFERENCES posts(id);
ALTER TABLE posts_employees ADD CONSTRAINT posts_employees_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id);
ALTER TABLE posts_employees DROP CONSTRAINT posts_employees_post_id;
ALTER TABLE posts_employees DROP CONSTRAINT posts_employees_employee_id;

DROP TABLE posts_employees;

CREATE TABLE work_groups (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(100) NOT NULL UNIQUE COMMENT "Название группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Рабочие группы над проектом";

INSERT INTO work_groups (id, name) VALUES 
(1,'Новый футболист'),
(2,'Хороший легионер'),
(3,'Просмотр игрока'),
(4,'Поиск финансирования'),
(5,'Анализ статистики Милана'),
(6,'Анализ статистики Реала'),
(7,'В России нет футбола'),
(8,'Как распилить бюджет'),
(9,'Продажа абонементов в Барселоне'),
(10,'Продажа абонементов в Милане');

SELECT * FROM work_groups;

ALTER TABLE work_groups_employees ADD CONSTRAINT work_groups_employees_work_group_id FOREIGN KEY (work_group_id) REFERENCES work_groups(id);
ALTER TABLE work_groups_employees ADD CONSTRAINT work_groups_employees_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id);

CREATE TABLE work_groups_employees (
  work_group_id INT UNSIGNED NOT NULL COMMENT "ссылка на рабочую группу",
  employee_id INT UNSIGNED NOT NULL COMMENT "ссылка на сотрудника",
  PRIMARY KEY (work_group_id, employee_id) COMMENT "составной первичный ключ",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW() DEFAULT CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Участники рабочих групп, связь между сотрудниками и группами";

DESCRIBE work_groups_employees;

INSERT INTO work_groups_employees ( work_group_id, employee_id) VALUES 
(1,FLOOR (1 + RAND() * 41)),
(2,FLOOR (1 + RAND() * 41)),
(3,FLOOR (1 + RAND() * 41)),
(4,FLOOR (1 + RAND() * 41)),
(5,FLOOR (1 + RAND() * 41)),
(6,FLOOR (1 + RAND() * 41)),
(7,FLOOR (1 + RAND() * 41)),
(8,FLOOR (1 + RAND() * 41)),
(9,FLOOR (1 + RAND() * 41)),
(10,FLOOR (1 + RAND() * 41)),
(1,FLOOR (1 + RAND() * 41)),
(2,FLOOR (1 + RAND() * 41)),
(3,FLOOR (1 + RAND() * 41)),
(4,FLOOR (1 + RAND() * 41)),
(5,FLOOR (1 + RAND() * 41)),
(6,FLOOR (1 + RAND() * 41)),
(7,FLOOR (1 + RAND() * 41)),
(8,FLOOR (1 + RAND() * 41)),
(9,FLOOR (1 + RAND() * 41)),
(10,FLOOR (1 + RAND() * 41)),
(1,FLOOR (1 + RAND() * 41)),
(2,FLOOR (1 + RAND() * 41)),
(3,FLOOR (1 + RAND() * 41)),
(4,FLOOR (1 + RAND() * 41)),
(5,FLOOR (1 + RAND() * 41)),
(6,FLOOR (1 + RAND() * 41)),
(7,FLOOR (1 + RAND() * 41)),
(8,FLOOR (1 + RAND() * 41)),
(9,FLOOR (1 + RAND() * 41)),
(10,FLOOR (1 + RAND() * 41));

SELECT * FROM work_groups_employees;

CREATE TABLE hobbies (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(100) NOT NULL UNIQUE COMMENT "Название хобби",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Таблица хобби сотрудников";

INSERT INTO hobbies (id, name) VALUES 
(1,'Футбол'),
(2,'Хоккей'),
(3,'Баскетбол'),
(4,'Теннис'),
(5,'Волейбол'),
(6,'Плавание'),
(7,'Бадминтон'),
(8,'Лапта'),
(9,'Шахматы'),
(10,'Водное поло');
INSERT INTO hobbies (id, name) VALUES (11,'Городки');

SELECT * FROM hobbies;

CREATE TABLE hobbies_employees (
  hobbies_id INT UNSIGNED NOT NULL COMMENT "ссылка на хобби",
  employee_id INT UNSIGNED NOT NULL COMMENT "ссылка на сотрудника",
  PRIMARY KEY (hobbies_id, employee_id) COMMENT "составной первичный ключ",
  FOREIGN KEY (hobbies_id) REFERENCES hobbies(id),
  FOREIGN KEY (employee_id) REFERENCES employees(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW() DEFAULT CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Связь между сотрудниками и их хобби";

DESCRIBE hobbies_employees;
SHOW CREATE TABLE hobbies_employees;
SHOW CREATE TABLE work_groups_employees;

INSERT INTO hobbies_employees (hobbies_id, employee_id) VALUES 
(1,FLOOR (1 + RAND() * 41)),
(2,FLOOR (1 + RAND() * 41)),
(3,FLOOR (1 + RAND() * 41)),
(4,FLOOR (1 + RAND() * 41));
INSERT INTO hobbies_employees (hobbies_id, employee_id) VALUES 
(5,FLOOR (1 + RAND() * 41)),
(6,FLOOR (1 + RAND() * 41)),
(7,FLOOR (1 + RAND() * 41)),
(8,FLOOR (1 + RAND() * 41)),
(9,FLOOR (1 + RAND() * 41)),
(10,FLOOR (1 + RAND() * 41));


SELECT * FROM hobbies_employees;


CREATE TABLE messages (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
 from_employee_id INT UNSIGNED NOT NULL COMMENT 'ссылка на отправителя сообщения',
 to_employee_id INT UNSIGNED NOT NULL COMMENT 'ссылка на получателя сообщения',
 body TEXT NOT NULL COMMENT 'текст сообщения',
 is_important BOOLEAN COMMENT 'признак важности',
 is_delivered BOOLEAN COMMENT 'признак доставки',
 created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'время создания строки',
 updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW() DEFAULT CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT "Сообщения";

ALTER TABLE messages ADD CONSTRAINT messages_from_employee_id FOREIGN KEY (from_employee_id) REFERENCES employees(id);
ALTER TABLE messages ADD CONSTRAINT messages_to_employee_id FOREIGN KEY (to_employee_id) REFERENCES employees(id);

INSERT INTO messages (id, from_employee_id, to_employee_id, body, is_important, is_delivered) VALUES 
(1, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Rem dolor cum at. Vel explicabo qui fugit quas ut facere. Earum et consectetur distinctio illum.', 1, 1),
(2, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Fuga voluptas nihil ut. Similique distinctio molestiae esse omnis sunt eum. Enim neque recusandae praesentium necessitatibus.', 0, 0),
(3, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Unde error occaecati animi labore et nihil. Rerum ad quibusdam et vero voluptatibus eos sed. Modi qui cumque inventore quia excepturi. Voluptate optio omnis voluptas ducimus ullam. Rerum tempora dicta quis optio delectus.', 1, 1),
(4, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Eum in aut impedit fugiat impedit sed. Sit ut est mollitia ducimus libero autem. Voluptas laborum repellat sit aut suscipit et. Voluptatem aspernatur corporis consequatur voluptas velit. Est nihil ut qui dolorum eaque amet voluptas occaecati.', 1, 0),
(5, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Ut impedit sed repudiandae dignissimos ducimus molestiae. Animi molestias non corrupti neque et. Nihil dolor sequi aperiam voluptatem.', 0, 1),
(6, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Tenetur consequuntur aut delectus qui commodi corporis cupiditate. Et possimus et laudantium corrupti. Quia qui non omnis et maiores consectetur. Quia excepturi officia explicabo suscipit voluptates vero.', 0, 0),
(7, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Qui ullam molestiae quas iusto. Vero hic sit sequi ut non molestiae. Sit odit totam qui perferendis saepe est dolorum.', 1, 0),
(8, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Consequatur iusto itaque qui nemo architecto nulla ut ut. Voluptatem repudiandae similique quam consequatur est veritatis velit iusto. Amet occaecati praesentium consequatur aliquid dicta facilis nostrum quia. Minima non dolorem nam quibusdam et impedit quis.', 1, 1),
(9, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Placeat maxime consequatur qui similique dolorem quos veritatis quam. Illum aut molestiae animi voluptatem illo officiis sunt. Suscipit alias quia quisquam officiis consequuntur repudiandae saepe. Tempora maxime eos nesciunt quis expedita voluptas eligendi.', 0, 0),
(10, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Molestiae voluptas libero illum soluta sit. Qui magnam impedit nostrum tempora quibusdam. Ab debitis quia id totam incidunt at laudantium.', 1, 0),
(11, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Quaerat aliquam modi perspiciatis. Laudantium consequatur magni quos ipsum animi unde. Ex ut rerum expedita delectus non. Deleniti blanditiis totam rerum voluptatem quidem minus porro. Est sed facere accusamus maxime nisi pariatur.', 0, 1),
(12, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Sunt laboriosam voluptate asperiores nisi necessitatibus. In dolorem aut saepe quod ut alias. Pariatur quibusdam sint quidem soluta. Ad laudantium sunt ratione et dicta nostrum qui.', 1, 0),
(13, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Delectus aut error et. Laboriosam dolorem laboriosam repudiandae. Adipisci alias provident rem aspernatur non quibusdam aspernatur.', 0, 0),
(14, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Labore ratione enim autem perspiciatis deleniti molestias. Fugit et velit facere perspiciatis sed dolor. Debitis tempora id et porro est odit mollitia. Quia et nihil eveniet aut unde.', 1, 0),
(15, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Tempora vitae rerum sint perspiciatis voluptates temporibus. Voluptatem assumenda ea recusandae amet similique et.', 0, 0),
(16, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Aperiam nostrum voluptatum qui nihil et omnis. Nulla qui consequatur ea placeat nisi labore enim. Qui esse sit laboriosam dolorum.', 1, 1),
(17, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Velit at ipsum eveniet voluptatem aut dolorem qui ipsam. Consequatur repellendus dolorum ipsam sapiente provident consectetur ipsam. Fuga quae corrupti natus quae ut.', 0, 1),
(18, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Autem aliquam laboriosam ex ea eos dicta inventore. At sed cum odio at blanditiis unde necessitatibus. Ea culpa corporis quis laudantium. Ipsam cumque ipsum reprehenderit quia quia.', 0, 1),
(19, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Quis est numquam nihil odio non deleniti sit. Voluptates eaque ducimus assumenda. Culpa corrupti alias alias quas voluptatem aliquam explicabo.', 1, 0),
(20, FLOOR (1 + RAND() * 42), FLOOR (1 + RAND() * 42), 'Similique modi voluptatibus eum quibusdam voluptates enim optio. Ea eos qui sed aperiam. Aperiam repellendus maxime nihil neque vel. Ut aspernatur molestiae ut sed voluptatibus et beatae.', 0, 1);

SELECT * FROM messages;

CREATE TABLE media (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
filename VARCHAR(255) NOT NULL COMMENT "Полный путь к файлу",
media_type_id INT UNSIGNED NOT NULL COMMENT "ссылка на тип файла",
metadata JSON NOT NULL COMMENT "Метаданные файла",
employee_id INT UNSIGNED NOT NULL COMMENT "ссылка на пользователя",
FOREIGN KEY (media_type_id) REFERENCES media_types(id),
FOREIGN KEY (employee_id) REFERENCES employees(id),
created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'время создания строки',
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW() DEFAULT CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT "Медиафайлы";

INSERT INTO media (filename, media_type_id, metadata, employee_id) VALUE
  (CONCAT('https://www.some_server.com/some_directory/', SUBSTR(MD5(RAND()), 1, 10)),
  FLOOR(1 + RAND()*5),
  CONCAT('{"size" : ', FLOOR(1 + RAND() * 1000000), ', "extension" : "JPEG", "resolution" : "', CONCAT_WS('x', FLOOR(100 + RAND() * 1000), FLOOR(100 + RAND() * 1000)), '"}'),
  FLOOR(1 + RAND()*42)),
  (CONCAT('https://www.some_server.com/some_directory/', SUBSTR(MD5(RAND()), 1, 10)),
  FLOOR(1 + RAND()*5),
  CONCAT('{"size" : ', FLOOR(1 + RAND() * 1000000), ', "extension" : "JPEG", "resolution" : "', CONCAT_WS('x', FLOOR(100 + RAND() * 1000), FLOOR(100 + RAND() * 1000)), '"}'),
  FLOOR(1 + RAND()*42)); -- вСТАВКА МЕДИАФАЙЛОВ
  
  INSERT INTO media (filename, media_type_id, metadata, employee_id) VALUE
  (CONCAT('https://www.some_server.com/some_directory/', SUBSTR(MD5(RAND()), 1, 10)),
  2,
  CONCAT('{"size" : ', FLOOR(1 + RAND() * 1000000), ', "extension" : "JPEG", "resolution" : "', CONCAT_WS('x', FLOOR(100 + RAND() * 1000), FLOOR(100 + RAND() * 1000)), '"}'),
  41),
  (CONCAT('https://www.some_server.com/some_directory/', SUBSTR(MD5(RAND()), 1, 10)),
  2,
  CONCAT('{"size" : ', FLOOR(1 + RAND() * 1000000), ', "extension" : "JPEG", "resolution" : "', CONCAT_WS('x', FLOOR(100 + RAND() * 1000), FLOOR(100 + RAND() * 1000)), '"}'),
  42),
  (CONCAT('https://www.some_server.com/some_directory/', SUBSTR(MD5(RAND()), 1, 10)),
  2,
  CONCAT('{"size" : ', FLOOR(1 + RAND() * 1000000), ', "extension" : "JPEG", "resolution" : "', CONCAT_WS('x', FLOOR(100 + RAND() * 1000), FLOOR(100 + RAND() * 1000)), '"}'),
 8),
  (CONCAT('https://www.some_server.com/some_directory/', SUBSTR(MD5(RAND()), 1, 10)),
  2,
  CONCAT('{"size" : ', FLOOR(1 + RAND() * 1000000), ', "extension" : "JPEG", "resolution" : "', CONCAT_WS('x', FLOOR(100 + RAND() * 1000), FLOOR(100 + RAND() * 1000)), '"}'),
  15)
  
  
  ; -- вСТАВКА аватар

SELECT * FROM media;

--  SELECT SUBSTR(MD5(RAND()),1, 10);
-- SELECT CONCAT('https://www.some_server.com/some_directory/', SUBSTR(MD5(RAND()), 1, 10));

SELECT metadata->"$.size" FROM media WHERE id = 1;

UPDATE media SET filename = CONCAT_WS(',', filename, metadata->"$.extension")
WHERE id > 1;
UPDATE media SET filename = CONCAT('https://www.some_server.com/some_directory/', SUBSTR(MD5(RAND()), 1, 10))
WHERE id = 2;

CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name_type VARCHAR(150) NOT NULL UNIQUE COMMENT "Название типа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW() DEFAULT CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Типы медиафайлов";

ALTER TABLE media_types RENAME COLUMN name TO name_type;

INSERT INTO media_types (id, name_type) VALUES 
(1,'audio'),
(2,'image'),
(3,'video'),
(4,'gif'),
(5,'document');

UPDATE media_types SET name = 'audio' WHERE id = 1;
UPDATE media_types SET name = 'image' WHERE id = 2;
UPDATE media_types SET name = 'video' WHERE id = 3;
UPDATE media_types SET name = 'gif' WHERE id = 4;
UPDATE media_types SET name = 'document' WHERE id = 5;

SELECT * FROM media_types;

CREATE TABLE phones (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  affiliate_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на филиал',
  phone VARCHAR(12) NOT NULL UNIQUE COMMENT 'Мобильный телефон пользователя',
  FOREIGN KEY (affiliate_id) REFERENCES affiliates(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW() DEFAULT CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Список телефонных номеров";

-- SELECT CONCAT ('+7', 9000000000 + FLOOR(999999999 * RAND()));
-- SELECT REGEXP_LIKE(CONCAT ('+7', 9000000000 + FLOOR(999999999 * RAND())), '^\\+7[0-9]{10}$');

-- UPDATE users SET phone = CONCAT ('+7', 9000000000 + FLOOR(999999999 * RAND())) WHERE id<200;


INSERT INTO phones (id, affiliate_id, phone) VALUES 
(5,1, CONCAT('+749', 50000000 + FLOOR(9999999 * RAND()))),
(6,1, CONCAT('+749', 50000000 + FLOOR(9999999 * RAND()))),
(7,1, CONCAT('+749', 50000000 + FLOOR(9999999 * RAND()))),
(8,1, CONCAT('+749', 50000000 + FLOOR(9999999 * RAND()))),
(9,1, CONCAT('+749', 50000000 + FLOOR(9999999 * RAND()))),
(10,1, CONCAT('+749', 50000000 + FLOOR(9999999 * RAND()))),
(12,1, CONCAT('+749', 50000000 + FLOOR(9999999 * RAND()))),
(13,1, CONCAT('+749', 50000000 + FLOOR(9999999 * RAND()))),
(14,1, CONCAT('+749', 50000000 + FLOOR(9999999 * RAND())));

INSERT INTO phones (id, affiliate_id, phone) VALUES 
(15,2, CONCAT('+349', 30000000 + FLOOR(9999999 * RAND()))),
(16,2, CONCAT('+349', 30000000 + FLOOR(9999999 * RAND()))),
(17,2, CONCAT('+349', 30000000 + FLOOR(9999999 * RAND()))),
(18,2, CONCAT('+349', 30000000 + FLOOR(9999999 * RAND()))),
(19,2, CONCAT('+349', 30000000 + FLOOR(9999999 * RAND()))),
(20,2, CONCAT('+349', 30000000 + FLOOR(9999999 * RAND()))),
(21,2, CONCAT('+349', 30000000 + FLOOR(9999999 * RAND()))),
(22,2, CONCAT('+349', 30000000 + FLOOR(9999999 * RAND()))),
(23,2, CONCAT('+349', 30000000 + FLOOR(9999999 * RAND()))),
(24,2, CONCAT('+349', 30000000 + FLOOR(9999999 * RAND()))),
(25,2, CONCAT('+349', 30000000 + FLOOR(9999999 * RAND()))),
(26,2, CONCAT('+349', 30000000 + FLOOR(9999999 * RAND()))),
(27,2, CONCAT('+349', 30000000 + FLOOR(9999999 * RAND()))),
(28,2, CONCAT('+349', 30000000 + FLOOR(9999999 * RAND())));
INSERT INTO phones (id, affiliate_id, phone) VALUES 
(29,3, CONCAT('+39', 200000000 + FLOOR(99999999 * RAND()))),
(30,3, CONCAT('+39', 200000000 + FLOOR(99999999 * RAND()))),
(31,3, CONCAT('+39', 200000000 + FLOOR(99999999 * RAND()))),
(32,3, CONCAT('+39', 200000000 + FLOOR(99999999 * RAND()))),
(33,3, CONCAT('+39', 200000000 + FLOOR(99999999 * RAND()))),
(34,3, CONCAT('+39', 200000000 + FLOOR(99999999 * RAND()))),
(35,3, CONCAT('+39', 200000000 + FLOOR(99999999 * RAND()))),
(36,3, CONCAT('+39', 200000000 + FLOOR(99999999 * RAND()))),
(37,3, CONCAT('+39', 200000000 + FLOOR(99999999 * RAND()))),
(38,3, CONCAT('+39', 200000000 + FLOOR(99999999 * RAND()))),
(39,3, CONCAT('+39', 200000000 + FLOOR(99999999 * RAND()))),
(40,3, CONCAT('+39', 200000000 + FLOOR(99999999 * RAND()))),
(41,3, CONCAT('+39', 200000000 + FLOOR(99999999 * RAND())));

INSERT INTO phones (id, affiliate_id, phone) VALUES
(42,1, CONCAT('+749', 50000000 + FLOOR(9999999 * RAND())));

-- UPDATE phones SET phone = CONCAT ('+7', 9000000000 + FLOOR(999999999 * RAND())) WHERE id<200;

SELECT * FROM phones;

-- DELETE FROM phones WHERE id = 3;

ALTER TABLE phones DROP CONSTRAINT check_phone;
ALTER TABLE phones ADD CONSTRAINT check_phone CHECK (REGEXP_LIKE(phone, '^\\+7495[0-9]{7}$')); -- проверка номера телефона для Москвы