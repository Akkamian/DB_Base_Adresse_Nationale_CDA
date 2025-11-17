/** Option de script à partir d'une table raw data existante **/
TRUNCATE TABLE raw_data;


-- import les données brutes à partir d'un fichier csv en ouvrant une console avec psql
\copy raw_data FROM 'C:/Users/monuser/chemin_du_fichier.csv' WITH (FORMAT csv, DELIMITER ';', HEADER, ENCODING 'WIN1252');

--  ou importer via dbeaver : cela semble poser moins de pb d'encodage


--Script de transformation des données brutes vers le modèle normalisé
-- Insérer les voies avec id_fantoir, sans doublons
INSERT INTO voie (nom, id_fantoir, nom_afnor, source_nom_voie)
SELECT DISTINCT ON (id_fantoir) nom_voie, id_fantoir, nom_afnor, source_nom_voie
FROM raw_data
WHERE id_fantoir IS NOT NULL
ORDER BY id_fantoir, nom_voie
ON CONFLICT (id_fantoir) DO NOTHING;

-- Insérer les voies sans id_fantoir, sans doublons nom + id_fantoir NULL
INSERT INTO voie (nom, id_fantoir, nom_afnor, source_nom_voie)
SELECT DISTINCT nom_voie, NULL, nom_afnor, source_nom_voie
FROM raw_data r
WHERE id_fantoir IS NULL
AND NOT EXISTS (
    SELECT 1 FROM voie v WHERE v.nom = r.nom_voie AND v.id_fantoir IS NULL
);

-- Insérer les communes (uniquement si absentes)
INSERT INTO commune (nom, code_postal, code_insee)
SELECT DISTINCT nom_commune, code_postal, code_insee
FROM raw_data
WHERE code_insee IS NOT NULL
ON CONFLICT (code_insee) DO NOTHING;

-- Insérer les anciennes communes (uniquement si absentes)
INSERT INTO ancienne_commune (nom, code_insee, commune_id)
SELECT DISTINCT r.nom_ancienne_commune, r.code_insee_ancienne_commune, c.id
FROM raw_data r
JOIN commune c ON c.code_insee = r.code_insee
WHERE r.code_insee_ancienne_commune IS NOT NULL AND r.code_insee_ancienne_commune <> ''
  AND r.nom_ancienne_commune IS NOT NULL AND r.nom_ancienne_commune <> ''
ON CONFLICT (code_insee) DO NOTHING;

-- Insérer les parcelles (en découpant les listes)
INSERT INTO parcelle (id_cadastre)
SELECT DISTINCT trim(unnest(string_to_array(r.cad_parcelles, '|')))
FROM raw_data r
WHERE r.cad_parcelles IS NOT NULL;

-- Insérer les adresses
INSERT INTO adresse (
    id_bal, numero_voie, rep, x, y, longitude, latitude, type_position,
    source_position, nom_lieu_dit, libelle_acheminement, certif_commune, alias, voie_id, commune_id
)
SELECT
    r.id, r.numero, r.rep, r.x, r.y, r.lon, r.lat, r.type_position,
    r.source_position, r.nom_ld, r.libelle_acheminement, r.certification_commune, r.alias,
    v.id, c.id
FROM raw_data r
LEFT JOIN voie v ON v.id_fantoir = r.id_fantoir
JOIN commune c ON c.code_insee = r.code_insee
WHERE r.numero IS NOT NULL;

-- Insérer les liens adresse-parcelle
INSERT INTO adresse_parcelle (adresse_id, parcelle_id)
SELECT a.id, p.id
FROM raw_data r
JOIN adresse a ON a.id_bal = r.id
JOIN LATERAL unnest(string_to_array(r.cad_parcelles, '|')) AS parcelle_id ON true
JOIN parcelle p ON p.id_cadastre = trim(parcelle_id)
WHERE r.cad_parcelles IS NOT NULL;
