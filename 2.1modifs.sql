-- Création de la base de données SchoolDB et des tables
CREATE DATABASE IF NOT EXISTS SchoolDB;
USE SchoolDB;



-- Table Salle : Représente les salles disponibles
CREATE TABLE IF NOT EXISTS Salle (
    IdSalle INT PRIMARY KEY AUTO_INCREMENT,  -- Identifiant unique de la salle
    NomSalle VARCHAR(30) NOT NULL,           -- Nom de la salle (taille maximale 30, obligatoire)
    NbChaise INT,                            -- Nombre de chaises dans la salle
    NbTable INT                                -- Nombre de tables dans la salle
);

-- Table Etudiant : Représente les étudiants inscrits
CREATE TABLE IF NOT EXISTS Etudiant (
    IdEtudiant INT PRIMARY KEY AUTO_INCREMENT, -- Identifiant unique de l'étudiant
    NomEtudiant VARCHAR(50) NOT NULL,          -- Nom de l'étudiant (taille maximale 50, obligatoire)
    PrenomEtudiant VARCHAR(50) NOT NULL,       -- Prénom de l'étudiant (taille maximale 50, obligatoire)
    Email VARCHAR(100) UNIQUE,                 -- Adresse email unique de l'étudiant
    DateNaissance DATE                         -- Date de naissance de l'étudiant
);

-- Table Prof : Représente les enseignants
CREATE TABLE IF NOT EXISTS Prof (
    IdProf INT PRIMARY KEY AUTO_INCREMENT,     -- Identifiant unique du professeur
    NomProf VARCHAR(50) NOT NULL,              -- Nom du professeur (taille maximale 50, obligatoire)
    PrenomProf VARCHAR(50) NOT NULL,           -- Prénom du professeur (taille maximale 50, obligatoire)
    NbHeure TINYINT DEFAULT 9,                 -- Charge horaire du professeur par semaine (par défaut 9 heures)
    CONSTRAINT uq_idprof UNIQUE (IdProf)       -- Contrainte d'unicité sur IdProf pour éviter les doublons
);

-- Table Enseigne : Représente les enseignements dispensés
CREATE TABLE IF NOT EXISTS Enseigne (
    IdSalle INT,
    IdEtudiant INT,
    IdProf INT,
    DateEnseig DATE,                            -- Date de l'enseignement
    PRIMARY KEY(IdSalle, IdEtudiant, IdProf),   -- Clé primaire composite
    CONSTRAINT fk_salle FOREIGN KEY (IdSalle) REFERENCES Salle(IdSalle),  -- Clé étrangère vers Salle
    CONSTRAINT fk_etudiant FOREIGN KEY (IdEtudiant) REFERENCES Etudiant(IdEtudiant),  -- Clé étrangère vers Etudiant
    CONSTRAINT fk_prof FOREIGN KEY (IdProf) REFERENCES Prof(IdProf)       -- Clé étrangère vers Prof
);

-- **2. Ajouter une nouvelle colonne **

-- Ajouter une colonne Email dans la table Etudiant pour l'adresse email de l'étudiant
ALTER TABLE Etudiant
ADD COLUMN Email VARCHAR(100) UNIQUE;  -- Colonne Email, taille maximale 100, valeur unique

-- **3. Supprimer une colonne **

-- Supprimer la colonne NbTable de la table Salle (plus utilisée)
ALTER TABLE Salle
DROP COLUMN NbTable;

-- **4. Modifier une colonne **

-- Modifier la taille de NomSalle de VARCHAR(30) à VARCHAR(40) dans la table Salle
ALTER TABLE Salle
MODIFY COLUMN NomSalle VARCHAR(40) NOT NULL;

-- Modifier le type de NbHeure de INT à TINYINT dans la table Prof pour économiser de l'espace
ALTER TABLE Prof
MODIFY COLUMN NbHeure TINYINT;

-- **5. Ajouter une contrainte d'intégrité **

-- Ajouter une contrainte d'unicité sur IdProf pour éviter les doublons dans la table Prof
ALTER TABLE Prof
ADD CONSTRAINT uq_idprof UNIQUE (IdProf);

-- Ajouter une contrainte CHECK pour s'assurer que NbHeure ne dépasse pas 22 heures par semaine
ALTER TABLE Prof
ADD CONSTRAINT chk_nbheure CHECK (NbHeure <= 22);

-- **6. Modifier une contrainte **

-- Supprimer la contrainte fk_prof dans la table Enseigne pour la réorganiser
ALTER TABLE Enseigne
DROP FOREIGN KEY fk_prof;

-- Ajouter une nouvelle contrainte fk_prof avec une clé étrangère vers Prof(IdProf) dans la table Enseigne
ALTER TABLE Enseigne
ADD CONSTRAINT fk_prof FOREIGN KEY (IdProf) REFERENCES Prof(IdProf);

-- **7. Ajouter une nouvelle table **

-- Table Classe pour représenter les classes dans l'établissement
CREATE TABLE IF NOT EXISTS Classe (
    IdClasse INT PRIMARY KEY AUTO_INCREMENT,  -- Identifiant unique de la classe
    NomClasse VARCHAR(50) NOT NULL            -- Nom de la classe (taille maximale 50, obligatoire)
);

-- Ajouter une colonne IdClasse dans la table Etudiant comme clé étrangère vers Classe(IdClasse)
ALTER TABLE Etudiant
ADD COLUMN IdClasse INT,
ADD CONSTRAINT fk_classe FOREIGN KEY (IdClasse) REFERENCES Classe(IdClasse);

-- **8. Supprimer une table **

-- Supprimer la table Classe si elle n'est plus utilisée ou nécessaire
DROP TABLE IF EXISTS Classe;

-- **9. Afficher la structure des tables **

-- Afficher la structure de la table Salle pour comprendre ses colonnes et clés
DESCRIBE Salle;

-- Afficher la structure de la table Etudiant pour comprendre ses colonnes et clés
DESCRIBE Etudiant;

-- Afficher la structure de la table Prof pour comprendre ses colonnes et clés
DESCRIBE Prof;

-- Afficher la structure de la table Enseigne pour comprendre ses colonnes et clés
DESCRIBE Enseigne;
