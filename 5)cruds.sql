-- CRUDы

-- ТАБЛИЦА COURTROOMS

-- Вставка данных в таблицу Courtrooms
INSERT INTO court.Courtrooms (room_no, floor, capacity) VALUES (101, 1, 50), (102, 2, 75);

-- Выбор данных из таблицы Courtrooms
SELECT room_no, capacity FROM court.Courtrooms;

-- Обновление данных в таблице Courtrooms
UPDATE court.Courtrooms SET capacity = 60 WHERE room_no = 101;

-- Удаление данных из таблицы Courtrooms
DELETE FROM court.Courtrooms WHERE room_no = 102;


-- ТАБЛИЦА PEOPLE

-- Вставка данных в таблицу People
INSERT INTO court.People (taxpayer_id, first_name, last_name, passport_series, passport_number, birth_date, phone_number, home_address)
VALUES (123456789012, 'Иван', 'Иванов', 1234, 567890, '1990-01-01', '+7 123-456-7890', 'г. Москва, ул. Пушкина, д. 10');

-- Выбор данных из таблицы People
SELECT * FROM court.People;

-- Обновление данных в таблице People
UPDATE court.People SET phone_number = '+7 987-654-3210' WHERE taxpayer_id = 123456789012;

-- Удаление данных из таблицы People
DELETE FROM court.People WHERE taxpayer_id = 123456789012;

