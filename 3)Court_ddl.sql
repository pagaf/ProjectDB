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
