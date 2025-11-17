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
    -- Vérifier si la commune existe
    IF NOT EXISTS (
        SELECT 1 FROM public.commune WHERE id = p_commune_id
    ) THEN
        RAISE EXCEPTION 'La commune d''identifiant % n''existe pas. Veuillez la créer avant avec la procédure stockée creer_modifier_commune.',
        p_commune_id;
    END IF;

    -- Vérifier si la voie existe
    IF NOT EXISTS (
        SELECT 1 FROM public.voie WHERE id = p_voie_id
    ) THEN
        RAISE EXCEPTION 'La voie d''identifiant % n''existe pas. Veuillez la créer avant avec la procédure stockée creer_modifier_voie.',
        p_voie_id;
    END IF;

    -- Vérifier si l'adresse existe déjà selon id_bal, numero_voie, et rep
    IF EXISTS (
        SELECT 1 FROM public.adresse
        WHERE id_bal = p_id_bal
          AND numero_voie = p_numero_voie
          AND (rep = p_rep OR (rep IS NULL AND p_rep IS NULL))
    ) THEN
        -- Mise à jour
        UPDATE public.adresse
        SET numero_voie = p_numero_voie,
            rep = p_rep,
            voie_id = p_voie_id,
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
          AND (rep = p_rep OR (rep IS NULL AND p_rep IS NULL));
    ELSE
        -- Insertion
        INSERT INTO public.adresse(
            id_bal,
            numero_voie,
            rep,
            voie_id,
            commune_id,
            x,
            y,
            longitude,
            latitude,
            type_position,
            source_position,
            nom_lieu_dit,
            libelle_acheminement,
            certif_commune,
            alias
        )
        VALUES (
            p_id_bal,
            p_numero_voie,
            p_rep,
            p_voie_id,
            p_commune_id,
            p_x,
            p_y,
            p_longitude,
            p_latitude,
            p_type_position,
            p_source_position,
            p_nom_lieu_dit,
            p_libelle_acheminement,
            p_certif_commune,
            p_alias
        );
    END IF;
END;
$$;


--  $$ $$ délimite le corps de la fonction
CREATE OR REPLACE PROCEDURE creer_modifier_commune(
    p_nom VARCHAR(50),
    p_code_postal VARCHAR(5),
    p_code_insee VARCHAR(5)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Vérifier si la commune existe
    IF NOT EXISTS (
        SELECT 1
        FROM public.commune
        WHERE nom = p_nom
          AND code_postal = p_code_postal
          AND code_insee = p_code_insee
    ) THEN
        -- Insertion d'une nouvelle commune
        INSERT INTO public.commune(nom, code_postal, code_insee)
        VALUES (p_nom, p_code_postal, p_code_insee);
    ELSE
        -- Mise à jour de la commune existante
        UPDATE public.commune
        SET nom = p_nom,
            code_postal = p_code_postal,
            code_insee = p_code_insee
        WHERE nom = p_nom
          AND code_postal = p_code_postal
          AND code_insee = p_code_insee;
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE creer_modifier_voie(
    p_nom VARCHAR(50),
    p_id_fantoir VARCHAR(50),
    p_nom_AFNOR VARCHAR(50),
    p_source_nom_voie VARCHAR(50)
) LANGUAGE plpgsql 
AS $$ BEGIN
 -- Vérifier si la voie existe
IF NOT EXISTS (
    SELECT 1
    FROM public.voie
    WHERE nom = p_nom
      AND id_fantoir = p_id_fantoir
      AND nom_AFNOR = p_nom_AFNOR
      AND source_nom_voie = p_source_nom_voie
) THEN
    -- Insertion d'une nouvelle voie
    INSERT INTO public.voie(nom, id_fantoir, nom_AFNOR, source_nom_voie)
    VALUES (p_nom, p_id_fantoir, p_nom_AFNOR, p_source_nom_voie);
ELSE
    -- Mise à jour de la voie existante
    UPDATE public.voie
    SET nom = p_nom,
        id_fantoir = p_id_fantoir,
        nom_AFNOR = p_nom_AFNOR,
        source_nom_voie = p_source_nom_voie
    WHERE nom = p_nom
      AND id_fantoir = p_id_fantoir
      AND nom_AFNOR = p_nom_AFNOR
      AND source_nom_voie = p_source_nom_voie;
END IF;
END;
$$; 


-- 2) Créer un trigger qui vérifie, avant insertion, que les coordonnées GPS sont valides (lat entre -90 et 90, lon entre -180 et 180) et que le code postal est bien au format 5 chiffres
CREATE OR REPLACE FUNCTION verif_coordonnees_et_code_postal()
RETURNS trigger AS $$
BEGIN
    -- Vérification latitude
    IF NEW.latitude IS NOT NULL AND (NEW.latitude < -90 OR NEW.latitude > 90) THEN
        RAISE EXCEPTION 'Latitude % invalide. Doit être entre -90 et 90.', NEW.latitude;
    END IF;

    -- Vérification longitude
    IF NEW.longitude IS NOT NULL AND (NEW.longitude < -180 OR NEW.longitude > 180) THEN
        RAISE EXCEPTION 'Longitude % invalide. Doit être entre -180 et 180.', NEW.longitude;
    END IF;

    -- Vérification format code postal (5 chiffres)
    IF NEW.code_postal IS NULL OR NEW.code_postal !~ '^\d{5}$' THEN
        RAISE EXCEPTION 'Code postal % invalide. Doit contenir exactement 5 chiffres.', NEW.code_postal;
    END IF;

    RETURN NEW; -- valide l'insertion
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER verif_coordonnees_code_postal_before_insert
BEFORE INSERT ON public.adresse
FOR EACH ROW
EXECUTE FUNCTION verif_coordonnees_et_code_postal();


-- 3) Ajouter automatiquement une date de création / mise à jour à chaque modification via trigger
CREATE OR REPLACE FUNCTION add_timestamp() 
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
    NEW.date_creation := now();
    NEW.date_modification := now();
  
    ELSIF TG_OP = 'UPDATE' THEN
    NEW.date_modification := now();
  END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER add_timestamp_before_insert_adresse
BEFORE INSERT OR UPDATE ON public.adresse
FOR EACH ROW
EXECUTE FUNCTION add_timestamp();

CREATE TRIGGER add_timestamp_before_insert_commune
BEFORE INSERT OR UPDATE ON public.commune
FOR EACH ROW
EXECUTE FUNCTION add_timestamp();

CREATE TRIGGER add_timestamp_before_insert_voie
BEFORE INSERT OR UPDATE ON public.voie
FOR EACH ROW
EXECUTE FUNCTION add_timestamp();

CREATE TRIGGER add_timestamp_before_insert_parcelle
BEFORE INSERT OR UPDATE ON public.parcelle
FOR EACH ROW
EXECUTE FUNCTION add_timestamp();

CREATE TRIGGER add_timestamp_before_insert_adresse_parcelle
BEFORE INSERT OR UPDATE ON public.adresse_parcelle
FOR EACH ROW
EXECUTE FUNCTION add_timestamp();

CREATE TRIGGER add_timestamp_before_insert_ancienne_commune
BEFORE INSERT OR UPDATE ON public.ancienne_commune
FOR EACH ROW
EXECUTE FUNCTION add_timestamp();
