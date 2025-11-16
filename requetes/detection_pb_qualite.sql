-- 1) Identifier doublons exacts (mêmes numéro + nom de voie + code postal + commune).
-- doublons relatifs j'imagine (meme infos de colonne mais id différent)
SELECT DISTINCT a.*, v.nom AS nom_voie, c.code_postal, c.nom AS nom_commune
FROM public.adresse a
JOIN public.voie v ON a.voie_id = v.id
JOIN public.commune c ON a.commune_id = c.id
WHERE EXISTS (
    SELECT 1
    FROM public.adresse t2
    JOIN public.voie v2 ON t2.voie_id = v2.id
    JOIN public.commune c2 ON t2.commune_id = c2.id
    WHERE t2.id <> a.id
      AND t2.numero_voie = a.numero_voie
      AND v2.nom = v.nom
      AND c2.code_postal = c.code_postal
      AND c2.nom = c.nom
      AND t2.rep = a.rep
      AND t2.x = a.x
      AND t2.y = a.y
      AND t2.type_position = a.type_position
      AND t2.id_bal = a.id_bal
);
-- renvoie 2400  occurences d'adresse avec les champs spécifiés identiques
-- <> : différent de

-- 2)Identifier les adresses incohérentes sans coordonnées GPS
SELECT a.id, a.id_bal, a.numero_voie, a.rep, v.nom AS nom_voie, c.nom AS nom_commune, c.code_postal as code_postal
FROM public.adresse a
JOIN public.voie v ON a.voie_id = v.id
JOIN public.commune c ON a.commune_id = c.id
WHERE a.latitude IS NULL 
AND a.longitude IS NULL 
AND a.x IS NULL 
AND a.y IS NULL;

-- Lister les codes postaux avec plus de 10 000 adresses pour détecter les anomalies volumétriques.
SELECT c.code_postal AS nom_commune, COUNT(a.id) AS nombre_adresses
FROM public.adresse a
JOIN public.commune c ON a.commune_id = c.id
GROUP BY c.code_postal
HAVING COUNT(a.id) > 10000;