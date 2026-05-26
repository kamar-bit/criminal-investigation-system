README.txt
Projet de Modélisation de Base de Données
Système de gestion d’enquêtes criminelles

1. Contenu du dossier
Ce dossier contient les fichiers suivants :

- Rapport_PDF.pdf
  Rapport final du projet.

- schema_creation_tables.sql
  Script SQL de création du schéma relationnel final.
  Il contient les CREATE TABLE, les clés primaires, les clés étrangères,
  les contraintes NOT NULL, UNIQUE, CHECK ainsi que les triggers SQL.

- donnees_exemple.sql
  Script SQL contenant les données d’exemple.
  Il contient au moins cinq tuples par relation.

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

Étape 3 : exécuter le script de création des tables.

Exemple :

\i schema_creation_tables.sql

Étape 4 : insérer les données d’exemple.

Exemple :

\i donnees_exemple.sql

5. Ordre d’exécution
Les scripts doivent être exécutés dans cet ordre :

1. schema_creation_tables.sql
2. donnees_exemple.sql

6. Description rapide du projet
Le projet modélise un système de gestion d’enquêtes criminelles.
Il permet de représenter les affaires, les personnes, les enquêteurs,
les suspects, les victimes, les preuves, les lieux de crime,
les interrogatoires, les arrestations et les accusations.

Le modèle relationnel final respecte les contraintes définies dans l’analyse
des besoins grâce aux clés primaires, aux clés étrangères, aux contraintes
CHECK et à des triggers SQL pour les contraintes dynamiques.

7. Remarque sur les triggers
Certaines contraintes métier ne peuvent pas être exprimées uniquement par
des clés primaires, des clés étrangères ou des contraintes CHECK.
Elles sont donc prises en charge par des triggers SQL complémentaires,
notamment pour :
- empêcher qu’un enquêteur soit suspect dans une affaire où il est affecté ;
- vérifier qu’une arrestation est postérieure ou égale à l’interrogatoire associé ;
- empêcher la suppression d’une preuve si l’affaire n’est pas clôturée ;
- contrôler la progression du statut d’une affaire.
