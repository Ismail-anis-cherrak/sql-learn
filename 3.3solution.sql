--! Create the database

CREATE DATABASE FootballDB;
USE FootballDB;

--! Create the tables

CREATE TABLE Equipe (
    IdEqui INT PRIMARY KEY,
    Nom VARCHAR(50),
    Ville VARCHAR(50)
);

CREATE TABLE Footballeur (
    IdFoot INT PRIMARY KEY,
    Nom VARCHAR(50),
    Poste VARCHAR(50),
    DateDeb DATE,
    Salaire DECIMAL(10, 2),
    IdEqui INT,
    FOREIGN KEY (IdEqui) REFERENCES Equipe(IdEqui)
);

--! Insert sample data into Equipe

INSERT INTO Equipe (IdEqui, Nom, Ville) VALUES
(1, 'JS Kabylie', 'Tizi Ouzou'),
(2, 'MC Alger', 'Alger'),
(3, 'USM Alger', 'Alger'),
(4, 'ES Setif', 'Setif'),
(5, 'USM Bel Abbes', 'Sidi Bel Abbes');

--! Insert sample data into Footballeur

INSERT INTO Footballeur (IdFoot, Nom, Poste, DateDeb, Salaire, IdEqui) VALUES
(1, 'Ahmed', 'Attaquant', '2015-03-15', 90000, 1),
(2, 'Karim', 'Défenseur', '2016-06-20', 85000, 2),
(3, 'Ali', 'Milieu', '2014-01-11', 80000, 3),
(4, 'Said', 'Défenseur', '2018-02-17', 95000, 4),
(5, 'Mohamed', 'Attaquant', '2017-05-23', 87000, 5),
(6, 'Zinedine', 'Gardien', '2013-08-09', 65000, 1),
(7, 'Yacine', 'Défenseur axial', '2019-09-01', 90000, 2),
(8, 'Hassan', 'Ailier gauche', '2012-07-14', 92000, 3),
(9, 'Omar', 'Défenseur', '2020-04-19', 88000, 4),
(10, 'Houssam', 'Attaquant', '2011-10-10', 83000, 5);

--! 1. Donner les noms et les salaires des footballeurs.

SELECT Nom, Salaire FROM Footballeur;

--! 2. Donner les postes des footballeurs (après élimination des duplicatas).

SELECT DISTINCT Poste FROM Footballeur;

--! 3. Donner les dates de début de contrat des défenseurs axiaux.

SELECT DateDeb FROM Footballeur WHERE Poste = 'Défenseur axial';

--! 4. Faire le produit cartésien entre footballeurs et équipes.

SELECT * FROM Footballeur, Equipe;

--! 5. Donner les noms des footballeurs et les noms de leurs équipes.

SELECT f.Nom AS FootballeurNom, e.Nom AS EquipeNom
FROM Footballeur f
JOIN Equipe e ON f.IdEqui = e.IdEqui;

--! 6. Donner les numéros des footballeurs qui évoluent à Alger.

SELECT f.IdFoot FROM Footballeur f
JOIN Equipe e ON f.IdEqui = e.IdEqui
WHERE e.Ville = 'Alger';

--! 7. Donner les noms des footballeurs des équipes 2 et 5, et dont le salaire est supérieur à 80000. Proposer trois solutions différentes.

SELECT Nom FROM Footballeur WHERE IdEqui IN (2, 5) AND Salaire > 80000;
SELECT Nom FROM Footballeur WHERE (IdEqui = 2 OR IdEqui = 5) AND Salaire > 80000;
SELECT Nom FROM Footballeur WHERE (IdEqui = 2 OR IdEqui = 5) AND Salaire > 80000;

--! 8. Donner les noms des footballeurs qui jouent à différents postes.

SELECT Nom FROM Footballeur
GROUP BY Nom
HAVING COUNT(DISTINCT Poste) > 1;

--! 9. Donner les noms des footballeurs dont la date de début de contrat est spécifiée.

SELECT Nom FROM Footballeur WHERE DateDeb IS NOT NULL;

--! 10. Afficher pour chaque footballeur la concaténation de son nom et son poste séparés par un espace en utilisant la fonction « concat » et lui donner comme libellé à l'affichage ''Nom & Poste''

SELECT CONCAT(Nom, ' ', Poste) AS 'Nom & Poste' FROM Footballeur;

--! 11. Donner le nombre des footballeurs ;

SELECT COUNT(*) AS NombreFootballeurs FROM Footballeur;

--! 12. Donner le nombre des footballeurs qui ont été recrutés entre le 2013-01-01 et le 2017-12-31.

SELECT COUNT(*) AS NombreRecrutes FROM Footballeur
WHERE DateDeb BETWEEN '2013-01-01' AND '2017-12-31';

--! 13. Donner le nombre des attaquants évoluent a SBA.

SELECT COUNT(*) AS NombreAttaquants FROM Footballeur f
JOIN Equipe e ON f.IdEqui = e.IdEqui
WHERE f.Poste = 'Attaquant' AND e.Ville = 'Sidi Bel Abbes';

--! 14. Donner le nombre de postes dans l’équipe de USM Alger.

SELECT COUNT(DISTINCT Poste) AS NombrePostes FROM Footballeur
WHERE IdEqui = 3;

--! 15. Donner le nom des footballeurs dont le nom commence par ‘a’ ;

SELECT Nom FROM Footballeur WHERE Nom LIKE 'a%';

