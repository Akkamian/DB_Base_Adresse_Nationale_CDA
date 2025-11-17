-- indexes à créer : 
-- on cible spécifiquement les champs qui servent fréquemment dans les filtres WHERE, les JOIN, les GROUP BY ou les ORDER BY :
--  liste des indexes à créer :

-- public.adresse
CREATE INDEX idx_adresse_voie_id ON public.adresse(voie_id);
CREATE INDEX idx_adresse_commune_id ON public.adresse(commune_id);

-- public.voie	
CREATE INDEX idx_voie_nom ON public.voie(nom);

-- public.parcelle	
CREATE INDEX idx_parcelle_id_cadastre ON public.parcelle(id_cadastre);

-- public.commune	
CREATE INDEX idx_commune_code_postal ON public.commune(code_postal);
CREATE INDEX idx_commune_code_insee ON public.commune(code_insee);
CREATE INDEX idx_commune_nom ON public.commune(nom);

-- public.ancienne_commune
CREATE INDEX idx_ancienne_commune_commune_id ON public.ancienne_commune(commune_id);



-- script de test 
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


-- temps sans indexation :
Temps : 169,593 ms
0.2s

-- temps avec indexation :
CREATE INDEX idx_adresse_voie_id ON public.adresse(voie_id);
CREATE INDEX idx_adresse_commune_id ON public.adresse(commune_id);
Temps : 179,065 ms

CREATE INDEX idx_commune_nom ON public.commune(nom);
Temps : 160,193 ms
