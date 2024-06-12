--### Exercise 1: Adding Columns and Basic Table Operations


-- 1. Create the Library table
CREATE TABLE Library (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(150) NOT NULL,
    Author VARCHAR(50) NOT NULL,
    PublishedYear INT,
    ISBN VARCHAR(20) UNIQUE,
    Genre VARCHAR(50)
);

-- 2. Insert sample data into the Library table
INSERT INTO Library (Title, Author, PublishedYear, ISBN) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 1925, '9780743273565'),
('1984', 'George Orwell', 1949, '9780451524935'),
('To Kill a Mockingbird', 'Harper Lee', 1960, '9780061120084');

-- 3. Add the Genre column to the Library table
ALTER TABLE Library ADD COLUMN Genre VARCHAR(50);

-- 4. Modify the Title column to allow for longer titles
ALTER TABLE Library MODIFY COLUMN Title VARCHAR(150);

-- 5. Update the PublishedYear for the book with BookID = 2 to 1950
UPDATE Library SET PublishedYear = 1950 WHERE BookID = 2;

-- 6. Delete the book with BookID = 3
DELETE FROM Library WHERE BookID = 3;


---

--### Exercise 2: Adding Columns and Constraints


-- 1. Create the Student table
CREATE TABLE Student (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Age INT,
    Email VARCHAR(100) UNIQUE,
    EnrollmentDate DATE
);

-- 2. Create the Course table
CREATE TABLE Course (
    CourseID INT PRIMARY KEY AUTO_INCREMENT,
    CourseName VARCHAR(150) NOT NULL,
    Credits INT
);

-- 3. Create the Enrollment table
CREATE TABLE Enrollment (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    UNIQUE (StudentID, CourseID)
);

-- 4. Insert sample data into the Student and Course tables
INSERT INTO Student (Name, Age, Email, EnrollmentDate) VALUES
('Alice Johnson', 20, 'alice.johnson@example.com', '2024-01-01'),
('Bob Smith', 22, 'bob.smith@example.com', '2024-01-01');

INSERT INTO Course (CourseName, Credits) VALUES
('Mathematics', 3),
('Physics', 4);

-- 5. Add the ClassroomID column to the Course table
ALTER TABLE Course ADD COLUMN ClassroomID INT;

-- 6. Add foreign key relationships to Enrollment table
ALTER TABLE Enrollment
ADD CONSTRAINT fk_student FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
ADD CONSTRAINT fk_course FOREIGN KEY (CourseID) REFERENCES Course(CourseID);

-- 7. Alter the Course table to change CourseName column size
ALTER TABLE Course MODIFY COLUMN CourseName VARCHAR(150);

-- 8. Drop the Enrollment table if no longer needed
DROP TABLE IF EXISTS Enrollment;

-- 9. Add CreditsEarned column to the Student table
ALTER TABLE Student ADD COLUMN CreditsEarned INT;


---

--### Exercise 3: Complex Schema Design and Data Integrity


-- 1. Create the Department table
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL,
    Location VARCHAR(100)
);

-- 2. Create the Professor table
CREATE TABLE Professor (
    ProfessorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    HireDate DATE
);

-- 3. Create the Course table
CREATE TABLE Course (
    CourseID INT PRIMARY KEY AUTO_INCREMENT,
    CourseName VARCHAR(150) NOT NULL,
    Credits INT,
    DepartmentID INT,
    ClassroomID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (ClassroomID) REFERENCES Classroom(ClassroomID)
);

-- 4. Create the Enrollment table
CREATE TABLE Enrollment (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    UNIQUE (StudentID, CourseID)
);

-- 5. Create the Classroom table
CREATE TABLE Classroom (
    ClassroomID INT PRIMARY KEY AUTO_INCREMENT,
    RoomNumber VARCHAR(10) NOT NULL,
    Building VARCHAR(50)
);

-- 6. Insert sample data into the tables
INSERT INTO Department (DepartmentName, Location) VALUES
('Computer Science', 'Building A'),
('Mathematics', 'Building B');