--! 16. Donner le nombre des footballeurs dont le nom contient la chaine ‘abd’.

SELECT COUNT(*) AS NombreFootballeurs FROM Footballeur
WHERE Nom LIKE '%abd%';

--! 17. Donner le nombre de noms contenant la chaine ‘abd’.

SELECT COUNT(DISTINCT Nom) AS NombreNoms FROM Footballeur
WHERE Nom LIKE '%abd%';

--! 18. Afficher la différence entre le salaire le plus élevé et le salaire le plus bas. Nommer le résultat « Différence ».

SELECT MAX(Salaire) - MIN(Salaire) AS Différence FROM Footballeur;

--! 19. Donner les noms des footballeurs qui évoluent dans une équipe avec au moins un ailier gauche.

SELECT f1.Nom FROM Footballeur f1
WHERE EXISTS (
    SELECT 1 FROM Footballeur f2
    WHERE f2.IdEqui = f1.IdEqui AND f2.Poste = 'Ailier gauche'
);

--! 20. Donner le salaire et le nom des footballeurs gagnant plus qu’un (au moins un) défenseur.

SELECT Salaire, Nom FROM Footballeur
WHERE Salaire > (SELECT MIN(Salaire) FROM Footballeur WHERE Poste = 'Défenseur');

--! 21. Donner le salaire et le nom des footballeurs gagnant plus que tous les défenseurs.

SELECT Salaire, Nom FROM Footballeur
WHERE Salaire > (SELECT MAX(Salaire) FROM Footballeur WHERE Poste = 'Défenseur');

--! 22. Trouver les noms des footballeurs ayant la même équipe que Ahmed.

SELECT f2.Nom FROM Footballeur f1
JOIN Footballeur f2 ON f1.IdEqui = f2.IdEqui
WHERE f1.Nom = 'Ahmed' AND f2.Nom <> 'Ahmed';

--! 23. Donner le nom et la date de début de contrat des footballeurs embauchés avant au moins un de leur défenseur ; donner également le nom et la date de début de contrat de leur défenseur.

SELECT f1.Nom, f1.DateDeb, f2.Nom AS DefenseurNom, f2.DateDeb AS DefenseurDateDeb
FROM Footballeur f1
JOIN Footballeur f2 ON f1.IdEqui = f2.IdEqui AND f2.Poste = 'Défenseur'
WHERE f1.DateDeb < f2.DateDeb;

--! 24. Donner les équipes qui n’ont pas d’ailier droit.

SELECT e.Nom FROM Equipe e
WHERE NOT EXISTS (
    SELECT 1 FROM Footballeur f
    WHERE f.IdEqui = e.IdEqui AND f.Poste = 'Ailier droit'
);

--! 25. Donner les noms des footballeurs de l’équipe JS Kabylie recruter le même jour qu’un footballeur de l’équipe MC Alger.

SELECT f1.Nom FROM Footballeur f1
JOIN Footballeur f2 ON f1.DateDeb = f2.DateDeb
WHERE f1.IdEqui = 1 AND f2.IdEqui = 2;

--! 26. Donner les noms des footballeurs recruter avant tous les footballeurs de l’équipe 3.

SELECT Nom FROM Footballeur
WHERE DateDeb < (SELECT MIN(DateDeb) FROM Footballeur WHERE IdEqui = 3);

--! 27. Donner les noms des footballeurs ayant le même poste que Ahmed.

SELECT f2.Nom FROM Footballeur f1
JOIN Footballeur f2 ON f1.Poste = f2.Poste
WHERE f1.Nom = 'Ahmed' AND f2.Nom <> 'Ahmed';

--! 28. Donner les noms, postes et salaires des footballeurs par poste croissant (du gardien de but à l’attaquant) et, pour chaque poste, par salaire décroissant.

SELECT Nom, Poste, Salaire FROM Footballeur
ORDER BY Poste, Salaire DESC;

--! 29. Donner le salaire moyen des footballeurs.

SELECT AVG(Salaire) AS SalaireMoyen FROM Footballeur;

--! 30. Donner le nombre de footballeurs de l’équipe USM Bel Abbes.

SELECT COUNT(*) AS NombreFootballeurs FROM Footballeur
WHERE IdEqui = 5;

--! 31. Donner les numéros des équipes et leur salaire maximum.

SELECT IdEqui, MAX(Salaire) AS SalaireMax FROM Footballeur
GROUP BY IdEqui;

--! 32. Donner les noms des footballeurs ayant le salaire maximum de chaque équipe.

SELECT f.Nom FROM Footballeur f
JOIN (
    SELECT IdEqui, MAX(Salaire) AS MaxSalaire FROM Footballeur
    GROUP BY IdEqui
) AS sub ON f.IdEqui = sub.IdEqui AND f.Salaire = sub.MaxSalaire;

--! 33. Donner les postes et leur salaire moyen.

SELECT Poste, AVG(Salaire) AS SalaireMoyen FROM Footballeur
GROUP BY Poste;

--! 34. Donner le salaire moyen le plus bas par poste.

SELECT MIN(SalaireMoyen) AS SalaireMoyenLePlusBas FROM (
    SELECT AVG(Salaire) AS SalaireMoyen FROM Footballeur
    GROUP BY Poste
) AS sub;

--! 35. Donner les postes ayant le salaire moyen le plus bas.

SELECT Poste FROM Footballeur
GROUP BY Poste
ORDER BY AVG(Salaire)
LIMIT 1;
