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