-- Lister toutes les adresses d’une commune donnée, triées par voie

SELECT a.id, a.id_bal, a.numero_voie, a.rep, v.nom AS nom_voie, c.nom AS nom_commune, c.code_postal as code_postal
FROM public.adresse a
JOIN public.voie v ON a.voie_id = v.id
JOIN public.commune c ON a.commune_id = c.id
WHERE c.code_insee = 'CODE_INSEE_DE_LA_COMMUNE'
ORDER BY v.nom, a.numero_voie, a.rep;



-- Compter le nombre d’adresses par commune (bonus: et par voie).

SELECT c.nom AS nom_commune, c.code_insee, COUNT(a.id) AS nombre_adresses
FROM public.adresse a
JOIN public.commune c ON a.commune_id = c.id
GROUP BY c.id, c.nom, c.code_insee
ORDER BY nombre_adresses DESC;

-- par commune et par voie
SELECT c.nom AS nom_commune, c.code_insee, v.nom AS nom_voie, COUNT(a.id) AS nombre_adresses
FROM public.adresse a
JOIN public.commune c ON a.commune_id = c.id
LEFT JOIN public.voie v ON a.voie_id = v.id
GROUP BY c.id, c.nom, c.code_insee, v.id, v.nom
ORDER BY c.nom, v.nom;



-- Lister toutes les communes distinctes présentes dans le fichier.
SELECT DISTINCT c.nom, c.code_insee
FROM public.adresse a
JOIN public.commune c ON a.commune_id = c.id
ORDER BY c.nom;


-- Rechercher toutes les adresses contenant un mot-clé particulier dans le nom de voie (ex: Boulevard, Rue, etc...).
SELECT a.id, a.id_bal, a.numero_voie, a.rep, v.nom AS nom_voie, c.nom AS nom_commune, c.code_postal as code_postal
FROM public.adresse a
JOIN public.voie v ON a.voie_id = v.id
JOIN public.commune c ON a.commune_id = c.id
WHERE v.nom ILIKE '%MOT_CLE%';

-- ILIKE permet de faire une recherche insensible à la casse
--  et LIKE sensible à la casse


-- Identifier les adresses où le code postal est vide alors que la commune est renseignée
SELECT a.id, a.id_bal, a.numero_voie, a.rep, v.nom AS nom_voie, c.nom AS nom_commune, c.code_postal as code_postal
FROM public.adresse a
JOIN public.voie v ON a.voie_id = v.id
JOIN public.commune c ON a.commune_id = c.id
WHERE c.code_postal IS NULL AND c.nom IS NOT NULL;


