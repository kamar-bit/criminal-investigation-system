-- =========================================================
-- Projet BD - Système de gestion d'enquêtes criminelles
-- Script complet : suppression + création + insertion + contraintes
-- SGBD : PostgreSQL
-- =========================================================

-- =========================================================
-- Suppression des tables
-- =========================================================

DROP TABLE IF EXISTS accusation CASCADE;
DROP TABLE IF EXISTS arrestation CASCADE;
DROP TABLE IF EXISTS interrogatoire CASCADE;
DROP TABLE IF EXISTS lier_preuve_suspect CASCADE;
DROP TABLE IF EXISTS preuve CASCADE;
DROP TABLE IF EXISTS associer_lieu_affaire CASCADE;
DROP TABLE IF EXISTS lieu_crime CASCADE;
DROP TABLE IF EXISTS temoigner_dans CASCADE;
DROP TABLE IF EXISTS temoin CASCADE;
DROP TABLE IF EXISTS affecter CASCADE;
DROP TABLE IF EXISTS affaire CASCADE;
DROP TABLE IF EXISTS victime CASCADE;
DROP TABLE IF EXISTS suspect CASCADE;
DROP TABLE IF EXISTS enqueteur CASCADE;
DROP TABLE IF EXISTS grade CASCADE;
DROP TABLE IF EXISTS personne CASCADE;

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

-- =========================================================
-- Insertion des données
-- =========================================================

INSERT INTO personne VALUES
(1,'Martin','Alice','12 rue Nord'),
(2,'Durand','Karim','8 avenue Sud'),
(3,'Petit','Laura','5 rue Est'),
(4,'Moreau','Yanis','3 rue Ouest'),
(5,'Bernard','Sara','17 rue Paix'),
(6,'Roux','Nabil','20 avenue Gare'),
(7,'Garnier','Emma','4 rue Lac'),
(8,'Lopez','Hugo','9 rue Parc'),
(9,'Leroy','Mina','2 rue Port'),
(10,'Faye','Omar','6 rue Centre'),
(11,'Benoit','Lina','1 rue Jardin'),
(12,'Caron','Sofiane','7 rue Gare'),
(13,'Noel','Ines','11 rue Rivoli'),
(14,'Masson','Adam','15 rue Seine'),
(15,'Perrin','Nora','18 rue Stade');

INSERT INTO grade VALUES
('Inspecteur','Police judiciaire'),
('Lieutenant','Criminalité organisée'),
('Capitaine','Homicides'),
('Commissaire','Direction'),
('Analyste','Police scientifique');

INSERT INTO enqueteur VALUES
(1,'MAT001','Inspecteur'),
(2,'MAT002','Lieutenant'),
(3,'MAT003','Capitaine'),
(11,'MAT004','Commissaire'),
(12,'MAT005','Analyste');

INSERT INTO suspect VALUES
(4,'principal'),
(5,'secondaire'),
(6,'en fuite'),
(7,'interrogé'),
(8,'mis en examen');

INSERT INTO victime VALUES
(5,'blessure légère'),
(9,'vol de biens'),
(10,'préjudice moral'),
(13,'dommage matériel'),
(14,'menace reçue');

INSERT INTO affaire VALUES
(100,'Cambriolage centre-ville','en cours','2026-01-10'),
(101,'Agression nocturne','ouverte','2026-01-18'),
(102,'Fraude documentaire','en cours','2026-02-02'),
(103,'Disparition inquiétante','ouverte','2026-02-15'),
(104,'Trafic local','en cours','2026-03-01'),
(105,'Vandalisme au lycée','ouverte','2026-03-10');

INSERT INTO affecter VALUES
(1,100,'responsable'),
(2,101,'responsable'),
(3,102,'responsable'),
(11,103,'responsable'),
(12,104,'responsable'),
(1,105,'responsable');

INSERT INTO temoin VALUES
(1,'Haddad','haddad@mail.fr'),
(2,'Mercier','mercier@mail.fr'),
(3,'Blanc','blanc@mail.fr'),
(4,'Simon','simon@mail.fr'),
(5,'Robert','robert@mail.fr');

INSERT INTO temoigner_dans VALUES
(1,100),
(2,101),
(3,102),
(4,103),
(5,104);

INSERT INTO lieu_crime VALUES
('10 rue Bleue','Paris','appartement'),
('5 avenue Rouge','Versailles','parking'),
('2 rue Verte','Massy','bureau'),
('14 quai Nord','Paris','entrepôt'),
('8 rue Blanche','Orsay','commerce');

INSERT INTO associer_lieu_affaire VALUES
('10 rue Bleue',100),
('5 avenue Rouge',101),
('2 rue Verte',102),
('14 quai Nord',103),
('8 rue Blanche',104);

