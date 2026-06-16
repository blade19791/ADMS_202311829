-- Database Schema for ULK Academic Activity and Resource Management System

-- Drop tables if they exist
DROP TABLE IF EXISTS Enrollment CASCADE;
DROP TABLE IF EXISTS AcademicEvent CASCADE;
DROP TABLE IF EXISTS ResearchProject CASCADE;
DROP TABLE IF EXISTS Course CASCADE;
DROP TABLE IF EXISTS Department CASCADE;
DROP TABLE IF EXISTS Faculty CASCADE;
DROP TABLE IF EXISTS Student CASCADE;
DROP TABLE IF EXISTS Lecturer CASCADE;
DROP TABLE IF EXISTS Person CASCADE;
DROP TABLE IF EXISTS Classroom CASCADE;
DROP TABLE IF EXISTS Laboratory CASCADE;
DROP TABLE IF EXISTS AcademicSpace CASCADE;

DROP TYPE IF EXISTS ContactInformation CASCADE;
DROP TYPE IF EXISTS Address CASCADE;

-- 1. User Defined Types (Phase 4)
CREATE TYPE Address AS (
    street VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10)
);

CREATE TYPE ContactInformation AS (
    email VARCHAR(100),
    phone VARCHAR(20)
);

-- 2. Inheritance (Phase 4 & 6)
-- Parent Table: Person
CREATE TABLE Person (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    home_address Address,
    contact ContactInformation
);

-- 3. Faculty and Department
CREATE TABLE Faculty (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    dean_name VARCHAR(100)
);

CREATE TABLE Department (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    faculty_id INTEGER REFERENCES Faculty(id) ON DELETE CASCADE,
    UNIQUE(name, faculty_id)
);

-- Student inherits Person
CREATE TABLE Student (
    student_code VARCHAR(20) UNIQUE NOT NULL,
    major VARCHAR(100),
    enrollment_date DATE DEFAULT CURRENT_DATE,
    department_id INTEGER REFERENCES Department(id)
) INHERITS (Person);

-- Lecturer inherits Person
CREATE TABLE Lecturer (
    employee_id VARCHAR(20) UNIQUE NOT NULL,
    specialization VARCHAR(100),
    department_id INTEGER REFERENCES Department(id),
    research_interests TEXT[] -- Array Attribute (Phase 4)
) INHERITS (Person);

-- 4. Academic Spaces (Generalization Phase 6)
CREATE TABLE AcademicSpace (
    id SERIAL PRIMARY KEY,
    room_number VARCHAR(20) NOT NULL,
    building VARCHAR(50),
    capacity INTEGER CHECK (capacity > 0)
);

CREATE TABLE Classroom (
    has_projector BOOLEAN DEFAULT TRUE,
    whiteboard_type VARCHAR(50)
) INHERITS (AcademicSpace);

CREATE TABLE Laboratory (
    lab_type VARCHAR(50),
    equipment_inventory JSONB -- JSONB Attribute (Phase 4)
) INHERITS (AcademicSpace);

-- 5. Academic Operations
CREATE TABLE Course (
    id SERIAL PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    credits INTEGER DEFAULT 3,
    department_id INTEGER REFERENCES Department(id),
    coordinator_id INTEGER -- References Lecturer(id) but inheritance makes FKs tricky
);

CREATE TABLE Enrollment (
    id SERIAL PRIMARY KEY,
    student_id INTEGER, -- References Student(id)
    course_id INTEGER REFERENCES Course(id),
    semester VARCHAR(20),
    grade NUMERIC(4,2),
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ResearchProject (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    lead_lecturer_id INTEGER, -- References Lecturer(id)
    budget NUMERIC(15,2),
    tags TEXT[] -- Array Attribute
);

CREATE TABLE AcademicEvent (
    id SERIAL PRIMARY KEY,
    event_name VARCHAR(200) NOT NULL,
    event_date TIMESTAMP NOT NULL,
    location_id INTEGER, -- References AcademicSpace(id)
    organizer_id INTEGER, -- References Lecturer(id)
    metadata JSONB -- JSONB Attribute
);

-- Note on Inheritance and Foreign Keys: 
-- In PostgreSQL, foreign keys cannot reference inherited tables directly in a way that includes children.
-- For the purpose of this assignment, we will use IDs and handle integrity via logic or triggers if needed,
-- but for the schema script, we'll keep it simple as per implementation requirements.
