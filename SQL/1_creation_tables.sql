-- =========================================================
-- Projet BD - Système de gestion d'enquêtes criminelles
-- Création des tables
-- SGBD : PostgreSQL
-- =========================================================

CREATE TABLE personne (
    id_personne INT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    adresse VARCHAR(150)
);

CREATE TABLE grade (
    grade_libelle VARCHAR(50) PRIMARY KEY,
    grade_service VARCHAR(80) NOT NULL
);

CREATE TABLE enqueteur (
    id_personne INT PRIMARY KEY,
    matricule VARCHAR(30) NOT NULL UNIQUE,
    grade_libelle VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_personne) REFERENCES personne(id_personne),
    FOREIGN KEY (grade_libelle) REFERENCES grade(grade_libelle)
);

CREATE TABLE suspect (
    id_personne INT PRIMARY KEY,
    statut_suspect VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_personne) REFERENCES personne(id_personne)
);

CREATE TABLE victime (
    id_personne INT PRIMARY KEY,
    prejudice VARCHAR(200),
    FOREIGN KEY (id_personne) REFERENCES personne(id_personne)
);

CREATE TABLE affaire (
    id_affaire INT PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    statut VARCHAR(30) NOT NULL
        CHECK (statut IN ('ouverte', 'en cours', 'fermée', 'classée sans suite')),
    date_ouverture DATE NOT NULL
);

CREATE TABLE affecter (
    id_personne INT,
    id_affaire INT,
    role_affectation VARCHAR(50) NOT NULL
        CHECK (role_affectation IN ('responsable', 'assistant', 'expert')),
    PRIMARY KEY (id_personne, id_affaire),
    FOREIGN KEY (id_personne) REFERENCES enqueteur(id_personne),
    FOREIGN KEY (id_affaire) REFERENCES affaire(id_affaire)
);

CREATE TABLE temoin (
    id_temoin INT PRIMARY KEY,
    nom_temoin VARCHAR(60) NOT NULL,
    contact_temoin VARCHAR(100)
);

CREATE TABLE temoigner_dans (
    id_temoin INT,
    id_affaire INT,
    PRIMARY KEY (id_temoin, id_affaire),
    FOREIGN KEY (id_temoin) REFERENCES temoin(id_temoin),
    FOREIGN KEY (id_affaire) REFERENCES affaire(id_affaire)
);

CREATE TABLE lieu_crime (
    adresse_lieu VARCHAR(150) PRIMARY KEY,
    ville_lieu VARCHAR(60) NOT NULL,
    type_lieu VARCHAR(80) NOT NULL
);

CREATE TABLE associer_lieu_affaire (
    adresse_lieu VARCHAR(150),
    id_affaire INT,
    PRIMARY KEY (adresse_lieu, id_affaire),
    FOREIGN KEY (adresse_lieu) REFERENCES lieu_crime(adresse_lieu),
    FOREIGN KEY (id_affaire) REFERENCES affaire(id_affaire)
);

CREATE TABLE preuve (
    id_preuve INT PRIMARY KEY,
    type_preuve VARCHAR(60) NOT NULL,
    description TEXT,
    adresse_lieu VARCHAR(150) NOT NULL,
    id_affaire INT NOT NULL,
    FOREIGN KEY (adresse_lieu) REFERENCES lieu_crime(adresse_lieu),
    FOREIGN KEY (id_affaire) REFERENCES affaire(id_affaire)
);

CREATE TABLE lier_preuve_suspect (
    id_preuve INT,
    id_suspect INT,
    PRIMARY KEY (id_preuve, id_suspect),
    FOREIGN KEY (id_preuve) REFERENCES preuve(id_preuve),
    FOREIGN KEY (id_suspect) REFERENCES suspect(id_personne)
);

CREATE TABLE interrogatoire (
    id_interrogatoire INT PRIMARY KEY,
    date_interrogatoire DATE NOT NULL,
    compte_rendu TEXT,
    id_enqueteur INT NOT NULL,
    id_suspect INT NOT NULL,
    id_affaire INT NOT NULL,
    FOREIGN KEY (id_enqueteur) REFERENCES enqueteur(id_personne),
    FOREIGN KEY (id_suspect) REFERENCES suspect(id_personne),
    FOREIGN KEY (id_affaire) REFERENCES affaire(id_affaire)
);

CREATE TABLE arrestation (
    id_arrestation INT PRIMARY KEY,
    date_arrestation DATE NOT NULL,
    id_interrogatoire INT NOT NULL UNIQUE,
    FOREIGN KEY (id_interrogatoire)
        REFERENCES interrogatoire(id_interrogatoire)
);

CREATE TABLE accusation (
    id_accusation INT PRIMARY KEY,
    chef_accusation VARCHAR(100) NOT NULL,
    statut_accusation VARCHAR(50) NOT NULL,
    id_suspect INT NOT NULL,
    id_affaire INT NOT NULL,
    FOREIGN KEY (id_suspect) REFERENCES suspect(id_personne),
    FOREIGN KEY (id_affaire) REFERENCES affaire(id_affaire)
);