INSERT INTO preuve VALUES
(1000,'empreinte','empreinte retrouvée sur une fenêtre','10 rue Bleue',100),
(1001,'vidéo','enregistrement de caméra','5 avenue Rouge',101),
(1002,'document','faux document administratif','2 rue Verte',102),
(1003,'objet','sac abandonné','14 quai Nord',103),
(1004,'ADN','trace biologique','8 rue Blanche',104);

INSERT INTO lier_preuve_suspect VALUES
(1000,4),
(1001,5),
(1002,6),
(1003,7),
(1004,8);

INSERT INTO interrogatoire VALUES
(2000,'2026-01-12','Le suspect nie les faits.',1,4,100),
(2001,'2026-01-20','Le suspect reconnaît sa présence.',2,5,101),
(2002,'2026-02-05','Le suspect refuse de répondre.',3,6,102),
(2003,'2026-02-18','Le suspect donne un alibi.',11,7,103),
(2004,'2026-03-03','Le suspect fournit des informations.',12,8,104);

INSERT INTO arrestation VALUES
(3000,'2026-01-13',2000),
(3001,'2026-01-21',2001),
(3002,'2026-02-06',2002),
(3003,'2026-02-19',2003),
(3004,'2026-03-04',2004);

INSERT INTO accusation VALUES
(4000,'vol aggravé','en instruction',4,100),
(4001,'violence volontaire','en instruction',5,101),
(4002,'faux et usage de faux','ouverte',6,102),
(4003,'séquestration','ouverte',7,103),
(4004,'trafic organisé','en instruction',8,104);

-- =========================================================
-- Contraintes dynamiques et triggers
-- =========================================================

CREATE OR REPLACE FUNCTION verifier_enqueteur_non_suspect()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM affecter a
        WHERE a.id_affaire = NEW.id_affaire
          AND a.id_personne = NEW.id_suspect
    ) THEN
        RAISE EXCEPTION
        'Un enquêteur ne peut pas être suspect dans une affaire où il est affecté.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_enqueteur_non_suspect
BEFORE INSERT OR UPDATE ON accusation
FOR EACH ROW
EXECUTE FUNCTION verifier_enqueteur_non_suspect();


CREATE OR REPLACE FUNCTION verifier_arrestation_apres_interrogatoire()
RETURNS TRIGGER AS $$
DECLARE
    date_int DATE;
BEGIN

    SELECT date_interrogatoire
    INTO date_int
    FROM interrogatoire
    WHERE id_interrogatoire = NEW.id_interrogatoire;

    IF NEW.date_arrestation < date_int THEN
        RAISE EXCEPTION
        'Une arrestation ne peut pas être antérieure à l''interrogatoire.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_arrestation_apres_interrogatoire
BEFORE INSERT OR UPDATE ON arrestation
FOR EACH ROW
EXECUTE FUNCTION verifier_arrestation_apres_interrogatoire();


CREATE OR REPLACE FUNCTION verifier_suppression_preuve()
RETURNS TRIGGER AS $$
DECLARE
    statut_affaire VARCHAR(30);
BEGIN

    SELECT statut
    INTO statut_affaire
    FROM affaire
    WHERE id_affaire = OLD.id_affaire;

    IF statut_affaire <> 'fermée' THEN
        RAISE EXCEPTION
        'Impossible de supprimer une preuve si l''affaire n''est pas fermée.';
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_suppression_preuve
BEFORE DELETE ON preuve
FOR EACH ROW
EXECUTE FUNCTION verifier_suppression_preuve();


CREATE OR REPLACE FUNCTION verifier_progression_statut_affaire()
RETURNS TRIGGER AS $$
BEGIN

    IF OLD.statut = 'ouverte'
       AND NEW.statut NOT IN ('ouverte', 'en cours') THEN
        RAISE EXCEPTION
        'Progression de statut invalide.';
    END IF;

    IF OLD.statut = 'en cours'
       AND NEW.statut NOT IN ('en cours', 'fermée', 'classée sans suite') THEN
        RAISE EXCEPTION
        'Progression de statut invalide.';
    END IF;

    IF OLD.statut IN ('fermée', 'classée sans suite')
       AND NEW.statut <> OLD.statut THEN
        RAISE EXCEPTION
        'Une affaire clôturée ou classée ne peut plus changer de statut.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_progression_statut_affaire
BEFORE UPDATE OF statut ON affaire
FOR EACH ROW
EXECUTE FUNCTION verifier_progression_statut_affaire();

-- =========================================================
-- Fin du script complet
-- =========================================================
