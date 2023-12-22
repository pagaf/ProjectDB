-- 1) Сводная таблица по документам с информацией о типе документа и связанном деле
CREATE OR REPLACE VIEW docs_summary AS
SELECT
    d.doc_id,
    d.type AS doc_type,
    d.date AS doc_date,
    c.case_id,
    c.article,
    c.status AS case_status
FROM
    court.Docs d
JOIN court.Cases c ON d.case_id = c.case_id;


-- 2) Представление, которое для каждого из подсудимых из таблицы Roles показывает решение по его делу
CREATE OR REPLACE VIEW defentants_and_decisions AS
SELECT
    r.taxpayer_id,
    c.case_id,
    MAX(m.meeting_date) AS last_meeting_date,
    MAX(m.meeting_time) AS last_meeting_time,
    MAX(m.court_decision) AS last_court_decision
FROM
    court.Roles r
JOIN court.Meetings m ON r.case_id = m.case_id
JOIN court.Cases c ON r.case_id = c.case_id
WHERE
    r.role = 'Подсудимый'
GROUP BY
    r.taxpayer_id, c.case_id;

select * from defentants_and_decisions;


--3) Статистика использования судебных залов
SELECT
    cr.room_no,
    COUNT(m.meeting_no) AS total_meetings,
    AVG(EXTRACT(EPOCH FROM m.meeting_time::INTERVAL)) / 3600 AS average_meeting_duration_hours
FROM
    court.Courtrooms cr
LEFT JOIN
    court.Meetings m ON cr.room_no = m.room_no
GROUP BY
    cr.room_no
ORDER BY
    cr.room_no;
