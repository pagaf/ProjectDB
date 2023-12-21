-- 1) Составление отчета по итогу заседания
CREATE OR REPLACE FUNCTION generate_session_report(in_meeting_no INTEGER)
RETURNS TABLE (
    report_text TEXT
) AS $$
DECLARE
    meeting_info RECORD;
    judge_name TEXT;
    prosecutor_name TEXT;
BEGIN
    SELECT
        m.meeting_no,
        c.article,
        c.status,
        c.start_date,
        cr.room_no,
        m.meeting_date,
        m.meeting_time
    INTO
        meeting_info
    FROM
        court.Meetings m
    JOIN
        court.Cases c ON m.case_id = c.case_id
    JOIN
        court.Courtrooms cr ON m.room_no = cr.room_no
    WHERE
        m.meeting_no = in_meeting_no;

    SELECT
        p.first_name || ' ' || p.last_name
    INTO
        judge_name
    FROM
        court.Roles r
    JOIN
        court.People p ON r.taxpayer_id = p.taxpayer_id
    WHERE
        r.case_id = meeting_info.meeting_no
        AND r.role = 'Судья'
        AND meeting_info.meeting_date BETWEEN r.from_date AND COALESCE(r.to_date, CURRENT_DATE);

    SELECT
        p.first_name || ' ' || p.last_name
    INTO
        prosecutor_name
    FROM
        court.Roles r
    JOIN
        court.People p ON r.taxpayer_id = p.taxpayer_id
    WHERE
        r.case_id = meeting_info.meeting_no
        AND r.role = 'Прокурор'
        AND meeting_info.meeting_date BETWEEN r.from_date AND COALESCE(r.to_date, CURRENT_DATE);

    -- Генерируем текст отчета
    report_text := 'Итог заседания ' || meeting_info.meeting_no ||
                   ' по делу ' || meeting_info.article ||
                   ' (' || meeting_info.status || ')' ||
                   ', судебный зал ' || meeting_info.room_no ||
                   ', дата ' || meeting_info.meeting_date ||
                   ', время ' || meeting_info.meeting_time ||
                   ', судья ' || judge_name ||
                   ', прокурор ' || prosecutor_name;

    -- Возвращаем результат
    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;


-- 2) Поиск доступного для заседания зала по заданной вместимости и желаемой дате и времени
CREATE OR REPLACE FUNCTION get_vacant_courtroom(
    in_capacity INTEGER,
    in_desired_date DATE,
    in_desired_time TIME
)
RETURNS INTEGER AS $$
DECLARE
    courtroom INTEGER;
BEGIN
    -- Находим свободный судебный зал с нужной вместимостью
    SELECT room_no
    INTO courtroom
    FROM court.Courtrooms cr
    WHERE cr.capacity >= in_capacity
        AND cr.room_no NOT IN (
            SELECT m.room_no
            FROM court.Meetings m
            WHERE m.meeting_date = in_desired_date
                AND m.meeting_time = in_desired_time
        );
    -- Возвращается номер свободного судебного зала
    RETURN courtroom;
END;
$$ LANGUAGE plpgsql;
