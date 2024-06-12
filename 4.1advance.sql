-- Création de la base de données (si nécessaire)
CREATE DATABASE advanced_sql_concepts;
USE advanced_sql_concepts;

-- Création des Tables

-- Création de la table departments
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(255) NOT NULL
);

-- Création de la table employees
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    department_id INT,
    salary DECIMAL(10, 2),
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- Création de la table courses
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(255) NOT NULL
);

-- Création de la table students
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL
);

-- Création de la table enrollments
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- Création de la table accounts
CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(10, 2)
);

-- Insertion des Données

-- Insertion des données dans la table departments
INSERT INTO departments (department_name) VALUES ('Sales'), ('Engineering'), ('HR');

-- Insertion des données dans la table employees
INSERT INTO employees (name, department_id, salary) VALUES
('Alice', 1, 50000),
('Bob', 2, 60000),
('Charlie', 3, 55000),
('David', NULL, 40000);

-- Insertion des données dans la table courses
INSERT INTO courses (course_name) VALUES ('Math'), ('Science'), ('History');

-- Insertion des données dans la table students
INSERT INTO students (name) VALUES ('Eve'), ('Frank'), ('Grace');

-- Insertion des données dans la table enrollments
INSERT INTO enrollments (student_id, course_id) VALUES
(1, 1), (1, 2), (2, 1), (2, 3), (3, 1), (3, 2), (3, 3);

-- Insertion des données dans la table accounts
INSERT INTO accounts (balance) VALUES (1000), (2000);

-- Jointures

-- Jointure Interne (INNER JOIN)
-- Sélectionne les employés avec leur département respectif où les correspondances existent
SELECT employees.name, departments.department_name
FROM employees
INNER JOIN departments ON employees.department_id = departments.id;

-- Jointure Externe Gauche (LEFT JOIN)
-- Sélectionne tous les employés avec leur département, incluant ceux sans département
SELECT employees.name, departments.department_name
FROM employees
LEFT JOIN departments ON employees.department_id = departments.id;

-- Jointure Externe Droite (RIGHT JOIN)
-- Sélectionne tous les départements avec leurs employés, incluant les départements sans employés
SELECT employees.name, departments.department_name
FROM employees
RIGHT JOIN departments ON employees.department_id = departments.id;

-- Jointure Complète (FULL OUTER JOIN)
-- Sélectionne tous les employés et tous les départements, incluant les employés sans département et les départements sans employés
-- Note : FULL OUTER JOIN n'est pas supporté par MySQL. En PostgreSQL :
SELECT employees.name, departments.department_name
FROM employees
FULL OUTER JOIN departments ON employees.department_id = departments.id;

-- Jointure Croisée (CROSS JOIN)
-- Produit cartésien des employés et des départements
SELECT employees.name, departments.department_name
FROM employees
CROSS JOIN departments;

-- Regroupement

-- Regroupement avec Agrégation
-- Compte le nombre d'employés par département
SELECT department_id, COUNT(*) AS num_employees
FROM employees
GROUP BY department_id;

-- Regroupement avec Condition sur les Groupes (HAVING)
-- Sélectionne les départements avec plus de 1 employé
SELECT department_id, COUNT(*) AS num_employees
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 1;

-- Requêtes Imbriquées

-- Requête Imbriquée dans la Clause WHERE
-- Sélectionne les noms des employés du département 'Sales'
SELECT name
FROM employees
WHERE department_id = (SELECT id FROM departments WHERE department_name = 'Sales');

-- Requête Imbriquée dans la Clause FROM
-- Calcule le salaire moyen par département et sélectionne ces moyennes
SELECT avg_salary
FROM (SELECT department_id, AVG(salary) AS avg_salary FROM employees GROUP BY department_id) AS dept_avg_salaries;

-- Requête Imbriquée dans la Clause SELECT
-- Sélectionne les noms des employés et leurs départements respectifs
SELECT name,
       (SELECT department_name FROM departments WHERE id = employees.department_id) AS department_name
FROM employees;

-- Division Relationnelle

-- Sélectionne les noms des étudiants inscrits à tous les cours offerts
SELECT s.name
FROM students s
WHERE NOT EXISTS (
    SELECT c.id
    FROM courses c
    WHERE NOT EXISTS (
        SELECT e.course_id
        FROM enrollments e
        WHERE e.student_id = s.id AND e.course_id = c.id
    )
);

-- Vues

-- Création d'une Vue
-- Vue des employés et de leurs départements respectifs
CREATE VIEW employee_department AS
SELECT employees.name, departments.department_name
FROM employees
INNER JOIN departments ON employees.department_id = departments.id;

-- Utilisation d'une Vue
-- Sélectionne toutes les lignes de la vue employee_department
SELECT * FROM employee_department;

-- Transactions

-- Démarrage d'une Transaction
BEGIN TRANSACTION;

-- Opérations SQL
-- Transfert d'argent entre deux comptes
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

-- Validation de la transaction
COMMIT;

-- Annulation de la transaction (en cas d'erreur)
ROLLBACK;

-- Transactions avec Gestion des Erreurs

-- Début de la transaction
BEGIN;

-- Bloc TRY pour capturer les erreurs
BEGIN TRY
    -- Opérations SQL
    -- Transfert d'argent entre deux comptes
    UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
    UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
    
    -- Validation de la transaction
    COMMIT;
END TRY
BEGIN CATCH
    -- En cas d'erreur, annuler la transaction
    ROLLBACK;
    -- Optionnel : afficher un message d'erreur
    PRINT 'Une erreur est survenue. La transaction a été annulée.';
END CATCH;
