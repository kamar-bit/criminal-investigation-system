# criminal-investigation-system
================================================================================
  README — Système de gestion d'enquêtes criminelles
  Projet de Modélisation de Base de Données — IATIC 3, Mai 2026
  Réalisé par : BENBACHA Kamar, BETTACHE Najlae
  Encadré par : Preda Nicoleta-Diana
================================================================================

------------------------------------------------------------------------
1. DESCRIPTION DU PROJET
------------------------------------------------------------------------

Ce projet implémente un système de gestion d'enquêtes criminelles sous
forme de base de données relationnelle. Il modélise les affaires, les
personnes impliquées (enquêteurs, suspects, victimes), les témoins,
les interrogatoires, les arrestations, les preuves, les lieux de crime
et les accusations.

Le fichier schema_final_enquetes.sql contient l'implémentation complète
du schéma relationnel FINAL issu de la normalisation (Sections 7, 8
et 9 du rapport), incluant :
  - La création de toutes les tables (DDL) en 3FN / BCNF
  - Les 4 triggers de contraintes dynamiques (Section 8.2)
  - Le jeu de données minimal de 5 tuples par table (Section 9)

------------------------------------------------------------------------
2. SGBD UTILISÉ
------------------------------------------------------------------------

  SGBD cible : PostgreSQL >= 14

  Le script utilise des fonctionnalités propres à PostgreSQL :
    - Syntaxe CREATE OR REPLACE FUNCTION ... LANGUAGE plpgsql
    - RAISE EXCEPTION pour les triggers

  Il n'est PAS compatible directement avec MySQL/MariaDB ou SQLite
  sans adaptation des triggers (syntaxe PL/pgSQL spécifique).

