/* ==========================================================================
   students_db_backup.sql
   CIS 4720 Database Management and SQL

   WHAT THIS FILE IS
   A starter database for in_class_lab7b. It builds a schema called
   students_db holding one table of students, plus a view. The lab PCs are
   wiped every night, so a script like this one is how you get a working
   database back in a few seconds instead of typing it all again. The file
   is the database. The server is disposable.

   WHAT IT BUILDS
     1. A schema called students_db
     2. One table, STUDENT, with six columns and a primary key
     3. Five rows of data
     4. One view, STUDENT_GPA, showing just the names and the grade averages

   BEFORE YOU RUN IT
   The schema has to exist before VS Code can connect to it, and VS Code
   will not create one for you. Step 4 of the lab has you create it at the
   command prompt first. Do that step before you open VS Code.

   HOW TO RUN IT
   Open it in VS Code with SQLTools connected to students_db, then run the
   whole file. Lab7b walks you through it.

   READ THIS BEFORE YOU RUN IT A SECOND TIME
   Run it once and everything works. Run it twice and you get errors,
   because the table already exists and the rows are already there. Step 10
   of the lab explains which parts to comment out and why.
   ========================================================================== */


-- ======================================================================
-- SECTION 1. The schema
-- A schema is the container that holds your tables. CREATE DATABASE makes
-- one, and USE tells the server which one the statements below apply to.
-- ======================================================================

-- Create the schema. IF NOT EXISTS means this line is safe to run twice,
-- and safe to run even though you already made it at the command prompt.
CREATE DATABASE IF NOT EXISTS students_db;

-- Switch into it. Everything below lands inside this schema.
USE students_db;


-- ======================================================================
-- SECTION 2. The table
-- Each column gets a data type that fits what it holds:
--   INT           whole numbers, used here for the id
--   VARCHAR(30)   text up to 30 characters
--   DECIMAL(3,2)  a number with 1 digit before the point and 2 after,
--                 which is exactly the shape of a grade average
--   DATE          a real date, stored as YYYY-MM-DD
-- NOT NULL means the column may never be left empty.
-- PRIMARY KEY means student_id must be unique and may never be empty.
-- ======================================================================

-- CREATE TABLE STUDENT (
--     student_id  INT          NOT NULL,
--     first_name  VARCHAR(30)  NOT NULL,
--     last_name   VARCHAR(30)  NOT NULL,
--     major       VARCHAR(40),
--     gpa         DECIMAL(3,2),
--     enrolled_on DATE,
--     PRIMARY KEY (student_id)
-- );


-- ======================================================================
-- SECTION 3. The data
-- Five students. Two enrolled in the same term, which is useful later when
-- you start filtering on a date.
-- ======================================================================

-- INSERT INTO STUDENT VALUES (1,'Ana',   'Reyes', 'CIS',              3.75,'2025-08-25');
-- INSERT INTO STUDENT VALUES (2,'Marcus','Bell',  'Computer Science', 3.20,'2025-08-25');
-- INSERT INTO STUDENT VALUES (3,'Priya', 'Nair',  'Mathematics',      3.90,'2026-01-12');
-- INSERT INTO STUDENT VALUES (4,'Devon', 'Rao',   'CIS',              2.85,'2026-01-12');
-- INSERT INTO STUDENT VALUES (5,'Elena', 'Vargas','Business',         3.45,'2026-08-24');


-- ======================================================================
-- SECTION 4. The view
-- A view is a stored SELECT statement you can query as if it were a table.
-- This one shows only the names and the grade average, so anyone using it
-- cannot reach the id, the major or the enrollment date.
-- ======================================================================

-- CREATE VIEW STUDENT_GPA AS
-- SELECT first_name, last_name, gpa
-- FROM STUDENT;


-- ======================================================================
-- SECTION 5. Checks
-- These only read. They are safe to run as many times as you like, so
-- leave them switched on even after the first run.
-- ======================================================================

-- All five rows, straight from the table.
SELECT * FROM STUDENT;

-- The view, highest grade average first. Three columns, not six.
SELECT * FROM STUDENT_GPA ORDER BY gpa DESC;

