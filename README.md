Projet de Modélisation de Base de Données
Système de gestion d’enquêtes criminelles

1. Contenu du dossier

Ce dossier contient les fichiers suivants :

- Rapport_PDF.pdf
  Rapport final du projet.

- sql/01_creation_tables.sql
  Script SQL de création des tables.
  Il contient les CREATE TABLE, les clés primaires,
  les clés étrangères et les contraintes CHECK.

- sql/02_insert_data.sql
  Script SQL contenant les données d’exemple.
  Il contient au moins cinq tuples par relation.

- sql/03_constraints.sql
  Script SQL contenant les contraintes dynamiques
  implémentées avec des fonctions PL/pgSQL et des triggers.

- sql/04_queries.sql
  Script SQL contenant les principales requêtes
  d’interrogation de la base de données.

- sql/05_drop_tables.sql
  Script SQL permettant de supprimer toutes les tables
  du projet avec gestion des dépendances.

- README.txt
  Fichier explicatif du dossier et de la procédure d’exécution.


2. SGBD utilisé

Le SGBD utilisé pour ce projet est PostgreSQL.


3. Dépendances nécessaires

Pour exécuter le projet, il faut disposer de :

- PostgreSQL installé sur la machine ;
- un outil d’exécution SQL, par exemple psql ou pgAdmin.


4. Procédure d’installation et d’exécution

Étape 1 : créer une base de données PostgreSQL vide.

Exemple avec psql :

CREATE DATABASE enquetes_criminelles;


Étape 2 : se connecter à la base créée.

Exemple :

\c enquetes_criminelles


Étape 3 : exécuter les scripts SQL dans le bon ordre.

Exemple :

\i sql/01_creation_tables.sql
\i sql/02_insert_data.sql
\i sql/03_constraints.sql


Étape 4 : exécuter les requêtes de test.

Exemple :

\i sql/04_queries.sql


5. Ordre d’exécution

Les scripts doivent être exécutés dans cet ordre :

1. sql/01_creation_tables.sql
2. sql/02_insert_data.sql
3. sql/03_constraints.sql
4. sql/04_queries.sql

Le fichier suivant peut être utilisé pour réinitialiser le projet :

5. sql/05_drop_tables.sql


6. Description rapide du projet

Le projet modélise un système de gestion d’enquêtes criminelles.

Il permet de représenter :
- les affaires ;
- les personnes ;
- les enquêteurs ;
- les suspects ;
- les victimes ;
- les témoins ;
- les lieux de crime ;
- les preuves ;
- les interrogatoires ;
- les arrestations ;
- les accusations.

Le modèle relationnel final respecte les contraintes définies
dans l’analyse des besoins grâce :
- aux clés primaires ;
- aux clés étrangères ;
- aux contraintes CHECK ;
- aux triggers SQL pour les contraintes dynamiques.


7. Remarque sur les triggers

Certaines contraintes métier ne peuvent pas être exprimées
uniquement par des clés primaires, des clés étrangères
ou des contraintes CHECK.

Elles sont donc prises en charge par des triggers SQL,
notamment pour :

- empêcher qu’un enquêteur soit suspect dans une affaire
  où il est affecté ;

- vérifier qu’une arrestation est postérieure ou égale
  à l’interrogatoire associé ;

- empêcher la suppression d’une preuve si l’affaire
  n’est pas clôturée ;

- contrôler la progression du statut d’une affaire.
