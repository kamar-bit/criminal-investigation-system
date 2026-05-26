-- =====================================================
-- REQUETE 1 : Affaires et enquêteurs responsables
-- =====================================================

SELECT
    a.id_affaire,
    a.titre,
    a.statut,
    p.nom AS nom_enqueteur,
    p.prenom AS prenom_enqueteur,
    af.role_affectation
FROM affaire a
JOIN affecter af
    ON a.id_affaire = af.id_affaire
JOIN enqueteur e
    ON af.id_personne = e.id_personne
JOIN personne p
    ON e.id_personne = p.id_personne
WHERE af.role_affectation = 'responsable';


-- =====================================================
-- REQUETE 2 : Suspects impliqués dans les affaires
-- =====================================================

SELECT
    a.id_affaire,
    a.titre,
    p.nom AS nom_suspect,
    p.prenom AS prenom_suspect,
    s.statut_suspect,
    ac.chef_accusation,
    ac.statut_accusation
FROM affaire a
JOIN accusation ac
    ON a.id_affaire = ac.id_affaire
JOIN suspect s
    ON ac.id_suspect = s.id_personne
JOIN personne p
    ON s.id_personne = p.id_personne;


-- =====================================================
-- REQUETE 3 : Preuves et lieux de collecte
-- =====================================================

SELECT
    pr.id_preuve,
    pr.type_preuve,
    pr.description,
    l.adresse_lieu,
    l.ville_lieu,
    l.type_lieu
FROM preuve pr
JOIN lieu_crime l
    ON pr.adresse_lieu = l.adresse_lieu;


-- =====================================================
-- REQUETE 4 : Nombre de preuves par affaire
-- =====================================================

SELECT
    a.id_affaire,
    a.titre,
    COUNT(pr.id_preuve) AS nombre_preuves
FROM affaire a
LEFT JOIN preuve pr
    ON a.id_affaire = pr.id_affaire
GROUP BY a.id_affaire, a.titre
ORDER BY a.id_affaire;


-- =====================================================
-- REQUETE 5 : Historique des interrogatoires
-- =====================================================

SELECT
    i.id_interrogatoire,
    a.titre AS affaire,
    pe.nom AS nom_enqueteur,
    pe.prenom AS prenom_enqueteur,
    ps.nom AS nom_suspect,
    ps.prenom AS prenom_suspect,
    i.date_interrogatoire,
    i.compte_rendu
FROM interrogatoire i
JOIN affaire a
    ON i.id_affaire = a.id_affaire
JOIN enqueteur e
    ON i.id_enqueteur = e.id_personne
JOIN personne pe
    ON e.id_personne = pe.id_personne
JOIN suspect s
    ON i.id_suspect = s.id_personne
JOIN personne ps
    ON s.id_personne = ps.id_personne
ORDER BY i.date_interrogatoire DESC;


-- =====================================================
-- REQUETE 6 : Affaires sans arrestation
-- =====================================================

SELECT
    a.id_affaire,
    a.titre
FROM affaire a
WHERE NOT EXISTS (
    SELECT 1
    FROM interrogatoire i
    JOIN arrestation ar
        ON ar.id_interrogatoire = i.id_interrogatoire
    WHERE i.id_affaire = a.id_affaire
);
