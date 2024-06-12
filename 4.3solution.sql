CREATE DATABASE AirlineDB;

USE AirlineDB;

-- Table for Avion
CREATE TABLE Avion (
    IdAvion INT PRIMARY KEY,
    nom VARCHAR(100),
    catégorie VARCHAR(50),
    NbPlaces INT,
    Dateconstruction DATE,
    IdConstructeur INT
);

-- Table for Constructeur
CREATE TABLE Constructeur (
    IdConstructeur INT PRIMARY KEY,
    nom VARCHAR(100),
    pays VARCHAR(50)
);

-- Table for Pilote
CREATE TABLE Pilote (
    IdPilote INT PRIMARY KEY,
    nom VARCHAR(100),
    prénom VARCHAR(100),
    nationalité VARCHAR(50)
);

-- Table for Piloter
CREATE TABLE Piloter (
    IdAvion INT,
    IdPilote INT,
    PRIMARY KEY (IdAvion, IdPilote),
    FOREIGN KEY (IdAvion) REFERENCES Avion(IdAvion),
    FOREIGN KEY (IdPilote) REFERENCES Pilote(IdPilote)
);

-- Table for Aéroport
CREATE TABLE Aéroport (
    IdAer INT PRIMARY KEY,
    nom VARCHAR(100),
    ville VARCHAR(100)
);

-- Table for Dessert
CREATE TABLE Dessert (
    IdAer INT,
    IdAvion INT,
    NB_Fois_Semaine INT,
    PRIMARY KEY (IdAer, IdAvion),
    FOREIGN KEY (IdAer) REFERENCES Aéroport(IdAer),
    FOREIGN KEY (IdAvion) REFERENCES Avion(IdAvion)
);

-- Table for Achat
CREATE TABLE Achat (
    IdAchat INT PRIMARY KEY,
    IdAvion INT,
    IdCompagnie INT,
    DateAchat DATE,
    Quantité INT,
    FOREIGN KEY (IdAvion) REFERENCES Avion(IdAvion),
    FOREIGN KEY (IdCompagnie) REFERENCES Compagnie(IdCompagnie)
);

-- Table for Compagnie
CREATE TABLE Compagnie (
    IdCompagnie INT PRIMARY KEY,
    nom VARCHAR(100),
    contact VARCHAR(100)
);



INSERT INTO Constructeur (IdConstructeur, nom, pays)
VALUES
(1, 'Boeing', 'USA'),
(2, 'Airbus', 'France'),
(3, 'Embraer', 'Brazil');



INSERT INTO Avion (IdAvion, nom, catégorie, NbPlaces, Dateconstruction, IdConstructeur)
VALUES
(1, 'Boeing 777', 'Wide-body', 396, '2005-05-01', 1),
(2, 'Airbus A320', 'Narrow-body', 180, '2000-07-15', 2),
(3, 'Boeing 767', 'Wide-body', 375, '1995-10-30', 1),
(4, 'Embraer 190', 'Regional', 100, '2010-09-12', 3),
(5, 'Boeing 737', 'Narrow-body', 215, '2011-11-05', 1);



INSERT INTO Pilote (IdPilote, nom, prénom, nationalité)
VALUES
(1, 'Smith', 'John', 'USA'),
(2, 'Doe', 'Jane', 'USA'),
(3, 'Alami', 'Ali', 'Algérienne'),
(4, 'Ben Ahmed', 'Karim', 'Algérienne');



INSERT INTO Piloter (IdAvion, IdPilote)
VALUES
(1, 3),
(1, 4),
(2, 1),
(3, 2),
(4, 3),
(5, 4);



INSERT INTO Aéroport (IdAer, nom, ville)
VALUES
(1, 'Aéroport dAlger', 'Alger'),
(2, 'Aéroport de Paris', 'Paris'),
(3, 'Aéroport de New York', 'New York');



INSERT INTO Dessert (IdAer, IdAvion, NB_Fois_Semaine)
VALUES
(1, 1, 5),
(1, 2, 10),
(2, 3, 15),
(2, 4, 8),
(3, 5, 12),
(3, 1, 7);



INSERT INTO Compagnie (IdCompagnie, nom, contact)
VALUES
(1, 'Air-Algérie', 'contact@airalgerie.dz'),
(2, 'Air France', 'contact@airfrance.fr'),
(3, 'American Airlines', 'contact@aa.com');



