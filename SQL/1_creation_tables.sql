-- =========================================================
-- Projet BD - Systeme de gestion d'enquetes criminelles
-- SGBD : PostgreSQL
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
    statut VARCHAR(30) NOT NULL CHECK (statut IN ('ouverte', 'en cours', 'fermée', 'classée sans suite')),
    date_ouverture DATE NOT NULL
);

CREATE TABLE affecter (
    id_personne INT,
    id_affaire INT,
    role_affectation VARCHAR(50) NOT NULL CHECK (role_affectation IN ('responsable', 'assistant', 'expert')),
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
    FOREIGN KEY (id_interrogatoire) REFERENCES interrogatoire(id_interrogatoire)
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
-- Triggers pour les contraintes dynamiques
-- =========================================================

-- 1) Un enqueteur ne peut pas etre suspect dans une affaire ou il est affecte.
CREATE OR REPLACE FUNCTION verifier_enqueteur_non_suspect()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM affecter a
        WHERE a.id_affaire = NEW.id_affaire
          AND a.id_personne = NEW.id_suspect
    ) THEN
        RAISE EXCEPTION 'Un enqueteur ne peut pas etre suspect dans une affaire ou il est affecte.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_enqueteur_non_suspect
BEFORE INSERT OR UPDATE ON accusation
FOR EACH ROW
EXECUTE FUNCTION verifier_enqueteur_non_suspect();

-- 2) Une arrestation ne peut pas etre anterieure a l'interrogatoire associe.
CREATE OR REPLACE FUNCTION verifier_arrestation_apres_interrogatoire()
RETURNS TRIGGER AS $$
DECLARE
    date_int DATE;
BEGIN
    SELECT date_interrogatoire INTO date_int
    FROM interrogatoire
    WHERE id_interrogatoire = NEW.id_interrogatoire;

    IF NEW.date_arrestation < date_int THEN
        RAISE EXCEPTION 'Une arrestation ne peut pas etre anterieure a l interrogatoire.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_arrestation_apres_interrogatoire
BEFORE INSERT OR UPDATE ON arrestation
FOR EACH ROW
EXECUTE FUNCTION verifier_arrestation_apres_interrogatoire();

-- 3) Une preuve ne peut pas etre supprimee si l'affaire n'est pas cloturee.
CREATE OR REPLACE FUNCTION verifier_suppression_preuve()
RETURNS TRIGGER AS $$
DECLARE
    statut_affaire VARCHAR(30);
BEGIN
    SELECT statut INTO statut_affaire
    FROM affaire
    WHERE id_affaire = OLD.id_affaire;

    IF statut_affaire <> 'fermée' THEN
        RAISE EXCEPTION 'Impossible de supprimer une preuve si l affaire n est pas cloturee.';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_suppression_preuve
BEFORE DELETE ON preuve
FOR EACH ROW
EXECUTE FUNCTION verifier_suppression_preuve();

-- 4) Le statut d'une affaire suit une progression stricte.
CREATE OR REPLACE FUNCTION verifier_progression_statut_affaire()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.statut = 'ouverte'
       AND NEW.statut NOT IN ('ouverte', 'en cours') THEN
        RAISE EXCEPTION 'Progression de statut invalide.';
    END IF;

    IF OLD.statut = 'en cours'
       AND NEW.statut NOT IN ('en cours', 'fermée', 'classée sans suite') THEN
        RAISE EXCEPTION 'Progression de statut invalide.';
    END IF;

    IF OLD.statut IN ('fermée', 'classée sans suite')
       AND NEW.statut <> OLD.statut THEN
        RAISE EXCEPTION 'Une affaire cloturee ou classee ne peut plus changer de statut.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_progression_statut_affaire
BEFORE UPDATE OF statut ON affaire
FOR EACH ROW
EXECUTE FUNCTION verifier_progression_statut_affaire();

-- =========================================================
-- Jeu de donnees minimal : au moins 5 tuples par relation
-- =========================================================
