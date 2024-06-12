-- !Create a new database
CREATE DATABASE CompanyDB;

-- !Use the created database
USE CompanyDB;

-- !Create a new table called Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT, -- *Primary key with auto-increment*
    DepartmentName VARCHAR(100) NOT NULL, -- *Department name must be provided*
    Location VARCHAR(100) -- *Location of the department*
);

-- !Create a new table called Employees with various constraints and data types
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT, -- *Primary key with auto-increment*
    FirstName VARCHAR(50) NOT NULL, -- *First name must be provided*
    LastName VARCHAR(50) NOT NULL, -- *Last name must be provided*
    Email VARCHAR(100) UNIQUE, -- *Email must be unique*
    DateOfBirth DATE, -- *Date of birth field*
    HireDate DATETIME DEFAULT CURRENT_TIMESTAMP, -- *Hire date with default current timestamp*
    Salary DECIMAL(10, 2) CHECK (Salary >= 0), -- *Salary must be a positive value*
    IsFullTime BOOLEAN DEFAULT TRUE, -- *Boolean to check if the employee is full-time*
    DepartmentID INT, -- *Foreign key to Departments table*
    CONSTRAINT fk_department FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) -- *Foreign key constraint*
);

-- !Create a new table called Projects
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY AUTO_INCREMENT, -- *Primary key with auto-increment*
    ProjectName VARCHAR(100) NOT NULL, -- *Project name must be provided*
    StartDate DATE, -- *Project start date*
    EndDate DATE, -- *Project end date*
    Budget DECIMAL(15, 2), -- *Project budget*
    DepartmentID INT, -- *Foreign key to Departments table*
    CONSTRAINT fk_project_department FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) -- *Foreign key constraint*
);

-- !Create a new table called EmployeeProjects to represent the many-to-many relationship
CREATE TABLE EmployeeProjects (
    EmployeeID INT, -- *Foreign key to Employees table*
    ProjectID INT, -- *Foreign key to Projects table*
    CONSTRAINT fk_employee FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    CONSTRAINT fk_project FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    PRIMARY KEY (EmployeeID, ProjectID) -- *Composite primary key*
);

-- !Insert data into the Departments table
INSERT INTO Departments (DepartmentName, Location) VALUES
('Human Resources', 'New York'),
('Finance', 'London'),
('IT', 'San Francisco'),
('Marketing', 'Berlin');

-- !Insert data into the Employees table
INSERT INTO Employees (FirstName, LastName, Email, DateOfBirth, Salary, DepartmentID) VALUES
('John', 'Doe', 'john.doe@example.com', '1980-01-15', 60000, 3),
('Jane', 'Smith', 'jane.smith@example.com', '1990-07-25', 75000, 2),
('Emily', 'Jones', 'emily.jones@example.com', '1985-03-12', 50000, 1),
('Mike', 'Brown', 'mike.brown@example.com', '1975-10-30', 95000, 3);

-- !Insert data into the Projects table
INSERT INTO Projects (ProjectName, StartDate, EndDate, Budget, DepartmentID) VALUES
('Project A', '2022-01-01', '2022-12-31', 1000000, 3),
('Project B', '2022-06-01', '2023-05-31', 500000, 1),
('Project C', '2023-01-01', '2023-12-31', 750000, 2);

-- !Insert data into the EmployeeProjects table
INSERT INTO EmployeeProjects (EmployeeID, ProjectID) VALUES
(1, 1),
(2, 2),
(3, 1),
(3, 3),
(4, 1);

-- !Update an employee's salary
UPDATE Employees
SET Salary = 80000
WHERE EmployeeID = 1;

-- !Update the location of a department
UPDATE Departments
SET Location = 'Chicago'
WHERE DepartmentName = 'IT';

-- !Delete an employee from the Employees table
DELETE FROM Employees
WHERE EmployeeID = 4;

-- !Delete a project from the Projects table
DELETE FROM Projects
WHERE ProjectID = 2;

-- !Select all records from the Employees table to view the current data
SELECT * FROM Employees;

-- !Select all records from the Departments table to view the current data
SELECT * FROM Departments;

-- !Select all records from the Projects table to view the current data
SELECT * FROM Projects;

-- !Select all records from the EmployeeProjects table to view the current data
SELECT * FROM EmployeeProjects;

-- !View all tables in the current database
SHOW TABLES;

-- !Describe the structure of the Employees table
DESCRIBE Employees;

-- !Describe the structure of the Departments table
DESCRIBE Departments;

-- !Describe the structure of the Projects table
DESCRIBE Projects;

-- !Describe the structure of the EmployeeProjects table
DESCRIBE EmployeeProjects;

-- !Drop the EmployeeProjects table
DROP TABLE EmployeeProjects;

-- !Drop the Employees table
DROP TABLE Employees;

-- !Drop the Projects table
DROP TABLE Projects;

-- !Drop the Departments table
DROP TABLE Departments;

-- !Drop the CompanyDB database
DROP DATABASE CompanyDB;
