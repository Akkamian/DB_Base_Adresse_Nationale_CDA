-- Table public.voie
DROP TABLE IF EXISTS public.voie CASCADE;
CREATE TABLE public.voie (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    id_fantoir VARCHAR(50) UNIQUE,
    nom_afnor VARCHAR(50),
    source_nom_voie VARCHAR(50)
);

-- Table public.parcelle
DROP TABLE IF EXISTS public.parcelle CASCADE;
CREATE TABLE public.parcelle (
    id SERIAL PRIMARY KEY,
    id_cadastre VARCHAR(20) NOT NULL UNIQUE
);

-- Table public.commune
DROP TABLE IF EXISTS public.commune CASCADE;
CREATE TABLE public.commune (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    code_postal VARCHAR(5),
    code_insee VARCHAR(5) UNIQUE
);

-- Table public.ancienne_commune
DROP TABLE IF EXISTS public.ancienne_commune CASCADE;
CREATE TABLE public.ancienne_commune (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    code_insee VARCHAR(5) UNIQUE,
    commune_id INTEGER REFERENCES public.commune(id) ON DELETE SET NULL
);

-- Table public.adresse
DROP TABLE IF EXISTS public.adresse CASCADE;
CREATE TABLE public.adresse (
    id SERIAL PRIMARY KEY,
    id_bal VARCHAR(50),
    numero_voie INTEGER NOT NULL,
    rep VARCHAR(20),
    x FLOAT4,
    y FLOAT4,
    longitude FLOAT4,
    latitude FLOAT4,
    type_position VARCHAR(20),
    source_position VARCHAR(20),
    nom_lieu_dit VARCHAR(100),
    libelle_acheminement VARCHAR(50),
    certif_commune INTEGER,
    alias VARCHAR(50),
    voie_id INTEGER REFERENCES public.voie(id) ON DELETE SET NULL,
    commune_id INTEGER NOT NULL REFERENCES public.commune(id)
);

-- Table public.adresse_parcelle
DROP TABLE IF EXISTS public.adresse_parcelle CASCADE;
CREATE TABLE public.adresse_parcelle (
    id SERIAL PRIMARY KEY,
    adresse_id INTEGER NOT NULL REFERENCES public.adresse(id) ON DELETE CASCADE,
    parcelle_id INTEGER NOT NULL REFERENCES public.parcelle(id) ON DELETE CASCADE
);
