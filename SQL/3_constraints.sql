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
