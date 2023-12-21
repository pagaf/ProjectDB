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
-- с учетом имеющихся инсертов это будет 60, 50, 40


-- 5) Получение даты последнего заседания для каждого дела
SELECT case_id, MIN(meeting_date) OVER (PARTITION BY case_id) AS first_meeting_date,
       MAX(meeting_date) OVER (PARTITION BY case_id) AS last_meeting_date
FROM court.Meetings;


-- 6) Топ наиболее активных залов суда по количеству проведенных заседаний
SELECT room_no, COUNT(meeting_no) AS meetings_count,
       RANK() OVER (ORDER BY COUNT(meeting_no) DESC) AS room_activity_rank
FROM court.Meetings
GROUP BY room_no;
