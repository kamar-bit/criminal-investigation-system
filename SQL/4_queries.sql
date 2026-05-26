-- =====================================================
-- REQUETE 1 : Affaires et enquêteurs responsables
-- =====================================================

SELECT 
    a.id_affaire,
    a.titre,
    a.statut,
    e.nom AS enqueteur
FROM AFFAIRE a
JOIN AFFECTATION af 
    ON a.id_affaire = af.id_affaire
JOIN ENQUETEUR e 
    ON af.id_enqueteur = e.id_enqueteur;


-- =====================================================
-- REQUETE 2 : Suspects impliqués dans les affaires
-- =====================================================

SELECT 
    a.titre,
    s.nom AS suspect,
    s.niveau_dangerosite
FROM AFFAIRE a
JOIN IMPLICATION i
    ON a.id_affaire = i.id_affaire
JOIN SUSPECT s
    ON i.id_suspect = s.id_suspect;


-- =====================================================
-- REQUETE 3 : Preuves et lieux de collecte
-- =====================================================

SELECT 
    p.id_preuve,
    p.type_preuve,
    l.adresse,
    l.ville
FROM PREUVE p
JOIN LIEU_CRIME l
    ON p.id_lieu = l.id_lieu;


-- =====================================================
-- REQUETE 4 : Nombre de preuves par affaire
-- =====================================================

SELECT 
    a.titre,
    COUNT(p.id_preuve) AS nombre_preuves
FROM AFFAIRE a
LEFT JOIN PREUVE p
    ON a.id_affaire = p.id_affaire
GROUP BY a.id_affaire, a.titre;


-- =====================================================
-- REQUETE 5 : Historique des interrogatoires
-- =====================================================

SELECT 
    e.nom AS enqueteur,
    s.nom AS suspect,
    i.date_interrogatoire
FROM INTERROGATOIRE i
JOIN ENQUETEUR e
    ON i.id_enqueteur = e.id_enqueteur
JOIN SUSPECT s
    ON i.id_suspect = s.id_suspect
ORDER BY i.date_interrogatoire DESC;


-- =====================================================
-- REQUETE 6 : Affaires sans arrestation
-- =====================================================

SELECT a.titre
FROM AFFAIRE a
WHERE a.id_affaire NOT IN (
    SELECT DISTINCT id_affaire
    FROM ARRESTATION
);