INSERT INTO Achat (IdAchat, IdAvion, IdCompagnie, DateAchat, Quantité)
VALUES
(1, 1, 1, '2020-01-01', 3),
(2, 2, 2, '2019-03-15', 5),
(3, 3, 3, '2018-06-20', 2),
(4, 4, 1, '2021-08-30', 1),
(5, 5, 2, '2017-04-12', 4),
(6, 1, 2, '2016-02-05', 6),
(7, 3, 1, '2022-11-22', 3);






--! Task 1: Boeing 777 Piloted by Algerian Pilots Before 2010

SELECT a.*
FROM Avion a
JOIN Piloter p ON a.IdAvion = p.IdAvion
JOIN Pilote pi ON p.IdPilote = pi.IdPilote
WHERE a.nom = 'Boeing 777'
  AND pi.nationalité = 'Algérienne'
  AND a.Dateconstruction < '2010-01-01';


--! Task 2: Avions Piloted Only by Algerian Pilots

SELECT a.*
FROM Avion a
WHERE NOT EXISTS (
    SELECT 1
    FROM Piloter p
    JOIN Pilote pi ON p.IdPilote = pi.IdPilote
    WHERE p.IdAvion = a.IdAvion
      AND pi.nationalité != 'Algérienne'
);


--! Task 3: Companies That Have Not Bought Any Boeing

SELECT c.*
FROM Compagnie c
WHERE NOT EXISTS (
    SELECT 1
    FROM Achat ac
    JOIN Avion a ON ac.IdAvion = a.IdAvion
    WHERE ac.IdCompagnie = c.IdCompagnie
      AND a.nom LIKE '%Boeing%'
);



SELECT c.*
FROM Compagnie c
WHERE c.IdCompagnie NOT IN (
    SELECT ac.IdCompagnie
    FROM Achat ac
    JOIN Avion a ON ac.IdAvion = a.IdAvion
    WHERE a.nom LIKE '%Boeing%'
);


--! Task 4: Pilots Who Piloted Boeing or Airbus

SELECT DISTINCT pi.*
FROM Pilote pi
JOIN Piloter p ON pi.IdPilote = p.IdPilote
JOIN Avion a ON p.IdAvion = a.IdAvion
JOIN Constructeur c ON a.IdConstructeur = c.IdConstructeur
WHERE c.nom IN ('Boeing', 'Airbus');


--! Task 5: Pilots Who Piloted Both Boeing and Airbus

SELECT pi.*
FROM Pilote pi
WHERE EXISTS (
    SELECT 1
    FROM Piloter p
    JOIN Avion a ON p.IdAvion = a.IdAvion
    JOIN Constructeur c ON a.IdConstructeur = c.IdConstructeur
    WHERE p.IdPilote = pi.IdPilote
      AND c.nom = 'Boeing'
)
AND EXISTS (
    SELECT 1
    FROM Piloter p
    JOIN Avion a ON p.IdAvion = a.IdAvion
    JOIN Constructeur c ON a.IdConstructeur = c.IdConstructeur
    WHERE p.IdPilote = pi.IdPilote
      AND c.nom = 'Airbus'
);


--! Task 6: Most Purchased Plane by Air-Algérie

SELECT a.*, SUM(ac.Quantité) AS TotalQuantity
FROM Avion a
JOIN Achat ac ON a.IdAvion = ac.IdAvion
JOIN Compagnie c ON ac.IdCompagnie = c.IdCompagnie
WHERE c.nom = 'Air-Algérie'
GROUP BY a.IdAvion
ORDER BY TotalQuantity DESC
LIMIT 1;


--! Task 7: Companies That Have Only Bought Airbus Planes

SELECT c.*
FROM Compagnie c
WHERE NOT EXISTS (
    SELECT 1
    FROM Achat ac
    JOIN Avion a ON ac.IdAvion = a.IdAvion
    JOIN Constructeur co ON a.IdConstructeur = co.IdConstructeur
    WHERE ac.IdCompagnie = c.IdCompagnie
      AND co.nom != 'Airbus'
);


--! Task 8: Average Price of Planes by Category

SELECT a.catégorie, AVG(ac.Quantité) AS AveragePrice
FROM Avion a
JOIN Achat ac ON a.IdAvion = ac.IdAvion
GROUP BY a.catégorie;


--! Task 9: Airports Served by at Least 10 Boeing 767s per Week

SELECT aer.*
FROM Aéroport aer
JOIN Dessert d ON aer.IdAer = d.IdAer
JOIN Avion a ON d.IdAvion = a.IdAvion
WHERE a.nom = 'Boeing 767'
GROUP BY aer.IdAer
HAVING SUM(d.NB_Fois_Semaine) >= 10;


