-- CRUDы
-- 1)
INSERT INTO court.Roles (taxpayer_id, case_id, role) VALUES
('123456234098', 2, 'Присяжный'),
('987651667784', 2, 'Присяжный'),
('112233446613', 2, 'Адвокат истца');

-- 2)
SELECT taxpayer_id FROM court.Roles
where role = 'Истец'
group by taxpayer_id;

-- 3)
UPDATE court.Companies
SET email = 'arttech@email.com'
WHERE taxpayer_id = '3456789012';

-- 4)
DELETE FROM court.Companies
WHERE taxpayer_id = '1234567890';
