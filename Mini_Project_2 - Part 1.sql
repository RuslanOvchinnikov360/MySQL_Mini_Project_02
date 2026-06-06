/*███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
												      МИНИ ПРОЕКТ 2
  ███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████*/

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Задание №1
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*
Создайте в MySQL новую базу данных miniproject1. После этого создайте в ней таблицу users (данные загружаем из файла Users_db.sql).
После создания базы данных и таблицы, выполните следующие задания:
1.	Напишите запрос SQL, выводящий одним числом количество уникальных пользователей в этой таблице в период с 2023-11-07 по 2023-11-15.
2.	Определите пользователя, который за весь период посмотрел наибольшее количество объявлений. 
3.	Определите день с наибольшим средним количеством просмотренных рекламных объявлений на пользователя, но учитывайте только дни с более чем 500 уникальными пользователями.
4.	Напишите запрос возвращающий LT (продолжительность присутствия пользователя на сайте) по каждому пользователю. Отсортировать LT по убыванию.
5.	Для каждого пользователя подсчитайте среднее количество просмотренной рекламы за день, а затем выясните, у кого самый высокий средний показатель среди тех, кто был активен как минимум в 5 разных дней.
*/
USE miniproject1;

SELECT COUNT(DISTINCT user_id) AS Unique_users FROM users
WHERE `date` BETWEEN '2023-11-07' AND '2023-11-15'; -- 1 DONE

SELECT user_id, SUM(view_adverts) AS Total_views FROM users
GROUP BY user_id
ORDER BY Total_views DESC
LIMIT 1; -- 2 DONE

SELECT `date`, ROUND(AVG(User_daily_views) , 2) AS AVG_views_per_user FROM (
SELECT `date`, user_id, SUM(view_adverts) AS User_daily_views FROM users
GROUP BY user_id, `date`) temp_daily_user_stats
GROUP BY `date`
HAVING COUNT(*) > 500 -- = потому что во вложенном запросе одна строка = один пользователь в один день.
ORDER BY AVG_views_per_user DESC
LIMIT 1; -- 3 DONE

SELECT user_id, COUNT(DISTINCT(date)) AS LT
FROM users
GROUP BY user_id
ORDER BY LT DESC; -- 4 DONE

SELECT user_id, ROUND(AVG(Daily_views) , 2) AS AVG_views_per_day FROM 
(SELECT `date`, user_id, SUM(view_adverts) AS Daily_views FROM users
GROUP BY user_id, `date`) temp_daily_stats
GROUP BY user_id
HAVING COUNT(*) >= 5
ORDER BY AVG_views_per_day DESC
LIMIT 1; -- 5 DONE

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Задание №2
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*
Создайте новую базу данных mini_project. В этой базе данных будут 2 таблицы:
1)     T_TAB1 – товары с описанием (тип товара, кол-во, сумма и продавец)
2)     T_TAB2 – имена сотрудников, их возраст и заработная плата

Структура и тип данных в каждой таблице выглядят следующим образом (строки в таблицы нужно добавить запросом):
T_TAB1
	ID (INT, UNIQUE) – уникальный идентификатор
	GOODS_TYPE (VARCHAR) – тип проданного товара
	QUANTITY (INT) – количество проданного товара
	AMOUNT (INT) – суммарная стоимость товара
	SELLER_NAME (VARCHAR) – имя продавца
    
Строки в T_TAB1
SELECT * FROM T_TAB1
+----+--------------+----------+--------+-------------+
| ID | GOODS_TYPE   | QUANTITY | AMOUNT | SELLER_NAME |
+----+--------------+----------+--------+-------------+
|  1 | MOBILE PHONE |        2 | 400000 | MIKE        |
|  2 | KEYBOARD     |        1 |  10000 | MIKE        |
|  3 | MOBILE PHONE |        1 |  50000 | JANE        |
|  4 | MONITOR      |        1 | 110000 | JOE         |
|  5 | MONITOR      |        2 |  80000 | JANE        |
|  6 | MOBILE PHONE |        1 | 130000 | JOE         |
|  7 | MOBILE PHONE |        1 |  60000 | ANNA        |
|  8 | PRINTER      |        1 |  90000 | ANNA        |
|  9 | KEYBOARD     |        2 |  10000 | ANNA        |
| 10 | PRINTER      |        1 |  80000 | MIKE        |
+----+--------------+----------+--------+-------------+

T_TAB2
	ID (INT, UNIQUE) – уникальный идентификатор
	NAME (VARCHAR) – имя сотрудника
	SALARY (INT) – зарплата сотрудника
	AGE (INT) – возраст сотрудника

Строки в T_TAB1
SELECT * FROM T_TAB2
+----+------+--------+-----+
| ID | NAME | SALARY | AGE |
+----+------+--------+-----+
|  1 | ANNA | 110000 |  27 |
|  2 | JANE |  80000 |  25 |
|  3 | MIKE | 120000 |  25 |
|  4 | JOE  |  70000 |  24 |
|  5 | RITA | 120000 |  29 |
+----+------+--------+-----+

Подсказка: T_TAB1.SELLER_NAME = T_TAB2.NAME

