-- Создание схемы
DROP SCHEMA IF EXISTS court CASCADE;
     CREATE SCHEMA court;
SET search_path = court, public;


-- Таблица Courtrooms
DROP TABLE IF EXISTS Courtrooms cascade;
CREATE TABLE court.Courtrooms (
    room_no INTEGER PRIMARY KEY,
    floor INTEGER NOT NULL CHECK (floor BETWEEN 1 AND 6),
    capacity INTEGER NOT NULL CHECK (capacity > 0)
);

-- Таблица Cases
DROP TABLE IF EXISTS Cases cascade;
CREATE TABLE court.Cases (
    case_id INTEGER,
    article TEXT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE,
    status TEXT,
    CONSTRAINT pk_cases PRIMARY KEY (case_id, from_date),
    CONSTRAINT chk_to_date CHECK (to_date IS NULL OR to_date >= from_date)
);

-- Таблица Meetings
DROP TABLE IF EXISTS Meetings cascade;
CREATE TABLE court.Meetings (
    meeting_no INTEGER PRIMARY KEY,
    room_no INTEGER NOT NULL,
    case_id INTEGER NOT NULL,
    meeting_date DATE NOT NULL,
    meeting_time TIME NOT NULL,
    judge_id TEXT NOT NULL,
    court_decision TEXT NOT NULL,
    CONSTRAINT fk_meetings_room FOREIGN KEY (room_no) REFERENCES court.Courtrooms(room_no)
);

-- Таблица People
DROP TABLE IF EXISTS People cascade;
CREATE TABLE court.People (
    taxpayer_id TEXT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    passport_series NUMERIC(4, 0) NOT NULL,
    passport_number NUMERIC(6, 0) NOT NULL,
    birth_date DATE,
    phone_number VARCHAR(20) CHECK (phone_number ~ '^((8|\+7)[\- ]?)?(\(?\d{3}\)?[\- ]?)?[\d\- ]{7,10}$'),
    home_address TEXT,
    CONSTRAINT chk_birth_date CHECK (birth_date IS NULL OR birth_date <= CURRENT_DATE)
);

-- Таблица Companies
DROP TABLE IF EXISTS Companies cascade;
CREATE TABLE court.Companies (
    taxpayer_id TEXT PRIMARY KEY,
    name_of_comp TEXT NOT NULL,
    email TEXT NOT NULL,
    legal_address TEXT NOT NULL
);


-- Таблица Roles
DROP TABLE IF EXISTS Roles cascade;
CREATE TABLE court.Roles (
    taxpayer_id TEXT NOT NULL,
    case_id INTEGER NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('Судья', 'Адвокат истца', 'Прокурор', 'Адвокат подсудимого', 'Присяжный', 'Подсудимый', 'Истец')),
    CONSTRAINT pk_roles PRIMARY KEY (taxpayer_id, case_id)
);




-- Таблица Docs
DROP TABLE IF EXISTS Docs cascade;
CREATE TABLE court.Docs (
    doc_id INTEGER PRIMARY KEY,
    case_id INTEGER NOT NULL,
    date DATE,
    type TEXT NOT NULL
);

-- Вставим данные
INSERT INTO court.Courtrooms (room_no, floor, capacity) VALUES
(1, 1, 50),
(2, 1, 30),
(3, 2, 40),
(4, 2, 25),
(5, 3, 35);

