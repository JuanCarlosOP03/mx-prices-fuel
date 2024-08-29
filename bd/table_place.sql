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