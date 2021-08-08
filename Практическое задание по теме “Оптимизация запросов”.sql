-- Практическое задание по теме “Оптимизация запросов”

-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME NOT NULL,
	table_name VARCHAR(50) NOT NULL,
	table_id INT UNSIGNED NOT NULL,
	`name` VARCHAR(50) NOT NULL
) ENGINE = ARCHIVE;

DROP TRIGGER IF EXISTS log_users;
delimiter //
CREATE TRIGGER log_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, table_id, `name`)
	VALUES (NOW(), 'users', NEW.id, NEW.name);
END //
delimiter ;

DROP TRIGGER IF EXISTS watchlog_catalogs;
delimiter //
CREATE TRIGGER log_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, table_id, `name`)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END //
delimiter ;

delimiter //
CREATE TRIGGER log_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, table_id, `name`)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END //
delimiter ;

-- (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.


-- Практическое задание по теме “NoSQL”

-- В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

redis-cli

SADD ipadd 172.265.17.89 156.267.14.458

expire ipadd 60

exit

-- При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.

redis-cli

set Egor EGOR@mail.ru

set EGOR@mail.ru Egor

get Egor

get EGOR@mail.ru

exit 

-- Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.

ps aux | grep mongod -- убедиться что сервер mongodb работает

mongo

use shop

db.shop.insert({category: ''})

db.shop.insert({value products: ''})

db.shop.find()

db.shop.drop()