--! Task 10: Airports Served by at Least 10 Boeing Planes per Week

SELECT aer.*
FROM Aéroport aer
JOIN Dessert d ON aer.IdAer = d.IdAer
JOIN Avion a ON d.IdAvion = a.IdAvion
WHERE a.nom LIKE 'Boeing%'
GROUP BY aer.IdAer
HAVING SUM(d.NB_Fois_Semaine) >= 10;


--! Task 11: Companies and Planes Purchased Above Average

SELECT c.nom AS CompanyName, a.nom AS PlaneName
FROM Compagnie c
JOIN Achat ac ON c.IdCompagnie = ac.IdCompagnie
JOIN Avion a ON ac.IdAvion = a.IdAvion
GROUP BY c.IdCompagnie, a.IdAvion
HAVING SUM(ac.Quantité) > (
    SELECT AVG(ac2.Quantité)
    FROM Achat ac2
    WHERE ac2.IdAvion = a.IdAvion
);


--! Task 12: Total Sales by Constructor

SELECT c.IdConstructeur, c.nom, SUM(ac.Quantité) AS TotalSales
FROM Constructeur c
JOIN Avion a ON c.IdConstructeur = a.IdConstructeur
JOIN Achat ac ON a.IdAvion = ac.IdAvion
GROUP BY c.IdConstructeur, c.nom;


--! Task 13: Companies with More Than 5 Different Planes Purchased

SELECT c.IdCompagnie, c.nom, COUNT(DISTINCT ac.IdAvion) AS TotalPurchases
FROM Compagnie c
JOIN Achat ac ON c.IdCompagnie = ac.IdCompagnie
GROUP BY c.IdCompagnie, c.nom
HAVING COUNT(DISTINCT ac.IdAvion) > 5;


--! Task 14: Companies That Have Bought All Boeing Planes

SELECT c.*
FROM Compagnie c
WHERE NOT EXISTS (
    SELECT 1
    FROM Avion a
    JOIN Constructeur co ON a.IdConstructeur = co.IdConstructeur
    WHERE co.nom = 'Boeing'
      AND NOT EXISTS (
        SELECT 1
        FROM Achat ac
        WHERE ac.IdAvion = a.IdAvion
          AND ac.IdCompagnie = c.IdCompagnie
    )
);



SELECT c.*
FROM Compagnie c
JOIN Achat ac ON c.IdCompagnie = ac.IdCompagnie
JOIN Avion a ON ac.IdAvion = a.IdAvion
JOIN Constructeur co ON a.IdConstructeur = co.IdConstructeur
WHERE co.nom = 'Boeing'
GROUP BY c.IdCompagnie
HAVING COUNT(DISTINCT a.IdAvion) = (
    SELECT COUNT(*)
    FROM Avion a2
    JOIN Constructeur co2 ON a2.IdConstructeur = co2.IdConstructeur
    WHERE co2.nom = 'Boeing'
);


--! Task 15: Planes Serving All Airports

SELECT a.*
FROM Avion a
WHERE NOT EXISTS (
    SELECT 1
    FROM Aéroport aer
    WHERE NOT EXISTS (
        SELECT 1
        FROM Dessert d
        WHERE d.IdAer = aer.IdAer
          AND d.IdAvion = a.IdAvion
    )
);



SELECT a.*
FROM Avion a
JOIN Dessert d ON a.IdAvion = d.IdAvion
GROUP BY a.IdAvion
HAVING COUNT(DISTINCT d.IdAer) = (SELECT COUNT(*) FROM Aéroport);


--! Task 16: Companies Buying All Products of Company with ID 3

SELECT c.*
FROM Compagnie c
WHERE NOT EXISTS (
    SELECT 1
    FROM Achat ac3
    WHERE ac3.IdCompagnie = 3
      AND NOT EXISTS (
        SELECT 1
        FROM Achat ac
        WHERE ac.IdCompagnie = c.IdCompagnie
          AND ac.IdAvion = ac3.IdAvion
    )
);


--! Create Views


CREATE VIEW V_avion AS
SELECT nom, catégorie, NbPlaces
FROM Avion;



CREATE VIEW V_Boeing AS
SELECT *
FROM Avion
WHERE nom LIKE 'Boeing%';



CREATE VIEW V_Boeing_777 AS
SELECT *
FROM V_Boeing
WHERE nom = 'Boeing 777';

