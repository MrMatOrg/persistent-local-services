#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username postgres --dbname "$POSTGRES_DB" <<__EOSQL__
    CREATE ROLE keycloak ENCRYPTED PASSWORD 'keycloak' LOGIN;
    CREATE SCHEMA keycloak;
    ALTER SCHEMA keycloak OWNER TO keycloak;
    ALTER ROLE keycloak SET search_path TO keycloak;
__EOSQL__
