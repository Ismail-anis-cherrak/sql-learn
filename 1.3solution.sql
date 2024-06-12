--! 1. Create a new database named SchoolDB

CREATE DATABASE SchoolDB;
USE SchoolDB;

--! 2. Create the Students table

CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    DateOfBirth DATE
);

--! 2. Create the Courses table

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY AUTO_INCREMENT,
    CourseName VARCHAR(100) NOT NULL,
    Credits INT
);

--! 2. Create the Enrollments table

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    CONSTRAINT fk_student FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT fk_course FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

--! 3. Insert data into Students table

INSERT INTO Students (FirstName, LastName, Email, DateOfBirth) VALUES
('John', 'Doe', 'john.doe@school.com', '2000-05-15'),
('Jane', 'Smith', 'jane.smith@school.com', '2001-07-25'),
('Alice', 'Johnson', 'alice.johnson@school.com', '1999-12-05');

--! 3. Insert data into Courses table

INSERT INTO Courses (CourseName, Credits) VALUES
('Mathematics', 3),
('Physics', 4),
('Chemistry', 3);

--! 3. Insert data into Enrollments table

INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate) VALUES
((SELECT StudentID FROM Students WHERE FirstName = 'John' AND LastName = 'Doe'), (SELECT CourseID FROM Courses WHERE CourseName = 'Mathematics'), '2024-01-01'),
((SELECT StudentID FROM Students WHERE FirstName = 'Jane' AND LastName = 'Smith'), (SELECT CourseID FROM Courses WHERE CourseName = 'Physics'), '2024-01-01'),
((SELECT StudentID FROM Students WHERE FirstName = 'Alice' AND LastName = 'Johnson'), (SELECT CourseID FROM Courses WHERE CourseName = 'Chemistry'), '2024-01-01');

--! 4. Update John Doe's email

UPDATE Students
SET Email = 'john.doe.new@school.com'
WHERE FirstName = 'John' AND LastName = 'Doe';

--! 5. Delete Jane Smith's enrollment in Physics

DELETE FROM Enrollments
WHERE StudentID = (SELECT StudentID FROM Students WHERE FirstName = 'Jane' AND LastName = 'Smith')
AND CourseID = (SELECT CourseID FROM Courses WHERE CourseName = 'Physics');

--! 6. Select all records from Students table

SELECT * FROM Students;

--! 6. Select all records from Courses table

SELECT * FROM Courses;

--! 6. Select all records from Enrollments table

SELECT * FROM Enrollments;

--! 7. Describe the structure of Enrollments table

DESCRIBE Enrollments;

--! Advanced Exercise

--! 1. Add the Teachers table

CREATE TABLE Teachers (
    TeacherID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    HireDate DATE
);

--! 1. Add the Classrooms table

CREATE TABLE Classrooms (
    ClassroomID INT PRIMARY KEY AUTO_INCREMENT,
    RoomNumber VARCHAR(10) NOT NULL,
    Building VARCHAR(50)
);

--! 3. Modify Courses table to include TeacherID foreign key

ALTER TABLE Courses
ADD COLUMN TeacherID INT,
ADD CONSTRAINT fk_teacher FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID);

--! 4. Modify Enrollments table to include ClassroomID foreign key

ALTER TABLE Enrollments
ADD COLUMN ClassroomID INT,
ADD CONSTRAINT fk_classroom FOREIGN KEY (ClassroomID) REFERENCES Classrooms(ClassroomID);

--! 5. Insert data into Teachers table

INSERT INTO Teachers (FirstName, LastName, Email, HireDate) VALUES
('Michael', 'Brown', 'michael.brown@school.com', '2010-08-15'),
('Laura', 'Wilson', 'laura.wilson@school.com', '2012-09-10');

--! 5. Insert data into Classrooms table

INSERT INTO Classrooms (RoomNumber, Building) VALUES
('101', 'Science Building'),
('202', 'Math Building');

--! 6. Assign teachers to existing courses

UPDATE Courses
SET TeacherID = (SELECT TeacherID FROM Teachers WHERE FirstName = 'Laura' AND LastName = 'Wilson')
WHERE CourseName = 'Mathematics';

UPDATE Courses
SET TeacherID = (SELECT TeacherID FROM Teachers WHERE FirstName = 'Michael' AND LastName = 'Brown')
WHERE CourseName = 'Physics';

UPDATE Courses
SET TeacherID = (SELECT TeacherID FROM Teachers WHERE FirstName = 'Laura' AND LastName = 'Wilson')
WHERE CourseName = 'Chemistry';

--! 7. Assign classrooms to existing enrollments

UPDATE Enrollments
SET ClassroomID = (SELECT ClassroomID FROM Classrooms WHERE RoomNumber = '101')
WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseName = 'Mathematics');

UPDATE Enrollments
SET ClassroomID = (SELECT ClassroomID FROM Classrooms WHERE RoomNumber = '202')
WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseName = 'Physics');

UPDATE Enrollments
SET ClassroomID = (SELECT ClassroomID FROM Classrooms WHERE RoomNumber = '101')
WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseName = 'Chemistry');

--! 8. Select all records from Teachers table

SELECT * FROM Teachers;

--! 8. Select all records from Classrooms table

SELECT * FROM Classrooms;

--! 9. Perform a join to list all students with their enrolled courses, teachers, and classrooms

SELECT 
    Students.FirstName AS StudentFirstName, 
    Students.LastName AS StudentLastName, 
    Courses.CourseName, 
    Teachers.FirstName AS TeacherFirstName, 
    Teachers.LastName AS TeacherLastName, 
    Classrooms.RoomNumber, 
    Classrooms.Building
FROM Enrollments
JOIN Students ON Enrollments.StudentID = Students.StudentID
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
JOIN Teachers ON Courses.TeacherID = Teachers.TeacherID
JOIN Classrooms ON Enrollments.ClassroomID = Classrooms.ClassroomID;

--! Drop tables

DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Teachers;
DROP TABLE IF EXISTS Classrooms;
DROP DATABASE IF EXISTS SchoolDB;
