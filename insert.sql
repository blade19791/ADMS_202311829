-- Realistic Mock Data Population for ULK Academic System (Mockaroo-like)

-- 1. Faculties and Departments
INSERT INTO Faculty (name, dean_name) VALUES 
('Faculty of Computing and Information Technology', 'Dr. Alice Uwera'),
('Faculty of Economics and Management', 'Prof. Jean Bosco Habimana'),
('Faculty of Social Sciences', 'Dr. Marie Claire Nyirahabimana');

INSERT INTO Department (name, faculty_id) VALUES 
('Computer Science', 1),
('Information Systems', 1),
('Accounting', 2),
('Business Administration', 2),
('International Relations', 3);

-- 2. Lecturers (20 records with realistic names)
INSERT INTO Lecturer (full_name, date_of_birth, home_address, contact, employee_id, specialization, department_id, research_interests)
SELECT 
    (ARRAY['Eric Kagame', 'Solange Mutesi', 'Patrick Nshuti', 'Divine Uwineza', 'Jean Paul Nkurunziza', 'Beata Mukamana', 'Thierry Habineza', 'Angelique Umutoni', 'Claude Niyomugabo', 'Esperance Nyiranzeyimana', 'Olivier Manzi', 'Chantal Uwase', 'Richard Gakuba', 'Fiona Ingabire', 'Alphonse Mutabazi', 'Glorieuse Umubyeyi', 'David Rugamba', 'Yvonne Mukansanga', 'Justin Bizimana', 'Peace Umwari'])[i],
    '1970-01-01'::DATE + (random() * 7300)::INT,
    ROW('Street ' || (random()*100)::int || ' Ave ' || i, 'Kigali', 'Nyarugenge', 'KN ' || (100 + i) || ' ST')::Address,
    ROW('l.' || lower(split_part((ARRAY['kagame', 'mutesi', 'nshuti', 'uwineza', 'nkurunziza', 'mukamana', 'habineza', 'umutoni', 'niyomugabo', 'nyiranzeyimana', 'manzi', 'uwase', 'gakuba', 'ingabire', 'mutabazi', 'umubyeyi', 'rugamba', 'mukansanga', 'bizimana', 'umwari'])[i], ' ', 1)) || '@ulk.ac.rw', '+250788' || (100000 + i))::ContactInformation,
    'EMP' || LPAD(i::text, 3, '0'),
    CASE WHEN i % 4 = 0 THEN 'Artificial Intelligence' WHEN i % 4 = 1 THEN 'Network Security' WHEN i % 4 = 2 THEN 'Software Engineering' ELSE 'Big Data Analytics' END,
    (i % 5) + 1,
    ARRAY[(ARRAY['Machine Learning', 'Blockchain', 'IoT', 'Cloud Computing', 'NLP'])[((random()*4)::int + 1)], (ARRAY['Cyber Ethics', 'Distributed Systems', 'Mobile App Dev', 'E-commerce', 'UX Design'])[((random()*4)::int + 1)]]
FROM generate_series(1, 20) AS i;

-- 3. Students (100 records with realistic data)
INSERT INTO Student (full_name, date_of_birth, home_address, contact, student_code, major, enrollment_date, department_id)
SELECT 
    (ARRAY['Amina', 'Bruno', 'Clementine', 'Didier', 'Esther', 'Fabrice', 'Grace', 'Herve', 'Irene', 'Julius'])[((random()*9)::int + 1)] || ' ' || (ARRAY['Mugisha', 'Ishimwe', 'Iradukunda', 'Umuhoza', 'Niyonzima', 'Manzi', 'Tuyishime', 'Umulisa', 'Mutoni', 'Ganza'])[((random()*9)::int + 1)],
    '1998-01-01'::DATE + (random() * 2920)::INT,
    ROW('KK ' || (random()*500)::int || ' St', 'Kigali', 'Kicukiro', 'RW' || (1000 + i))::Address,
    ROW('student.' || i || '@student.ulk.ac.rw', '+250785' || (100000 + i))::ContactInformation,
    '2024/ULK/' || LPAD(i::text, 4, '0'),
    CASE WHEN i % 3 = 0 THEN 'Computer Science' WHEN i % 3 = 1 THEN 'Information Technology' ELSE 'Business Information Systems' END,
    '2024-01-15'::DATE - (random()*365)::int,
    (i % 5) + 1
