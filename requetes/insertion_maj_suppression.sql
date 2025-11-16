-- 1) Ajouter une nouvelle adresse complète dans les tables finales.
INSERT INTO public.adresse (id_bal, numero_voie, rep, x, y, longitude, latitude, type_position, source_position, nom_lieu_dit, libelle_acheminement, certif_commune, alias, voie_id, commune_id) 
VALUES ('83002_0120_00048', 48, null, 961090.24, 6302885.02, 6.243447, 43.776717, 'entrée', 'commune', null, 'AIGUINES', 1, null, 1, 1);

-- 2) Mettre à jour le nom d’une voie pour une adresse spécifique.
UPDATE public.voie AS v
SET nom = 'test'
FROM public.adresse a
WHERE a.voie_id = v.id AND a.id_bal = 'ID_DE_L_ADRESSE'
-- attention dans ma structure de données cela modifier le nom de la voie pour l'ensemble des adresses car je ne stocke pas de champ nom de voie dans la table adresse


-- 3) Supprimer toutes les adresses avec un champ manquant critique (ex : numéro de voie vide).
DELETE FROM public.adresse
WHERE numero_voie IS NULL

