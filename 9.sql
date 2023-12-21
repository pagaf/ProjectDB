-- 1) Проверка на пересечение заседаний по времени (если совпадает время и номер аудитории)
CREATE OR REPLACE FUNCTION check_courtroom_schedule()
RETURNS TRIGGER AS $$
DECLARE
    existing_meeting RECORD;
BEGIN
    -- Проверка наличия пересечения по времени
    SELECT
        m.*
    INTO
        existing_meeting
    FROM
        court.Meetings m
    WHERE
        m.room_no = NEW.room_no
        AND m.meeting_date = NEW.meeting_date
        AND m.meeting_time = NEW.meeting_time
        AND m.meeting_no <> NEW.meeting_no;

    IF FOUND THEN
        RAISE EXCEPTION 'Заседание % пересекается по времени с заседанием %', NEW.meeting_no, existing_meeting.meeting_no;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_courtroom_schedule_trigger
BEFORE INSERT OR UPDATE ON court.Meetings
FOR EACH ROW
EXECUTE FUNCTION check_courtroom_schedule();


-- 2) По итогам заседания меняем статус дела
CREATE OR REPLACE FUNCTION update_case_status()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE court.Cases
    SET status = NEW.court_decision
    WHERE case_id = NEW.case_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_case_status_trigger
AFTER INSERT ON court.Meetings
FOR EACH ROW
EXECUTE FUNCTION update_case_status();
