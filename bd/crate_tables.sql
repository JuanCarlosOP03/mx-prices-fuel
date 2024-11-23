
DROP TABLE IF EXISTS "mx_prices_fuel"."public"."places" CASCADE;
CREATE TABLE "mx_prices_fuel"."public"."places" (
    "place_id" INT PRIMARY KEY NOT NULL,
    "cre_id" VARCHAR(25) NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL, 
    "latitude" DOUBLE PRECISION NOT NULL,  
    "place_name" VARCHAR(150)                
);

COMMENT ON TABLE "mx_prices_fuel"."public"."places" IS 'Tabla que almacena información sobre estaciones de combustible';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places"."place_id" IS 'Identificador único de la estación de servicio';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places"."cre_id" IS 'Identificador del permiso';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places"."longitude" IS 'Longitud de la estación de servicio en grados';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places"."latitude" IS 'Latitud de la estación de servicio en grados';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places"."place_name" IS 'Nombre de la estación de servicio';

CREATE UNIQUE INDEX idx_cre_id ON "mx_prices_fuel"."public"."places" ("cre_id");
CREATE INDEX idx_location ON "mx_prices_fuel"."public"."places" ("longitude", "latitude");

DROP TABLE IF EXISTS "mx_prices_fuel"."public"."prices" CASCADE;
CREATE TABLE "mx_prices_fuel"."public"."prices" (
    "place_id" INT NOT NULL REFERENCES "mx_prices_fuel"."public"."places" ("place_id"),  
    "fuel_type" VARCHAR(30) NOT NULL,
    "type_product" VARCHAR(30) NOT NULL,
    "price" DOUBLE PRECISION NOT NULL
);

COMMENT ON COLUMN "mx_prices_fuel"."public"."prices"."place_id" IS 'Identificador de la estación de servicio';
COMMENT ON COLUMN "mx_prices_fuel"."public"."prices"."fuel_type" IS 'Tipo de combustible: gasolina o diésel';
COMMENT ON COLUMN "mx_prices_fuel"."public"."prices"."type_product" IS 'Tipo de producto: premium, magna o diésel';
COMMENT ON COLUMN "mx_prices_fuel"."public"."prices"."price" IS 'Precio del combustible en la estación de servicio';

CREATE INDEX idx_place_id ON "mx_prices_fuel"."public"."prices" ("place_id");

DROP TABLE IF EXISTS "mx_prices_fuel"."public"."places_details" CASCADE;
CREATE TABLE "mx_prices_fuel"."public"."places_details" (
    "turn_code" VARCHAR(10) NOT NULL,
    "cre_id" VARCHAR(25) NOT NULL REFERENCES "mx_prices_fuel"."public"."places" ("cre_id"),
    "place_name" VARCHAR(150),
    "place_code" VARCHAR(10) NOT NULL,
    "date_entry" DATE,
    "plenary_date" DATE,
    "address" VARCHAR(200),
    "colony" VARCHAR(100),
    "cp" INT,
    "city" VARCHAR(80) NOT NULL,
    "state" VARCHAR(50) NOT NULL
);

COMMENT ON TABLE "mx_prices_fuel"."public"."places_details" IS 'Tabla que almacena información detallada sobre estaciones de servicio';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places_details"."turn_code" IS 'Código del turno';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places_details"."cre_id" IS 'Identificador del permiso';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places_details"."place_name" IS 'Nombre de la estación de servicio';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places_details"."place_code" IS 'Código del lugar';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places_details"."date_entry" IS 'Fecha de entrada';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places_details"."plenary_date" IS 'Fecha plenaria';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places_details"."address" IS 'Dirección de la estación de servicio';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places_details"."colony" IS 'Colonia de la estación de servicio';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places_details"."cp" IS 'Código postal de la estación de servicio';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places_details"."city" IS 'Ciudad de la estación de servicio';
COMMENT ON COLUMN "mx_prices_fuel"."public"."places_details"."state" IS 'Estado de la estación de servicio';

CREATE INDEX idx_turn_code ON "mx_prices_fuel"."public"."places_details" ("turn_code");
CREATE INDEX idx_cre_id_details ON "mx_prices_fuel"."public"."places_details" ("cre_id");
CREATE INDEX idx_place_code ON "mx_prices_fuel"."public"."places_details" ("place_code");