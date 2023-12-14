-- Создание схемы
DROP SCHEMA IF EXISTS court CASCADE;
     CREATE SCHEMA court;
SET search_path = court, public;

-- Дела
DROP TABLE IF EXISTS court.cases;
CREATE TABLE court.cases (
    case_id SERIAL PRIMARY KEY,
    type_of_crime TEXT,
    article TEXT NOT NULL,
    start_date DATE DEFAULT CURRENT_DATE NOT NULL
);


-- Залы суда
DROP TABLE IF EXISTS court.courtrooms;
CREATE TABLE court.courtrooms (
    room_no INTEGER PRIMARY KEY NOT NULL,
    floor INTEGER CHECK (floor BETWEEN 1 AND 6) NOT NULL,
    capacity INTEGER CHECK (capacity > 0) NOT NULL
);

-- Заседания
DROP TABLE IF EXISTS court.meetings;
CREATE TABLE court.meetings (
    meeting_no SERIAL PRIMARY KEY,
    room_no INTEGER REFERENCES court.courtrooms(room_no) NOT NULL,
    case_id INTEGER REFERENCES court.cases(case_id) NOT NULL,
    meeting_date DATE NOT NULL,
    meeting_time TIME NOT NULL,
    court_decision TEXT NOT NULL,
    CONSTRAINT unique_meeting_no UNIQUE (meeting_no)
);



-- Истцы
DROP TABLE IF EXISTS court.plaintiffs;
CREATE TABLE court.plaintiffs (
    plaintiff_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    home_address TEXT,
    postal_code NUMERIC(6, 0),
    phone_number VARCHAR(20) NOT NULL UNIQUE CHECK (phone_number ~ '^\\+?[0-9\\-\\s]+$')
);

-- Присяжные
DROP TABLE IF EXISTS court.jurors;
CREATE TABLE court.jurors (
    juror_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    passport_series NUMERIC(4, 0) NOT NULL,
    passport_number NUMERIC(6, 0) NOT NULL,
    phone_number VARCHAR(20) CHECK (phone_number ~ '^\\+?[0-9\\-\\s]+$')
);

-- Присяжные на заседаниях
DROP TABLE IF EXISTS court.jurors_x_meetings;
CREATE TABLE court.jurors_x_meetings (
    juror_id INTEGER REFERENCES court.jurors(juror_id) NOT NULL,
    meeting_no INTEGER NOT NULL REFERENCES court.cases(case_id),
    PRIMARY KEY (juror_id, meeting_no)
);

-- Юристы
DROP TABLE IF EXISTS court.lawyers;
CREATE TABLE court.lawyers (
    lawyer_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    post TEXT CHECK (post IN ('Судья', 'Адвокат', 'Прокурор')) NOT NULL
);

-- Юристы на заседаниях
DROP TABLE IF EXISTS court.lawyers_x_meetings;
CREATE TABLE court.lawyers_x_meetings (
    lawyer_id INTEGER REFERENCES court.lawyers(lawyer_id) NOT NULL,
    meeting_no INTEGER REFERENCES court.cases(case_id) NOT NULL,
    PRIMARY KEY (lawyer_id, meeting_no)
);


-- Подсудимые
DROP TABLE IF EXISTS court.defendants;
CREATE TABLE court.defendants (
    defendant_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    passport_series NUMERIC(4, 0),
    passport_number NUMERIC(6, 0),
    birth_date DATE
);

-- Дела с подсудимыми
DROP TABLE IF EXISTS cases_x_defendants;
CREATE TABLE court.cases_x_defendants (
    case_id INTEGER REFERENCES court.cases(case_id) NOT NULL,
    defendant_id INTEGER REFERENCES court.defendants(defendant_id) NOT NULL,
    PRIMARY KEY (case_id, defendant_id)
);