-- Should come back as 5 students and an average of 3.43.
SELECT COUNT(*) AS students, ROUND(AVG(gpa), 2) AS average_gpa FROM STUDENT;

-- STUDENT is a BASE TABLE and STUDENT_GPA is a VIEW. SHOW TABLES on its
-- own does not tell them apart, which is why this one says FULL.
SHOW FULL TABLES;


-- ######################################################################
-- YOUR LAB7B WORK STARTS BELOW THIS LINE
--
-- Add your Chapter 5 statements under the headings below, in order. Put a
-- comment above every statement saying what it does, in your own words.
-- The comments are graded.
-- ######################################################################


-- STEP 11. Section 5.1, look at your schema

-- Shows the databasess that I'm currently using.
SELECT DATABASE() AS my_schema;

-- Shows all tables and views in my database.
SHOW FULL TABLES;

-- STEP 12. Section 5.2, look at the data types

-- Shows the columns and data tyoes in the STUDENT table.
DESCRIBE STUDENT;

-- STEP 13. Section 5.3, create a table by copying with a subquery

-- Creats a copy of STUDENT with four of the columns.
CREATE TABLE STUDENT_COPY AS
SELECT student_id, first_name, last_name, gpa
FROM STUDENT;

-- Shows all the rows in the copied table.
SELECT * FROM STUDENT_COPY;

-- Shows how the copied table was created.
SHOW CREATE TABLE STUDENT_COPY;

-- STEP 14. Section 5.4, change the structure of the copy

-- Adds an honors column to the copied table.
ALTER TABLE STUDENT_COPY ADD COLUMN honors CHAR(1);

-- Makes the last_name column wider.
ALTER TABLE STUDENT_COPY MODIFY COLUMN last_name VARCHAR(50) NOT NULL;

-- Adds primary key back to student_id
ALTER TABLE STUDENT_COPY ADD PRIMARY KEY (student_id);

-- Shows the updated structure of the copied table.
DESCRIBE STUDENT_COPY;

-- Tests the primary key by trying to add a duplicate student_id.
INSERT INTO STUDENT_COPY VALUES (1,'Duplicate','Row',0.00,NULL);

-- Removes the honors column from the copied table.
ALTER TABLE STUDENT_COPY DROP COLUMN honors;

-- STEP 15. Section 5.5, insert, update and delete a row

-- Adds a new student to the copied table.
INSERT INTO STUDENT_COPY VALUES (6,'Omar','Faruqi',3.10);

-- Shows the student was added.
SELECT * FROM STUDENT_COPY WHERE student_id = 6;

-- Changes the GPA for student 6.
UPDATE STUDENT_COPY SET gpa = 3.35 WHERE student_id = 6;

-- Shows the student after changing the GPA.
SELECT * FROM STUDENT_COPY WHERE student_id = 6;

-- Remvoes student 6 from the copied table.
DELETE FROM STUDENT_COPY WHERE student_id = 6;

-- Shows how many rows are left in the copied table.
SELECT COUNT(*) AS rows_left FROM STUDENT_COPY;

-- STEP 16. Section 5.6, create a view and update through it

-- Creates a view showing students with a GPA of 3.50 or higher.
CREATE VIEW HIGH_GPA AS
SELECT student_id, first_name, last_name, gpa
FROM STUDENT_COPY
WHERE gpa >= 3.50;

-- Shows the students in the HIGH_GPA view from highest to lowest GPA.
SELECT * FROM HIGH_GPA ORDER BY gpa DESC;

-- Shows student 1's GPA before the update. 
SELECT student_id, gpa FROM STUDENT_COPY WHERE student_id = 1;

-- Changes student 1's GPA in the HIGH_GPA view.
UPDATE HIGH_GPA SET gpa = 3.95 WHERE student_id = 1;

-- SHOWS student 1's GPA after updating it.
SELECT student_id, gpa FROM STUDENT_COPY WHERE student_id = 1;

-- Creates a summary view showing the stuent count and average GPA.
CREATE VIEW GPA_SUMMARY AS
SELECT COUNT(*) AS n, ROUND(AVG(gpa), 2) AS avg_gpa
FROM STUDENT_COPY;

-- Tests if the summary view can be updated.
UPDATE GPA_SUMMARY SET avg_gpa = 4.00;
