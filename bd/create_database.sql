
CREATE DATABASE mx_prices_fuel
WITH 
    ENCODING = 'UTF8',     
    LC_COLLATE = 'es_ES.UTF-8',
    LC_CTYPE = 'es_ES.UTF-8';  

CREATE USER etl_user WITH ENCRYPTED PASSWORD '1Pass=0309';
GRANT ALL PRIVILEGES ON DATABASE mx_prices_fuel TO etl_user;
COMMENT ON DATABASE mx_prices_fuel IS 'Base de datos para la gestión de precios de combustible en México';
