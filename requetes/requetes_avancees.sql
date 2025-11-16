--  script de création d'une procédure stockée de création ou modification d'une adresse selon qu'elle existe déjà

CREATE OR REPLACE PROCEDURE creer_modifier_adresse(
    p_id_bal VARCHAR(50),
    p_numero_voie INTEGER,
    p_rep VARCHAR(20),
    p_x FLOAT4,
    p_y FLOAT4,
    p_longitude FLOAT4,
    p_latitude FLOAT4,
    p_type_position VARCHAR(20),
    p_source_position VARCHAR(20),
    p_nom_lieu_dit VARCHAR(100),
    p_libelle_acheminement VARCHAR(50),
    p_certif_commune INTEGER,
    p_alias VARCHAR(50),
    p_voie_id INTEGER,
    p_commune_id INTEGER,
    p_id_adresse INTEGER DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Vérifier si l'adresse existe déjà selon l'id_bal (exemple clé unique)
    IF EXISTS (SELECT 1 FROM public.adresse 
    WHERE id_bal = p_id_bal
    AND numero_voie = p_numero_voie 
    AND (rep = p_rep OR (rep IS NULL AND p_rep IS NULL))
    ) 
    THEN
        -- Mise à jour de l'adresse existante
        UPDATE public.adresse
        SET numero_voie = p_numero_voie,
            rep = p_rep,
            voie_id = p_voe_id,
            commune_id = p_commune_id,
            x = p_x,
            y = p_y,
            longitude = p_longitude,
            latitude = p_latitude,
            type_position = p_type_position,
            source_position = p_source_position,
            nom_lieu_dit = p_nom_lieu_dit,
            libelle_acheminement = p_libelle_acheminement,
            certif_commune = p_certif_commune,
            alias = p_alias
        WHERE id_bal = p_id_bal
      AND numero_voie = p_numero_voie
      AND (rep = p_rep OR (rep IS NULL AND p_rep IS NULL))

    ELSE
        -- Insertion d'une nouvelle adresse
        INSERT INTO public.adresse(
            id_bal, numero_voie, rep, voie_id, commune_id, x, y,
            longitude, latitude, type_position, source_position,
            nom_lieu_dit, libelle_acheminement, certif_commune, alias
        )
        VALUES (
            p_id_bal, p_numero_voie, p_rep, p_voe_id, p_commune_id, p_x, p_y,
            p_longitude, p_latitude, p_type_position, p_source_position,
            p_nom_lieu_dit, p_libelle_acheminement, p_certif_commune, p_alias
        );
    END IF;
END;
$$;


--  $$ $$ délimite le corps de la fonction