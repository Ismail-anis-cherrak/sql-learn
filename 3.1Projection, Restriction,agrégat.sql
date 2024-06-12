-- --------------------------------------
-- Section 1: Projection
-- --------------------------------------

--* La projection consiste à sélectionner des colonnes spécifiques d'une table.
--* Utilisons la table "Employee" pour illustrer cela.

--! Créons la table "Employee" pour notre exemple.
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    DepartmentID INT,
    Salary DECIMAL(10, 2)
);

--! Insérons des données d'exemple.
INSERT INTO Employee (EmployeeID, Name, Age, DepartmentID, Salary) VALUES
(1, 'Alice Johnson', 30, 1, 50000.00),
(2, 'Bob Smith', 45, 2, 60000.00),
(3, 'Charlie Brown', 35, 1, 55000.00),
(4, 'Diana Prince', 28, 3, 45000.00);

--! Utilisons la projection pour sélectionner uniquement les noms et salaires des employés.
SELECT Name, Salary
FROM Employee;

--! Projection avec des alias pour une meilleure lisibilité.
SELECT Name AS EmployeeName, Salary AS EmployeeSalary
FROM Employee;

--! Projection avec des colonnes calculées (exemple : augmentation du salaire de 10%).
SELECT Name, Salary, Salary * 1.10 AS SalaryWithIncrease
FROM Employee;

--! Projection avec des conditions (exemple : sélection des employés avec un salaire supérieur à 50000).
SELECT Name, Salary
FROM Employee
WHERE Salary > 50000;

-- --------------------------------------
-- Section 2: Restriction
-- --------------------------------------

--? La restriction consiste à filtrer les lignes d'une table selon des conditions spécifiques.
--? Utilisons la même table "Employee".

--! Sélectionnons les employés de plus de 30 ans.
SELECT *
FROM Employee
WHERE Age > 30;

--! Restriction avec une condition sur le département.
SELECT Name, DepartmentID
FROM Employee
WHERE DepartmentID = 1;

--! Utilisons plusieurs conditions avec AND et OR.
SELECT Name, Age, DepartmentID, Salary
FROM Employee
WHERE Age > 30 AND DepartmentID = 1;

SELECT Name, Age, DepartmentID, Salary
FROM Employee
WHERE Age < 30 OR Salary > 55000.00;

-- --------------------------------------
-- Section 3: Fonction d'agrégat
-- --------------------------------------

--* Les fonctions d'agrégat sont utilisées pour effectuer des calculs sur des ensembles de valeurs et renvoyer un seul résultat.
--* Utilisons les fonctions d'agrégat COUNT, SUM, AVG, MIN, MAX sur la table "Employee".

--! Compter le nombre d'employés.
SELECT COUNT(*) AS TotalEmployees
FROM Employee;

--! Calculer le salaire total des employés.
SELECT SUM(Salary) AS TotalSalary
FROM Employee;

--! Calculer le salaire moyen des employés.
SELECT AVG(Salary) AS AverageSalary
FROM Employee;

--! Trouver le salaire minimum des employés.
SELECT MIN(Salary) AS MinimumSalary
FROM Employee;

--! Trouver le salaire maximum des employés.
SELECT MAX(Salary) AS MaximumSalary
FROM Employee;

--! Combiner plusieurs fonctions d'agrégat dans une seule requête.
SELECT 
    COUNT(*) AS TotalEmployees,
    SUM(Salary) AS TotalSalary,
    AVG(Salary) AS AverageSalary,
    MIN(Salary) AS MinimumSalary,
    MAX(Salary) AS MaximumSalary
FROM Employee;

-- --------------------------------------
-- Section 4: Cas Spéciaux de Projection et Jointures
-- --------------------------------------

--! Projection avec des jointures (exemple : joindre Employee avec Department)
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

INSERT INTO Department (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'Engineering'),
(3, 'Marketing');

--! Jointure entre Employee et Department
SELECT 
    Employee.Name AS EmployeeName, 
    Employee.Salary, 
    Department.DepartmentName
FROM Employee
JOIN Department ON Employee.DepartmentID = Department.DepartmentID;

--! Projection avec une jointure externe (LEFT JOIN)
SELECT 
    Employee.Name AS EmployeeName, 
    Department.DepartmentName
FROM Employee
LEFT JOIN Department ON Employee.DepartmentID = Department.DepartmentID;

--! Projection avec une jointure interne (INNER JOIN) avec une condition
SELECT 
    Employee.Name, 
    Department.DepartmentName
FROM Employee
INNER JOIN Department ON Employee.DepartmentID = Department.DepartmentID
WHERE Employee.Salary > 50000;

-- --------------------------------------
-- Section 5: Exemple Complet avec Jointures et Fonction d'agrégat
-- --------------------------------------

--! Ajoutons plus de tables pour un exemple plus complexe
CREATE TABLE Classroom (
    ClassroomID INT PRIMARY KEY,
    RoomNumber VARCHAR(10),
    Building VARCHAR(50)
);

INSERT INTO Classroom (ClassroomID, RoomNumber, Building) VALUES
(1, '101', 'Science Building'),
(2, '202', 'Math Building');

CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    Credits INT,
    DepartmentID INT,
    ClassroomID INT,
    ProfessorID INT
);

INSERT INTO Course (CourseID, CourseName, Credits, DepartmentID, ClassroomID, ProfessorID) VALUES
(1, 'Algorithms', 4, 1, 1, 1),
(2, 'Calculus', 3, 2, 2, 2);

CREATE TABLE Professor (
    ProfessorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    HireDate DATE
);

INSERT INTO Professor (ProfessorID, FirstName, LastName, Email, HireDate) VALUES
(1, 'John', 'Doe', 'john.doe@university.com', '2010-08-15'),
(2, 'Jane', 'Smith', 'jane.smith@university.com', '2012-09-10');

--! Jointure entre toutes les tables pour une vue complète
SELECT 
    Employee.Name AS EmployeeName, 
    Employee.Salary, 
    Department.DepartmentName,
    Course.CourseName,
    Classroom.RoomNumber,
    Classroom.Building
FROM Employee
JOIN Department ON Employee.DepartmentID = Department.DepartmentID
JOIN Course ON Department.DepartmentID = Course.DepartmentID
JOIN Classroom ON Course.ClassroomID = Classroom.ClassroomID
WHERE Employee.Salary > 50000;

--! Fonction d'agrégat avec groupement et jointure
SELECT 
    Department.DepartmentName,
    COUNT(Employee.EmployeeID) AS NumberOfEmployees,
    AVG(Employee.Salary) AS AverageSalary
FROM Employee
JOIN Department ON Employee.DepartmentID = Department.DepartmentID
GROUP BY Department.DepartmentName;

--! Trier les résultats par salaire moyen en ordre décroissant.
SELECT 
    Department.DepartmentName,
    COUNT(Employee.EmployeeID) AS NumberOfEmployees,
    AVG(Employee.Salary) AS AverageSalary
FROM Employee
JOIN Department ON Employee.DepartmentID = Department.DepartmentID
GROUP BY Department.DepartmentName
ORDER BY AverageSalary DESC;

--! Filtrons les départements ayant un salaire moyen supérieur à 50000.
SELECT 
    Department.DepartmentName,
    COUNT(Employee.EmployeeID) AS NumberOfEmployees,
    AVG(Employee.Salary) AS AverageSalary
FROM Employee
JOIN Department ON Employee.DepartmentID = Department.DepartmentID
GROUP BY Department.DepartmentName
HAVING AVG(Employee.Salary) > 50000;
