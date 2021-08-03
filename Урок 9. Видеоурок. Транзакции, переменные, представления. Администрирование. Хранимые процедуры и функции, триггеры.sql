-- PRACTICE TASK ON THE TOPIC "TRANSACTION, VALUES, PRESENTATION"


-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
use sample;

start transaction;
insert into sample.users select * from shop.users where id = 1;

select * from users;

-- Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.
create view new_presentation (name_from_products, name_from_catalogs) as 
select name from products 
left join catalogs
on name.products = name.catalogs;

select * from new_presentation;

drop view new_presentation;

-- (по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

use mysql_videotasks;

SELECT * FROM accounts ORDER BY created_at Asc; -- узнаем даты по возрастанию.

DELETE FROM accounts 
WHERE created_at NOT IN (
	SELECT * FROM accounts ORDER BY created_at ASC
	LIMIT 5
	);

SELECT * FROM accounts ORDER BY created_at DESC;


-- PRACTICE TASK ABOUT "STORED PROCEDURES AND FUNCTIONS, TRIGGERS"


--  Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
drop function if exists hello();
DELIMITER //
CREATE FUNCTION hello()
DECLARE @hour int;
SET @hour = HOUR(now());
CASE
WHEN @hour BETWEEN 6 AND 11 THEN RETURN 'Dobroe utro';
WHEN @hour BETWEEN 12 AND 17 THEN RETURN 'Dobryi den';
WHEN @hour BETWEEN 18 AND 23 THEN RETURN 'Dobryi vecher';
WHEN @hour BETWEEN 0 AND 5 THEN RETURN 'Dobroi nochi';
END CASE;
END//

DELIMITER ;

SELECT HOUR(now()), hello();

-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.
DELIMITER //

CREATE TRIGGER new_trigger BEFORE INSERT ON PRODUCTS
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		DROP TRIGGER new_trigger;	
	END IF;
	SET NEW.name = COALESCE(NEW.name,OLD.name);
	SET NEW.description = COALESCE(NEW.description,OLD.description);
END//

--(по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.