-- все совпадения с реальными людьми случайны
INSERT INTO court.People (taxpayer_id, first_name, last_name, passport_series, passport_number, birth_date, phone_number, home_address) VALUES
('123456789075', 'Аяз', 'Шабутдинов', 1234, 567890, '1990-01-01', '89123456789', 'г. Санкт-Петербург, ул. Пушкина, д.1'),
('987654321023', 'Алексей', 'Овальный', 5678, 123456, '1985-05-15', '89234567890', 'г. Санкт-Петербург, ул. Ломоносова, д.5'),
('112233445588', 'Дональд', 'Трамп', 9999, 987654, '1978-10-20', '+79011223344', 'г. Санкт-Петербург, ул. Кирова, д.10'),
('123456234098', 'Юлия', 'Блинковская', 1200, 562290, '1990-03-01', '+79129956789', 'г. Санкт-Петербург, ул. Пятничная, д.13'),
('287651121033', 'Владимир', 'Утин', 5644, 123836, '1949-05-19', '8-926-656-78-90', 'г. Санкт-Петербург, ул. Кремлевская, д.1'),
('987651667784', 'Фрэнк', 'Каупервуд', 5908, 120346, '1965-07-19', '8-926-699-78-50', 'г. Санкт-Петербург, ул. Мегадорогая, д.111'),
('987651111144', 'Эркюль', 'Пуаро', 3608, 125546, '1980-10-14', '+79266997777', 'г. Санкт-Петербург, Морской пр., д.77'),
('987654993364', 'Евгений', 'Сафроненко', 5623, 120056, '1995-09-15', '+79494567890', 'г. Санкт-Петербург, Московский пр., д.5'),
('123456234056', 'Александр', 'Храбров', 3600, 567770, '1980-10-10', '+79129966666', 'г. Санкт-Петербург, ул. Веселая, д.3'),
('112233445554', 'Ольга', 'Симарова', 6699, 557655, '1994-12-29', '+79008893344', 'г. Санкт-Петербург, ул. Кирова, д.10'),
('112233000058', 'Агата', 'Кристи', 1111, 586754, '1968-06-28', '+79221223349', 'г. Санкт-Петербург, ул. Адмирала Неймана, д.108'),
('112233446613', 'Сол', 'Гудман', 9911, 984654, '1978-09-20', '+79011222844', 'г. Санкт-Петербург, ул. Буша, д.228');

INSERT INTO court.Cases (case_id, article, from_date, to_date, status) VALUES
(1, '228 УК', '2022-11-01', '2022-11-21', 'На рассмотрении'),
(1, '228 УК', '2022-11-21', '2023-01-01', 'Назначено заседание'),
(1, '228 УК', '2023-01-01', '2023-02-01', 'Вынесен акт'),
(4, '227 УК', '2023-04-01', '2023-05-06', 'На рассмотрении'),
(10, '123 УК', '2023-03-05', '2023-04-05', 'На рассмотрении'),
(10, '123 УК', '2023-04-05', '2023-04-10', 'Возвращено отправителю'),
(2, '337 КоАП', '2023-02-01', '2023-02-23', 'На рассмотрении'),
(2, '337 КоАП', '2023-02-23', '2023-04-24', 'Назначено заседание'),
(2, '337 КоАП', '2023-04-24', NULL, 'Вынесен акт'),
(1, '228 УК', '2023-02-01', '2023-02-10', 'Обжалуется'),
(1, '228 УК', '2023-02-10', '2023-02-19', 'Назначено заседание'),
(10, '123 УК', '2023-04-10', '2023-04-23', 'Повторное рассмотрение'),
(4, '227 УК', '2023-05-06', '2023-05-25', 'Назначено заседание'),
(10, '123 УК', '2023-04-23', '2023-05-11', 'Назначено заседание'),
(10, '123 УК', '2023-05-11', NULL, 'Вынесен акт'),
(1, '228 УК', '2023-02-19', NULL, 'Вынесен акт'),
(4, '227 УК', '2023-05-25', '2023-06-19', 'Вынесен акт'),
(4, '227 УК', '2023-06-19', NULL, 'Обжалуется');

INSERT INTO court.Companies (taxpayer_id, name_of_comp, email, legal_address) VALUES
('5555555555', 'ООО "Трио"', 'info@legalfirm.com', 'г. Санкт-Петербург, ул. Лесная, д.20'),
('6666666666', 'ЗАО "Зеленоглазое такси"', 'info@accounting.com', 'г. Санкт-Петербург, пр. Невский, д.15'),
('2345678901', 'ЗАО "Артемида-Технологии"', 'artemida@email.com', 'г. Санкт-Петербург, пр. Римского-Корсакова, д. 51'),
('3456789012', 'ЗАО "Созвездие Идей"', 'sozvezdie@email.com', 'г. Кронштадт, ул. Фортовая, д. 78'),
('4567890123', 'ООО "Панды"', 'panda@email.com', 'г. Санкт-Петербург, ул. Тютчева, д. 888'),
('1234567890', 'ООО "Мамины бизнесмены"', 'info@mama_ya_businessman.com', 'г. Санкт-Петербург, пр. Вознесенский, д.30');


