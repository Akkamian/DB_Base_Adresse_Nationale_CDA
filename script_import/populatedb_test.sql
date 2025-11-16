INSERT INTO public.commune (nom, code_postal, code_insee) 
VALUES ('Nom de la commune', 'Code postal', 'Code INSEE');

INSERT INTO commune (nom, code_postal, code_insee) 
VALUES ('Les Adrets', '38190', '38002'),
('Vinay', '38470', '38559'),
('Val-de-Virieu', '38730', '38560'),
('Villemoirieu', '38460', '38554'),
('Trept', '38460', '38554'),
('Villemoirieu', '38460', '38515'),
('La Côte-Saint-André', '38260', '38130'),
('Vourey', '38210', '38566'),
('Vienne', '38200', '38544'),
('Saint-Sauveur', '38160', '38454'),
('Murianette', '38420', '38271'),
('Eybens', '38320', '38158'),
('Beaufort', '38270', '38032'),
('Allemond', '38114', '38005'),
('Saint-Geoire-en-Valdaine', '38620', '38386')
;

INSERT INTO ancienne_commune (nom, code_insee) 
VALUES ('Panissage', '38293'),
('Les Avenières', '38022')
;

INSERT INTO voie (nom, id_fantoir,nom_AFNOR, source_nom_voie) 
VALUES ('Rue de la Boucle', '38002_0015', 'RUE DE LA BOUCLE', 'commune' ),
('Allée des Terrasses', '38002_0035', 'ALLEE DES TERRASSES', 'commune'),
('Montée de l''Erinée', '38559_0150', 'MONTEE DE L ERINEE', 'commune'),
('Allée des Terrasses', '38560_0835', 'ALLEE DES TERRASSES', 'commune'),
('Route des Giclas', '38002_0035', 'ROUTE DES GICLAS', 'commune'),
('Impasse des Jardins', '38554_0056', 'ALLEE DES TERRASSES', 'commune'),
('Allée des Terrasses', '38002_0035', 'IMPASSE DES JARDINS', 'commune'),
('Route de Miéry', '38515_0155', 'ROUTE DE MIERY', 'commune'),
('Chemin des Meunières', '38130_0410', 'CHEMIN DES MEUNIERES', 'commune'),
('Route des Rivoires', '38566_0300', 'ROUTE DES RIVOIRES', 'commune'),
('Montée des Tupinieres', '38002_0035', 'MONTEE DES TUPINIERES', 'commune'),
('Montee des 3 Pierres', '38386_0710', 'MONTEE DES 3 PIERRES', 'commune'),
('Impasse du Clos du Bâtier', '38454_0028', 'IMPASSE DU CLOS DU BATIER', 'commune'),
('Impasse des Bons Voisins', '38271_0028', 'IMPASSE DES BONS VOISINS', 'commune'),
('Rue de Belledonne', '38158_0365', 'RUE DE BELLEDONNE', 'commune'),
('Chemin du Moulin', '38032_0192', 'CHEMIN DE SAINT PIERRE', 'commune'),
('Montee des 3 Pierres', '38005_0072', 'CHEMIN DU MOULIN', 'commune')
;

INSERT INTO parcelle (id_cadastre) 
VALUES ('38293'),
;

INSERT INTO parcelle (id_cadastre) 
VALUES ('38002000AB0025'),
('38559000AI0211'),
('385602930B0543'),
('38554000AN0245'),
('385150000E0610'),
('384540000B2496'),
('384620000A0511'),
('38565000AP0417'),
('380220000C1315'),
('38517000AS0068'),
('383720000B0821')
;



INSERT INTO adresse (
id_bal, numero_voie, rep, x, y, longitude, latitude, type_position,
source_position, nom_lieu_dit, libelle_acheminement, certif_commune,
alias, voie_id, commune_id
)
VALUES (
'38002_0015_00171', 171, NULL, 933315.8, 6467590.0, 5.975825, 45.26809, 'logement',
'commune', 'Les Blettières', 'LES ADRETS', 1, 'Les Adrets',
(SELECT id FROM voie WHERE id_fantoir = '38002_0015'),
(SELECT id FROM commune WHERE code_insee = '38002')
);