10.	Сколько строк вернёт следующий запрос:
	SELECT * FROM T_TAB1 t
	JOIN T_TAB2 t2 ON t2.name = t.seller_name
	WHERE t2.name = 'RITA';
*/
CREATE DATABASE mini_project;
USE mini_project;
CREATE TABLE T_TAB1 (
    Product_id INT PRIMARY KEY,
    Goods_type VARCHAR (100) NOT NULL,
    Quantity INT NOT NULL,
    Amount INT NOT NULL,
    Seller_name VARCHAR (100) NOT NULL);
INSERT INTO
T_TAB1 (Product_id, Goods_type, Quantity, Amount, Seller_name)
VALUES
(1, 'Mobile phone', 2, 400000, 'Mike'),
(2, 'Keyboard', 1, 10000, 'Mike'),
(3, 'Mobile phone', 1, 50000, 'Jane'),
(4, 'Monitor', 1, 110000, 'Joe'),
(5, 'Monitor', 2, 80000, 'Jane'),
(6, 'Mobile phone', 1, 130000, 'Joe'),
(7, 'Mobile phone', 1, 60000, 'Anna'),
(8, 'Printer', 1, 90000, 'Anna'),
(9, 'Keyboard', 2, 10000, 'Anna'),
(10, 'Printer', 1, 80000, 'Mike');

CREATE TABLE T_TAB2 (
    emp_id INT PRIMARY KEY,
    `Name` VARCHAR(100) NOT NULL,
    Salary INT NOT NULL,
    Age INT NOT NULL);
INSERT INTO T_TAB2 (emp_id, `Name`, Salary, Age) VALUES
(1, 'Anna', 110000, 27),
(2, 'Jane', 80000, 25),
(3, 'Mike', 120000, 25),
(4, 'Joe', 70000, 24),
(5, 'Rita', 120000, 29);

SELECT * FROM T_TAB1;
SELECT * FROM T_TAB2;

# 1.	Напишите запрос, который вернёт список уникальных категорий товаров (GOODS_TYPE). Какое количество уникальных категорий товаров вернёт запрос?
SELECT DISTINCT Goods_type FROM T_TAB1; -- Перечень уникальных товаров
SELECT COUNT(DISTINCT Goods_type) AS Unique_goods_no FROM T_TAB1; -- Всего 4 уникальных товара

# 2.	Напишите запрос, который вернет суммарное количество и суммарную стоимость проданных мобильных телефонов. Какое суммарное количество и суммарную стоимость вернул запрос?
SELECT
    SUM(quantity) AS Total_quantity,
    SUM(amount) AS Total_amount
FROM T_TAB1
WHERE goods_type = 'mobile phone'; -- Запрос вернул суммарную стоимость мобильных телефонов - '640000', суммарное количество - 5.

# 3.	Напишите запрос, который вернёт список сотрудников с заработной платой > 100000. Какое кол-во сотрудников вернул запрос?
SELECT * FROM T_TAB2
WHERE Salary > 100000; -- Запрос вернул 3 сотрудников

# 4.	Напишите запрос, который вернёт минимальный и максимальный возраст сотрудников, а также минимальную и максимальную заработную плату.
SELECT MAX(age) AS MAX_Age, MIN(age) AS MIN_Age, MAX(Salary) AS MAX_Salary, MIN(Salary) AS MIN_Salary FROM T_TAB2;

# 5.	Напишите запрос, который вернёт среднее количество проданных клавиатур и принтеров.
SELECT goods_type, AVG(quantity) AS AVG_quantity
FROM T_TAB1
WHERE goods_type IN ('printer', 'keyboard')
GROUP BY goods_type;

# 6.	Напишите запрос, который вернёт имя сотрудника и суммарную стоимость проданных им товаров.
SELECT Seller_name, SUM(Amount) AS Amount_by_Seller FROM T_TAB1
GROUP BY Seller_name;

# 7.	Напишите запрос, который вернёт имя сотрудника, тип товара, кол-во товара, стоимость товара, заработную плату и возраст сотрудника MIKE.
SELECT t1.Seller_name, t1.Goods_type, t1.Quantity, t1.Amount, t2.Salary, t2.Age FROM T_TAB1 t1
JOIN T_TAB2 t2
ON t1.Seller_name = t2.name
WHERE t1.Seller_name = 'Mike';

# 8.	Напишите запрос, который вернёт имя и возраст сотрудника, который ничего не продал. Сколько таких сотрудников?
SELECT t2.Name, t2.Age FROM T_TAB1 t1
RIGHT JOIN T_TAB2 t2
ON t1.Seller_name = t2.name
WHERE t1.Product_id IS NULL; -- Один сотрудник

# 9.	Напишите запрос, который вернёт имя сотрудника и его заработную плату с возрастом меньше 26 лет? Какое количество строк вернул запрос?
SELECT `Name`, Age FROM T_TAB2
WHERE Age < 26; -- Запрос вернул 3 строки

# 10.	Сколько строк вернёт следующий запрос:
	SELECT * FROM T_TAB1 t
	JOIN T_TAB2 t2 ON t2.name = t.seller_name
	WHERE t2.name = 'RITA'; -- Запрос ничего не вернул, так как Рита не совершила продаж

