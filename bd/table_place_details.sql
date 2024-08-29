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