INSERT INTO Professor (FirstName, LastName, Email, HireDate) VALUES
('John', 'Doe', 'john.doe@university.com', '2010-08-15'),
('Jane', 'Smith', 'jane.smith@university.com', '2012-09-10');

INSERT INTO Course (CourseName, Credits, DepartmentID) VALUES
('Algorithms', 4, 1),
('Calculus', 3, 2);

INSERT INTO Student (Name, Age, Email, EnrollmentDate) VALUES
('Alice Johnson', 20, 'alice.johnson@example.com', '2024-01-01'),
('Bob Smith', 22, 'bob.smith@example.com', '2024-01-01');

INSERT INTO Classroom (RoomNumber, Building) VALUES
('101', 'Science Building'),
('202', 'Math Building');

-- 7. Add ClassroomID to the Course table
ALTER TABLE Course ADD COLUMN ClassroomID INT;

-- 8. Establish relationships and constraints
ALTER TABLE Course
ADD CONSTRAINT fk_classroom FOREIGN KEY (ClassroomID) REFERENCES Classroom(ClassroomID),
ADD CONSTRAINT fk_department FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID);

-- 9. Update and add data to reflect new schema and relationships
ALTER TABLE Course
ADD CONSTRAINT fk_professor FOREIGN KEY (ProfessorID) REFERENCES Professor(ProfessorID);

-- 10. Query the data
-- List all professors along with the courses they teach
SELECT Professor.FirstName, Professor.LastName, Course.CourseName
FROM Professor
JOIN Course ON Professor.ProfessorID = Course.ProfessorID;

-- List all students and their courses, along with the respective professors
SELECT Student.Name, Course.CourseName, Professor.FirstName, Professor.LastName
FROM Student
JOIN Enrollment ON Student.StudentID = Enrollment.StudentID
JOIN Course ON Enrollment.CourseID = Course.CourseID
JOIN Professor ON Course.ProfessorID = Professor.ProfessorID;


---

--### Exercise 4: Advanced Schema Design and Data Integrity


-- 1. Create the Department table
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL,
    Location VARCHAR(100)
);

-- 2. Create the Professor table
CREATE TABLE Professor (
    ProfessorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    HireDate DATE
);

-- 3. Create the Course table
CREATE TABLE Course (
    CourseID INT PRIMARY KEY AUTO_INCREMENT,
    CourseName VARCHAR(150) NOT NULL,
    Credits INT,
    DepartmentID INT,
    ProfessorID INT,
    ClassroomID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (ProfessorID) REFERENCES Professor(ProfessorID),
    FOREIGN KEY (ClassroomID) REFERENCES Classroom(ClassroomID)
);

-- 4. Create the Enrollment table
CREATE TABLE Enrollment (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    UNIQUE (StudentID, CourseID)
);

-- 5. Create the Classroom table
CREATE TABLE Classroom (
    ClassroomID INT PRIMARY KEY AUTO_INCREMENT,
    RoomNumber VARCHAR(10) NOT NULL,
    Building VARCHAR(50)
);

-- 6. Insert sample data into the tables
INSERT INTO Department (DepartmentName, Location) VALUES
('Computer Science', 'Building A'),
('Mathematics', 'Building B');

INSERT INTO Professor (FirstName, LastName, Email, HireDate) VALUES
('John', 'Doe', 'john.doe@university.com', '2010-08-15'),
('Jane', 'Smith', 'jane.smith@university.com', '2012-09-10');

INSERT INTO Course (CourseName, Credits, DepartmentID, ProfessorID) VALUES
('Algorithms', 4, 1, 1),
('Calculus', 3, 2, 2);

INSERT INTO Student (Name, Age, Email, EnrollmentDate) VALUES
('Alice Johnson', 20, 'alice.johnson@example.com', '2024-01-01'),
('Bob Smith', 22, 'bob.smith@example.com', '2024-01-01');

INSERT INTO Classroom (RoomNumber, Building) VALUES
('101', 'Science Building'),
('202', 'Math Building');

-- 7. Add ClassroomID to the Course table
ALTER TABLE Course ADD COLUMN ClassroomID INT;

-- 8. Establish relationships and constraints
ALTER TABLE Course
ADD CONSTRAINT