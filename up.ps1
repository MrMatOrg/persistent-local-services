#
# Create local, persistent infrastructure

#
# Figure out the base directory in which the bind mounts need to happen is. 

$Env:INFRA_BASE=$PSScriptRoot
$Env:COMPOSE_FILE="${Env:INFRA_BASE}/persistent-local-infra.yml"
$Env:INFRA_PERSISTENCE_DB="${Env:INFRA_BASE}/data/db"
$Env:INFRA_PERSISTENCE_KEYCLOAK="${Env:INFRA_BASE}/data/keycloak"
docker compose up
