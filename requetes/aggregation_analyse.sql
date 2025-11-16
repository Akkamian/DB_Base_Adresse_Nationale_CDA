-- 1) - Nombre moyen d’adresses par commune et par voie.
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


-- 2) Top 10 des communes avec le plus d’adresses.
SELECT
  c.nom AS nom_commune,
  COUNT(a.id) AS nombre_adresses
FROM public.adresse a
JOIN public.commune c ON a.commune_id = c.id
GROUP BY c.id, c.nom
ORDER BY nombre_adresses DESC
LIMIT 10;


--  3) Vérifier la complétude des champs essentiels (numéro, voie, code postal, commune).
SELECT
  a.id,
  a.id_bal,
  a.numero_voie,
  a.rep,
  v.nom AS nom_voie,
  c.nom AS nom_commune,
  c.code_postal
FROM public.adresse a
JOIN public.voie v ON a.voie_id = v.id
JOIN public.commune c ON a.commune_id = c.id
WHERE a.numero_voie IS NULL OR v.nom IS NULL OR c.code_postal IS NULL OR c.nom IS NULL;