INSERT INTO adresse_parcelle (adresse_id, parcelle_id)
VALUES (
(SELECT id FROM adresse WHERE id_bal = '38002_0015_00171'),
(SELECT id FROM parcelle WHERE id_cadastre = '38002000AB0025')
);


INSERT INTO adresse (
id_bal, numero_voie, rep, x, y, longitude, latitude, type_position,
source_position, nom_lieu_dit, libelle_acheminement, certif_commune, alias, voie_id, commune_id
)
VALUES (
'38002_0035_00008', 8, NULL, 934932.44, 6466398.5, 5.995848, 45.256817, 'entrée',
'commune', 'Prapoutel', 'LES ADRETS', 1, 'Les Adrets',
(SELECT id FROM voie WHERE id_fantoir = '38002_0035'),
(SELECT id FROM commune WHERE code_insee = '38002')
);

INSERT INTO adresse_parcelle (adresse_id, parcelle_id)
VALUES (
(SELECT id FROM adresse WHERE id_bal = '38002_0035_00008'),
(SELECT id FROM parcelle WHERE id_cadastre = '38002000AB0025')
);


INSERT INTO adresse (
id_bal, numero_voie, rep, x, y, longitude, latitude, type_position,
source_position, nom_lieu_dit, libelle_acheminement, certif_commune, alias, voie_id, commune_id
)
VALUES
('38002_0035_00020', 20, NULL, 934928.44, 6466386.0, 5.995791, 45.256706, 'bâtiment', 'commune', 'Prapoutel', 'LES ADRETS', 1, 'Les Adrets', (SELECT id FROM voie WHERE id_fantoir = '38002_0035' LIMIT 1), (SELECT id FROM commune WHERE code_insee = '38002' LIMIT 1)),
('38002_0035_00030', 30, NULL, 934907.9, 6466390.5, 5.995531, 45.256752, 'bâtiment', 'commune', 'Prapoutel', 'LES ADRETS', 1, 'Les Adrets', (SELECT id FROM voie WHERE id_fantoir = '38002_0035' LIMIT 1), (SELECT id FROM commune WHERE code_insee = '38002' LIMIT 1)),
('38559_0150_00269', 269, NULL, 888898.7, 6460055.0, 5.406771, 45.21391, 'entrée', 'commune', 'VINAY', 'VINAY', 1, 'Vinay', (SELECT id FROM voie WHERE id_fantoir = '38559_0150' LIMIT 1), (SELECT id FROM commune WHERE code_insee = '38559' LIMIT 1)),
('38560_0835_00065', 65, NULL, 892609.1, 6490458.5, 5.46611, 45.486515, 'entrée', 'commune', 'VIRIEU SUR BOURBRE', 'VIRIEU SUR BOURBRE', 1, 'Val-de-Virieu', (SELECT id FROM voie WHERE id_fantoir = '38560_0835' LIMIT 1), (SELECT id FROM commune WHERE code_insee = '38560' LIMIT 1)),
('38554_0056_00005', 5, NULL, 872904.6, 6516002.0, 5.223165, 45.72169, 'logement', 'commune', 'VILLEMOIRIEU', 'VILLEMOIRIEU', 1, 'Villemoirieu', (SELECT id FROM voie WHERE id_fantoir = '38554_0056' LIMIT 1), (SELECT id FROM commune WHERE code_insee = '38554' LIMIT 1)),
('38515_0155_00972', 972, NULL, 882523.94, 6512164.0, 5.345312, 45.684643, 'entrée', 'commune', 'TREPT', 'TREPT', 1, 'Trept', (SELECT id FROM voie WHERE id_fantoir = '38515_0155' LIMIT 1), (SELECT id FROM commune WHERE code_insee = '38515' LIMIT 1)),
('38130_0410_00107', 107, NULL, 876447.3, 6478804.5, 5.255037, 45.38597, 'entrée', 'commune', 'LA COTE-SAINT-ANDRE', 'LA COTE-SAINT-ANDRE', 1, 'La Côte-Saint-André', (SELECT id FROM voie WHERE id_fantoir = '38130_0410' LIMIT 1), (SELECT id FROM commune WHERE code_insee = '38130' LIMIT 1)),
('38566_0300_00220', 220, NULL, 897885.5, 6472508.0, 5.526271, 45.323456, 'segment', 'commune', 'VOUREY', 'VOUREY', 0, 'Vourey', (SELECT id FROM voie WHERE id_fantoir = '38566_0300' LIMIT 1), (SELECT id FROM commune WHERE code_insee = '38566' LIMIT 1)),
('38454_0028_00007', 7, NULL, 884231.9, 645263.0, 5.344777, 45.15404, 'entrée', 'commune', 'SAINT-SAUVEUR', 'SAINT-SAUVEUR', 1, 'Saint-Sauveur', (SELECT id FROM voie WHERE id_fantoir = '38454_0028' LIMIT 1), (SELECT id FROM commune WHERE code_insee = '38454' LIMIT 1)),
('38271_0028_00015', 15, NULL, 920799.25, 6458296.5, 5.812102, 45.188595, 'entrée', 'commune', 'MURIANETTE', 'MURIANETTE', 1, 'Murianette', (SELECT id FROM voie WHERE id_fantoir = '38271_0028' LIMIT 1), (SELECT id FROM commune WHERE code_insee = '38271' LIMIT 1)),
('38158_0365_00004', 4, NULL, 915976.25, 6455083.5, 5.749302, 45.161205, 'entrée', 'commune', 'EYBENS', 'EYBENS', 1, 'Eybens', (SELECT id FROM voie WHERE id_fantoir = '38158_0365' LIMIT 1), (SELECT id FROM commune WHERE code_insee = '38158' LIMIT 1)),
('38032_0192_00275', 275, NULL, 865838.5, 6471073.0, 5.116872, 45.319023, 'logement', 'commune', 'BEAUFORT', 'BEAUFORT', 1, 'Beaufort', (SELECT id FROM voie WHERE id_fantoir = '38032_0192' LIMIT 1), (SELECT id FROM commune WHERE code_insee = '38032' LIMIT 1)),
('38005_0072_00060', 60, NULL, 938891.4, 6452502.0, 6.039465, 45.130417, 'entrée', 'commune', 'ALLEMOND', 'ALLEMOND', 1, 'Allemond', (SELECT id FROM voie WHERE id_fantoir = '38005_0072' LIMIT 1), (SELECT id FROM commune WHERE code_insee = '38005' LIMIT 1));



INSERT INTO adresse_parcelle (adresse_id, parcelle_id)
SELECT a.id, p.id
FROM (
VALUES
('38002_0035_00020', '38002000AB0025'),
('38002_0035_00030', '38002000AB0025'),
('38559_0150_00269', '38559000AI0211'),
('38560_0835_00065', '385602930B0543'),
('38554_0056_00005', '38554000AN0245'),
('38515_0155_00972', '385150000E0610'),
('38130_0410_00107', '38566_0300_00220'),
('38566_0300_00220', '38544_2073_00067'),
('38454_0028_00007', '384540000B2496'),
('38271_0028_00015', '38158_0365_00004'),
('38158_0365_00004', '38032_0192_00275'),
('38032_0192_00275', '38005_0072_00060'),
('38005_0072_00060', '38386_0710_00073')
) AS v(id_bal, id_cadastre)
JOIN adresse a ON a.id_bal = v.id_bal
JOIN parcelle p ON p.id_cadastre = v.id_cadastre;