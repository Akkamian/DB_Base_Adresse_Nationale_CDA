# Projet Brief BAN

## Contexte

Ce projet a été réalisé dans le cadre d'une formation Concepteur Développeur d'Applications au sein du centre de formation SIMPLON Campus Distanciel.

---

## Sources et documents

- Le dictionnaire de données et les tables sont consultables dans [ce fichier Google Sheets](https://docs.google.com/spreadsheets/d/1Tqo-32w0W9f_jTa92afTF0-ife39FpSNeHKBfMw2-9U/edit?usp=sharing).
- Le MCD, MLD, MPD (versions image) sont disponibles dans le fichier `MERISE\MCD_MLD_MPD_brief_db_BAN.svg`.
- Les scripts SQL se trouvent dans :
  - Le dossier `initDB` pour les scripts de création des tables.
  - Le dossier `script_import` pour les scripts d'insertion des jeux d'essai et la transformation des données brutes vers le modèle normalisé.
  - Le dossier `requetes` pour les requêtes de consultation, modification, procédures stockées et triggers.

---

## Prérequis techniques

- Installer Docker et Docker Compose sur votre machine.  
  - [Installation Docker](https://docs.docker.com/get-docker/)  
  - [Installation Docker Compose](https://docs.docker.com/compose/install/)

---

## Installation et démarrage

1. Cloner le dépôt :  


se placer dans le dossier du projet

2. Lancer les services Docker :  

```bash
docker compose up -d
```
Le lancement démarre le conteneur PostgreSQL avec la base initialisée automatiquement grâce au script de création des tables.

3. Connexion à la base  
Connectez-vous à la base via la ligne de commande ou un outil comme [DBeaver](https://dbeaver.io/download/).

---
## Import des données

- Importer le fichier `adresses-38.csv` présent dans le repo ou télécharger un fichier d'adresse depuis la [Base Adresse Nationale (BAN)](https://adresse.data.gouv.fr/data/ban/adresses/latest/csv) dans la table `raw_data`.

---


## Transformation des données

- Lancer le script de transformation des données brutes vers le modèle relationnel normalisé.  
Le script se trouve dans :  

script_import\import_complet_vf.sql

---

## Requêtes et procédures

- Une base de requêtes prêtes à l’emploi est disponible dans le dossier `\requetes`.

---


## Indexation et optimisation des performances

- Pour améliorer les temps de requête, exécutez le script de création des index disponible dans le fichier `creation_indexes.sql`.

---

## Exemple de requête pour mesurer le gain de performance

```sql
SELECT
  c.nom AS nom_commune,
  AVG(nombre_adresses) AS moyenne_nb_adresses_par_voie
FROM (
  SELECT
    a.commune_id,
    a.voie_id,
    COUNT(*) AS nombre_adresses
  FROM public.adresse a
  GROUP BY a.commune_id, a.voie_id
) AS adresses_par_voie
JOIN public.commune c ON adresses_par_voie.commune_id = c.id
GROUP BY c.nom
ORDER BY c.nom;
```

- Temps d'exécution sans indexation : 169,593 ms (~0,17 s)  
- Temps d'exécution avec indexation : 160,193 ms (~0,16 s)


## Auteur

Clément MARTIN

---