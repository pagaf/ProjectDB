-- 1)Представление для маскирования email компаний
CREATE OR REPLACE VIEW masked_companies AS
SELECT 
	taxpayer_id,
	name_of_comp,
	regexp_replace(email, '(.*)@', '***@') AS masked_email,
	legal_address
FROM court.Companies;

-- 2)Представление для маскирования телефонных номеров физических лиц
CREATE OR REPLACE VIEW masked_people AS
SELECT
	taxpayer_id,
	first_name,
	last_name,
	passport_series,
	passport_number,
	birth_date,
	regexp_replace(phone_number, '(\d{3})\d{4}(\d{2})', '\1****\2') AS masked_phone_number,
	home_address
FROM court.People;

--3) Маскирование ролей судьи и адвокатов в таблице Roles
CREATE OR REPLACE VIEW masked_roles AS
SELECT
    taxpayer_id,
    case_id,
    CASE
        WHEN role IN ('Судья', 'Адвокат истца', 'Адвокат подсудимого', 'Прокурор') THEN 'Юрист'
        ELSE role
    END AS masked_role,
    from_date,
    to_date
FROM court.Roles;

--4) Представление для таблицы Courtrooms
CREATE OR REPLACE VIEW courtrooms_view AS
SELECT
    room_no,
    floor
FROM court.Courtrooms;

--5) Представление для таблицы Cases с маскированием номера статьи
CREATE OR REPLACE VIEW masked_cases AS
SELECT
    case_id,
    REGEXP_REPLACE(article, '[0-9]+', '***') AS article,
    start_date,
    status
FROM court.Cases;

--6) Представление для таблицы Meetings
CREATE OR REPLACE VIEW meetings_view AS
SELECT
    meeting_no,
    room_no,
    case_id,
    meeting_date,
    meeting_time,
    court_decision
FROM court.Meetings;

--7) Представление для таблицы Docs
CREATE OR REPLACE VIEW docs_view AS
SELECT
    doc_id,
    case_id,
    type
FROM court.Docs;