-- Дела с истцами
DROP TABLE IF EXISTS court.cases_x_plaintiffs;
CREATE TABLE court.cases_x_plaintiffs (
    case_id INTEGER REFERENCES court.cases(case_id) NOT NULL,
    plaintiff_id INTEGER REFERENCES court.plaintiffs(plaintiff_id) NOT NULL,
    PRIMARY KEY (case_id, plaintiff_id)
);

ALTER TABLE court.meetings
--ADD CONSTRAINT pk_meetings PRIMARY KEY (meeting_no),
ADD CONSTRAINT fk_meetings_room FOREIGN KEY (room_no) REFERENCES court.courtrooms(room_no),
ADD CONSTRAINT fk_meetings_case FOREIGN KEY (case_id) REFERENCES court.cases(case_id);

-- Ограничения для таблицы Plaintiffs
--ALTER TABLE court.plaintiffs
--ADD CONSTRAINT pk_plaintiffs PRIMARY KEY (plaintiff_id);

-- Ограничения для таблицы Cases
--ALTER TABLE court.cases
--ADD CONSTRAINT pk_cases PRIMARY KEY (case_id);

-- Ограничения для таблицы Jurors
--ALTER TABLE court.jurors
--ADD CONSTRAINT pk_jurors PRIMARY KEY (juror_id);

-- Ограничения для таблицы Jurors_X_Meetings
ALTER TABLE court.jurors_x_meetings
--ADD CONSTRAINT pk_jurors_x_meetings PRIMARY KEY (juror_id, meeting_no),
ADD CONSTRAINT fk_jurors_x_meetings_juror FOREIGN KEY (juror_id) REFERENCES court.jurors(juror_id),
ADD CONSTRAINT fk_jurors_x_meetings_meeting FOREIGN KEY (meeting_no) REFERENCES court.cases(case_id);

-- Ограничения для таблицы Lawyers
--ALTER TABLE court.lawyers
--ADD CONSTRAINT pk_lawyers PRIMARY KEY (lawyer_id);

-- Ограничения для таблицы Lawyers_X_Meetings
ALTER TABLE court.lawyers_x_meetings
--ADD CONSTRAINT pk_lawyers_x_meetings PRIMARY KEY (lawyer_id, meeting_no),
ADD CONSTRAINT fk_lawyers_x_meetings_lawyer FOREIGN KEY (lawyer_id) REFERENCES court.lawyers(lawyer_id),
ADD CONSTRAINT fk_lawyers_x_meetings_meeting FOREIGN KEY (meeting_no) REFERENCES court.cases(case_id);

-- Ограничения для таблицы Courtrooms
--ALTER TABLE court.courtrooms
--ADD CONSTRAINT pk_courtrooms PRIMARY KEY (room_no);

-- Ограничения для таблицы Cases_X_Defendants
ALTER TABLE court.cases_x_defendants
--ADD CONSTRAINT pk_cases_x_defendants PRIMARY KEY (case_id, defendant_id),
ADD CONSTRAINT fk_cases_x_defendants_case FOREIGN KEY (case_id) REFERENCES court.cases(case_id),
ADD CONSTRAINT fk_cases_x_defendants_defendant FOREIGN KEY (defendant_id) REFERENCES court.defendants(defendant_id);

-- Ограничения для таблицы Cases_X_Plaintiffs
ALTER TABLE court.cases_x_plaintiffs
--ADD CONSTRAINT pk_cases_x_plaintiffs PRIMARY KEY (case_id, plaintiff_id),
ADD CONSTRAINT fk_cases_x_plaintiffs_case FOREIGN KEY (case_id) REFERENCES court.cases(case_id),
ADD CONSTRAINT fk_cases_x_plaintiffs_plaintiff FOREIGN KEY (plaintiff_id) REFERENCES court.plaintiffs(plaintiff_id);

-- Ограничения для таблицы Defendants
--ALTER TABLE court.defendants
--ADD CONSTRAINT pk_defendants PRIMARY KEY (defendant_id);

insert into lawyers (lawyer_id, first_name, last_name, post)
values (5, 'Илья', 'Петров', 'Судья');
select * from lawyers;