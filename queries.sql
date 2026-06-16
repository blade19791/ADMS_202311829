-- 15 SQL Queries for ULK Academic System

-- 1. Selection: All students in the 'Computer Science' department
SELECT * FROM Student 
WHERE department_id = (SELECT id FROM Department WHERE name = 'Computer Science');

-- 2. Projection: Names and contact details of all lecturers
SELECT full_name, (contact).email, (contact).phone FROM Lecturer;

-- 3. Join: Courses with department names and coordinators
SELECT c.course_code, c.title, d.name AS department, l.full_name AS coordinator
FROM Course c
JOIN Department d ON c.department_id = d.id
LEFT JOIN Lecturer l ON c.coordinator_id = l.id;

-- 4. Join: Students enrolled in 'Advanced Databases Part 3'
SELECT s.full_name, s.student_code, e.grade
FROM Student s
JOIN Enrollment e ON s.id = e.student_id
JOIN Course c ON e.course_id = c.id
WHERE c.title = 'Advanced Databases Part 3';

-- 5. Aggregation: Count students per department
SELECT d.name, COUNT(s.id) AS student_count
FROM Department d
LEFT JOIN Student s ON d.id = s.department_id
GROUP BY d.name;

-- 6. Grouping: Average grade per course with more than 5 enrollments
SELECT c.title, AVG(e.grade) as avg_grade
FROM Course c
JOIN Enrollment e ON c.id = e.course_id
GROUP BY c.title
HAVING COUNT(e.id) > 5;

-- 7. Subquery: Lecturers who are NOT coordinating any course
SELECT full_name FROM Lecturer
WHERE id NOT IN (SELECT coordinator_id FROM Course WHERE coordinator_id IS NOT NULL);

-- 8. Complex Join: Academic events with locations and organizers
SELECT e.event_name, e.event_date, a.room_number, a.building, l.full_name AS organizer
FROM AcademicEvent e
JOIN AcademicSpace a ON e.location_id = a.id
JOIN Lecturer l ON e.organizer_id = l.id;

-- 9. Array Manipulation: Lecturers interested in 'Data Science'
SELECT full_name, research_interests 
FROM Lecturer 
WHERE 'Data Science' = ANY(research_interests);

-- 10. JSONB Query: Laboratories with specific equipment
SELECT room_number, equipment_inventory->>'os' as operating_system
FROM Laboratory
WHERE equipment_inventory @> '{"os": "Ubuntu 22.04"}';

-- 11. Set Operation: Distinct buildings across all academic spaces
SELECT building FROM Classroom
UNION
SELECT building FROM Laboratory;

-- 12. Pattern Matching: Courses related to 'Algorithms'
SELECT title, course_code FROM Course
WHERE title ILIKE '%Algorithms%';

-- 13. Nested Aggregation: Department with the highest average grade
SELECT d.name, AVG(e.grade) as dept_avg
FROM Department d
JOIN Student s ON d.id = s.department_id
JOIN Enrollment e ON s.id = e.student_id
GROUP BY d.name
ORDER BY dept_avg DESC
LIMIT 1;

-- 14. Window Function: Rank students by grade within each course
SELECT 
    c.title, 
    s.full_name, 
    e.grade,
    RANK() OVER (PARTITION BY c.id ORDER BY e.grade DESC) as rank_in_course
FROM Course c
JOIN Enrollment e ON c.id = e.course_id
JOIN Student s ON e.student_id = s.id;

-- 15. Inheritance Query: All people in the system (Lecturers + Students)
SELECT full_name, 'Lecturer' as role FROM Lecturer
UNION ALL
SELECT full_name, 'Student' as role FROM Student;