FROM generate_series(1, 100) AS i;

-- 4. Academic Spaces
INSERT INTO Classroom (room_number, building, capacity, has_projector, whiteboard_type)
VALUES 
('G101', 'Grand Building', 60, true, 'Interactive Smart Board'),
('G102', 'Grand Building', 55, true, 'Whiteboard'),
('S201', 'Science Block', 40, false, 'Blackboard'),
('S202', 'Science Block', 45, true, 'Whiteboard'),
('A101', 'Arts Wing', 120, true, 'Projector Wall');

INSERT INTO Laboratory (room_number, building, capacity, lab_type, equipment_inventory)
VALUES 
('L301', 'Innovation Center', 30, 'Cisco Networking Lab', '{"routers": 15, "switches": 10, "workstations": 30}'),
('L302', 'Innovation Center', 25, 'AI & Robotics Lab', '{"gpus": 10, "robots": 5, "vr_headsets": 8}'),
('L303', 'Science Block', 20, 'Physics Lab', '{"oscilloscopes": 10, "multimeters": 20}');

-- 5. Courses (30 realistic courses)
INSERT INTO Course (course_code, title, credits, department_id, coordinator_id)
SELECT 
    (ARRAY['BIT', 'CSC', 'ACC', 'BUS', 'IRS'])[((i-1)%5)+1] || ' ' || (100 + i),
    (ARRAY['Database Management Systems', 'Java Programming', 'Macroeconomics', 'Financial Accounting', 'Conflict Resolution', 'Data Structures', 'Operating Systems', 'Business Law', 'Audit and Assurance', 'Diplomacy and Statecraft', 'Software Engineering', 'Machine Learning', 'Investment Management', 'Marketing Strategy', 'Public Policy', 'Mobile Computing', 'Cloud Services', 'Corporate Finance', 'Human Resource Management', 'Global Security', 'Web Technologies', 'Compiler Design', 'Taxation Law', 'Operations Research', 'Political Philosophy', 'Network Administration', 'Human Computer Interaction', 'Strategic Management', 'Entrepreneurship', 'International Trade'])[i],
    (ARRAY[3, 4, 5, 2])[((random()*3)::int + 1)],
    ((i-1)%5)+1,
    (random()*19)::int + 1
FROM generate_series(1, 30) AS i;

-- 6. Enrollments (3 per student)
INSERT INTO Enrollment (student_id, course_id, semester, grade)
SELECT 
    s.id,
    c.id,
    'Year 2024 Semester ' || ((random()*1)::int + 1),
    (random() * 40 + 60)::NUMERIC(4,2)
FROM (SELECT id FROM Student) s
CROSS JOIN LATERAL (SELECT id FROM Course ORDER BY random() LIMIT 3) c;

-- 7. Research Projects
INSERT INTO ResearchProject (title, description, lead_lecturer_id, budget, tags)
VALUES 
('Smart City Kigali', 'IoT based traffic management system for Kigali urban areas.', 1, 15000.00, ARRAY['IoT', 'SmartCity', 'Sustainability']),
('FinTech in Rwanda', 'Analyzing the impact of mobile money on rural economy.', 5, 8000.00, ARRAY['FinTech', 'Economy', 'MobileMoney']),
('AI for Healthcare', 'Developing a chatbot for primary health diagnosis in Kinyarwanda.', 3, 25000.00, ARRAY['AI', 'NLP', 'Healthcare']);

-- 8. Academic Events
INSERT INTO AcademicEvent (event_name, event_date, location_id, organizer_id, metadata)
VALUES 
('Tech Innovation Summit', '2024-10-15 09:00:00', 1, 2, '{"theme": "Future of AI", "guest_speaker": "Hon. Minister of ICT"}'),
('Career Day 2024', '2024-11-20 10:00:00', 5, 4, '{"sponsors": ["Bank of Kigali", "MTN", "Irembo"]}'),
('Research Symposium', '2024-12-05 14:00:00', 4, 1, '{"tracks": ["Computing", "Economics", "Social Sciences"]}');