------------------------------------------------------------------------
3. DÉPENDANCES NÉCESSAIRES
------------------------------------------------------------------------

  - PostgreSQL >= 14 installé sur la machine
    Téléchargement : https://www.postgresql.org/download/

  - Client psql (inclus dans l'installation PostgreSQL)
    OU un client graphique : pgAdmin, DBeaver, TablePlus...

  - Aucune bibliothèque ou dépendance externe n'est requise.

------------------------------------------------------------------------
4. STRUCTURE DES FICHIERS
------------------------------------------------------------------------

  schema_final_enquetes.sql   — Script SQL principal contenant :
  │
  ├── SECTION 1 : CREATE TABLE
  │     personne, grade, enqueteur, suspect, victime,
  │     affaire, affecter, temoin, temoigner_dans,
  │     lieu_crime, associer_lieu_affaire, preuve,
  │     lier_preuve_suspect, interrogatoire, arrestation, accusation
  │
  ├── SECTION 2 : TRIGGERS (contraintes dynamiques)
  │     trg_enqueteur_non_suspect
  │     trg_arrestation_apres_interrogatoire
  │     trg_suppression_preuve
  │     trg_progression_statut_affaire
  │
  └── SECTION 3 : INSERT INTO (jeu de données minimal)
        5 tuples minimum par table

  README.txt                  — Ce fichier

------------------------------------------------------------------------
5. ÉTAPES D'INSTALLATION
------------------------------------------------------------------------

  Étape 1 — Installer PostgreSQL
  --------------------------------
  Suivre les instructions officielles pour votre OS :
  https://www.postgresql.org/download/

  Étape 2 — Lancer le service PostgreSQL
  ----------------------------------------
  Linux / macOS :
    sudo systemctl start postgresql
    (ou : sudo service postgresql start)

  Windows :
    Le service démarre automatiquement après installation.
    Sinon : Panneau de configuration > Services > postgresql-x64-XX > Démarrer

  Étape 3 — Créer une base de données dédiée
  --------------------------------------------
  Ouvrir un terminal et se connecter à PostgreSQL :

    psql -U postgres

  Puis créer la base et quitter :

    CREATE DATABASE enquetes_criminelles;
    \q

  Étape 4 — Exécuter le script SQL
  ----------------------------------
  Dans le terminal, lancer :

    psql -U postgres -d enquetes_criminelles -f schema_final_enquetes.sql

  Si le fichier se trouve dans un autre répertoire :

    psql -U postgres -d enquetes_criminelles -f /chemin/complet/vers/schema_final_enquetes.sql

  Le script crée automatiquement toutes les tables, les triggers et
  insère le jeu de données minimal.

------------------------------------------------------------------------
6. VÉRIFICATION APRÈS EXÉCUTION
------------------------------------------------------------------------

  Se connecter à la base :

    psql -U postgres -d enquetes_criminelles

  Puis tester quelques requêtes de vérification :

    -- Lister toutes les affaires
    SELECT * FROM affaire;

    -- Enquêteurs avec leur grade et service
    SELECT e.matricule, e.grade_libelle, g.grade_service
    FROM enqueteur e
    JOIN grade g ON e.grade_libelle = g.grade_libelle;

    -- Suspects impliqués dans chaque affaire
    SELECT a.titre, p.nom, p.prenom, s.statut_suspect
    FROM interrogatoire i
    JOIN affaire  a ON i.id_affaire  = a.id_affaire
    JOIN suspect  s ON i.id_suspect  = s.id_personne
    JOIN personne p ON s.id_personne = p.id_personne;

    -- Preuves par affaire avec le lieu associé
    SELECT a.titre, pr.type_preuve, pr.description, pr.adresse_lieu
    FROM preuve pr
    JOIN affaire a ON pr.id_affaire = a.id_affaire;

    -- Vérifier les accusations en cours
    SELECT acc.chef_accusation, acc.statut_accusation,
           p.nom, p.prenom, a.titre
    FROM accusation acc
    JOIN suspect  s ON acc.id_suspect = s.id_personne
    JOIN personne p ON s.id_personne  = p.id_personne
    JOIN affaire  a ON acc.id_affaire = a.id_affaire;

------------------------------------------------------------------------
7. DESCRIPTION DU SCHÉMA FINAL (différences vs schéma initial)
------------------------------------------------------------------------

  Le schéma final est le résultat de la normalisation en 3FN / BCNF.
  Voici les évolutions principales par rapport au schéma initial :

  ENQUETEUR + GRADE
    Décomposition pour supprimer la dépendance transitive :
    id_personne -> grade_libelle -> grade_service

  PREUVE + LIEU_CRIME
    Décomposition pour supprimer la dépendance transitive :
    id_preuve -> adresse_lieu -> ville_lieu, type_lieu

  PERSONNE -> SUSPECT + VICTIME (ISA recouvrant)
    Les attributs statut_suspect et prejudice sortent de PERSONNE.

  AFFAIRE -> TEMOIN + TEMOIGNER_DANS
    Évite l'anomalie si une affaire a plusieurs témoins.

  INTERROGATOIRE absorbe MENER, CONCERNER, CONTENIR
    id_enqueteur, id_suspect et id_affaire sont FK directes.

  ARRESTATION extraite de INTERROGATOIRE
    Devient une entité autonome liée à un seul interrogatoire.

  ACCUSATION absorbe DONNER_LIEU_A et VISER
    id_suspect et id_affaire sont FK directes.

  ASSOCIER_LIEU_AFFAIRE (nouveau)
    Un même lieu peut être associé à plusieurs affaires.

  LIER_PREUVE_SUSPECT (nouveau)
    Lien N:N explicite entre preuves et suspects.

------------------------------------------------------------------------
8. TRIGGERS — RÉSUMÉ
------------------------------------------------------------------------

  trg_enqueteur_non_suspect
    Empêche qu'un enquêteur affecté à une affaire soit visé par une
    accusation dans cette même affaire.

  trg_arrestation_apres_interrogatoire
    Vérifie que la date d'arrestation est >= à la date de
    l'interrogatoire associé.

  trg_suppression_preuve
    Empêche la suppression d'une preuve si l'affaire n'est pas
    dans l'état "fermée" ou "classée sans suite".

  trg_progression_statut_affaire
    Contrôle la progression stricte du statut d'une affaire :
    ouverte -> en cours -> fermée | classée sans suite
    Toute transition invalide lève une exception.

------------------------------------------------------------------------
9. CONTACT
------------------------------------------------------------------------

  BENBACHA Kamar   — IATIC 3, ISTY / Université Paris-Saclay (UVSQ)
  BETTACHE Najlae  — IATIC 3, ISTY / Université Paris-Saclay (UVSQ)

================================================================================