INSERT INTO court.Roles (taxpayer_id, case_id, role) VALUES
('287651121033', 1, 'Судья'),
('987651667784', 1, 'Судья'),
('987654321023', 1, 'Подсудимый'),
('987651111144', 1, 'Адвокат истца'),
('112233446613', 1, 'Адвокат подсудимого'),
('123456234056', 1, 'Истец'),
('5555555555', 4, 'Подсудимый'),
('287651121033', 4, 'Судья'),
('123456234056', 4, 'Истец'),
('987654993364', 4, 'Истец'),
('112233445554', 4, 'Прокурор'),
('112233000058', 10, 'Судья'),
('112233445588', 10, 'Подсудимый'),
('123456789075', 10, 'Истец'),
('112233445588', 2, 'Подсудимый'),
('6666666666', 2, 'Истец'),
('987651111144', 2, 'Судья');



INSERT INTO court.Meetings (meeting_no, room_no, case_id, meeting_date, meeting_time, judge_id, court_decision) VALUES
(1, 1, 1, '2023-02-01', '10:00', '287651121033', '5 лет колонии строго режима'),
(2, 4, 1, '2023-02-19', '12:00', '987651667784', '2 года колонии общего режима и штраф в размере 500 тыс. руб.'),
(3, 2, 2, '2023-04-24', '14:30', '987651111144', 'Штраф в размере 50 тыс. руб.'),
(4, 3, 10, '2023-05-11', '11:00', '112233000058', 'Подсудимый оправдан'),
(5, 3, 4, '2023-05-25', '15:00', '287651121033', '3 года колонии особого режима');

INSERT INTO court.Docs (doc_id, case_id, date, type) VALUES
(1, 1, '2023-01-10', 'Ходатайство'),
(2, 2, '2023-02-15', 'Справка'),
(3, 4, NULL, 'Письмо'),
(4, 10, '2022-12-07', 'Договор'),
(5, 10, '2023-03-20', 'Заключение эксперта');


-- CRUDы
INSERT INTO court.Roles (taxpayer_id, case_id, role) VALUES
('123456234098', 2, 'Присяжный'),
('987651667784', 2, 'Присяжный'),
('112233446613', 2, 'Адвокат истца');

SELECT taxpayer_id FROM court.Roles
where role = 'Истец'
group by taxpayer_id;

UPDATE court.Companies
SET email = 'arttech@email.com'
WHERE taxpayer_id = '3456789012';

DELETE FROM court.Companies
WHERE taxpayer_id = '1234567890';

-- Смысловые запросы

-- 1) Группировка по ролям и подсчет числа участников в каждой роли с условием, что их > 2.
SELECT role, COUNT(DISTINCT taxpayer_id) as participants_count
FROM court.Roles
GROUP BY role
HAVING COUNT(taxpayer_id) > 2;
-- Ожидание от запроса: выведутся те роли, участников, имеющих которые, не меньше 3.
-- Согласно списку инсертов это будут судья, истец и подсудимый.
-- Очевидно, некоторые люди участвовали в одинаковой роли в разных делах, поэтому эти повторы мы убираем

-- 2) список компаний и количество дел, в которых они участвуют
SELECT Companies.name_of_comp, COUNT(DISTINCT Roles.case_id) AS case_count
FROM court.Companies
LEFT JOIN court.Roles ON Companies.taxpayer_id = Roles.taxpayer_id
GROUP BY Companies.name_of_comp;
-- пока что в базу дел внесена информация только о 2 компаниях, следовательно
-- для них кол-во дел будет = 1, для остальных будет выведен 0

-- 3) средний возраст всех участников дел
SELECT ROUND(AVG(EXTRACT(YEAR FROM age(CURRENT_DATE, birth_date))), 1) AS average_age
FROM court.People;
-- калькулятор сказал, что с учетом округления это примерно 43,6 лет

-- 4) топ-3 залов с наибольшей вместимостью
SELECT room_no, capacity
FROM court.Courtrooms
ORDER BY capacity DESC
LIMIT 3;
-- с учетом имеющихся инсертов это будет 50, 40, 35

-- 5) "Путь" каждого дела, т.е. список его статусов в порядке возрастания даты
SELECT case_id, status, to_date,
       ROW_NUMBER() OVER (PARTITION BY case_id ORDER BY COALESCE(to_date, CURRENT_DATE)) as row_num
FROM court.Cases;
-- по каждому делу выведется список со статусами, последний статус (с наибольшим номером
-- и датой to_date = NULL) будет иметь наибольший номер
-- а самый первый этап, очевидно, для каждого из дел будет иметь номер 1







